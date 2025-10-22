import 'package:drift/drift.dart';
import '../../data/datasources/local_database.dart';
import '../repositories/i_account_repository.dart';
import '../repositories/i_transaction_repository.dart';

/// Result of updating a transaction
class UpdateTransactionResult {
  final bool success;
  final String? errorMessage;

  const UpdateTransactionResult({
    required this.success,
    this.errorMessage,
  });

  factory UpdateTransactionResult.success() {
    return const UpdateTransactionResult(success: true);
  }

  factory UpdateTransactionResult.failure(String errorMessage) {
    return UpdateTransactionResult(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Use case for updating an existing transaction.
///
/// This use case orchestrates the following operations:
/// 1. Validates the transaction data
/// 2. Retrieves the old transaction to reverse its effects
/// 3. Updates the transaction in the repository
/// 4. Updates the account balance to reflect the change
///
/// Business Rules:
/// - Transaction value must be positive (> 0)
/// - Description cannot be empty
/// - Account must exist
/// - Updates the difference in account balance/credit used
class UpdateTransactionUseCase {
  final ITransactionRepository _transactionRepository;
  final IAccountRepository _accountRepository;

  const UpdateTransactionUseCase({
    required ITransactionRepository transactionRepository,
    required IAccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the use case to update a transaction.
  ///
  /// [id] - ID of the transaction to update
  /// [value] - The new transaction amount (must be > 0)
  /// [description] - New description of the transaction (cannot be empty)
  /// [date] - New date of the transaction
  /// [accountId] - ID of the account to charge (may change)
  /// [categoryId] - ID of the category for this transaction
  /// [notes] - Optional notes about the transaction
  ///
  /// Returns [UpdateTransactionResult] with success status or error message.
  Future<UpdateTransactionResult> execute({
    required int id,
    required double value,
    required String description,
    required DateTime date,
    required int accountId,
    required int categoryId,
    String? notes,
  }) async {
    try {
      // Validate business rules
      final validationError = _validateInput(
        value: value,
        description: description,
      );
      if (validationError != null) {
        return UpdateTransactionResult.failure(validationError);
      }

      // Get the old transaction to reverse its effects
      final oldTransaction = await _transactionRepository.getById(id);
      if (oldTransaction == null) {
        return UpdateTransactionResult.failure('Transação não encontrada');
      }

      // Verify new account exists
      final newAccount = await _accountRepository.getById(accountId);
      if (newAccount == null) {
        return UpdateTransactionResult.failure('Conta não encontrada');
      }

      // Update the transaction
      final success = await _transactionRepository.update(
        TransactionModelCompanion(
          id: Value(id),
          value: Value(value),
          description: Value(description),
          date: Value(date),
          accountId: Value(accountId),
          categoryId: Value(categoryId),
          notes: Value(notes),
        ),
      );

      if (!success) {
        return UpdateTransactionResult.failure(
          'Erro ao atualizar transação no banco',
        );
      }

      // If the account changed, update both old and new accounts
      if (oldTransaction.accountId != accountId) {
        // Reverse the effect on the old account
        final oldAccount = await _accountRepository.getById(oldTransaction.accountId);
        if (oldAccount != null) {
          await _reverseAccountUpdate(
            account: oldAccount,
            transactionValue: oldTransaction.value,
          );
        }

        // Apply the effect on the new account
        await _updateAccountAfterTransaction(
          account: newAccount,
          transactionValue: value,
        );
      } else {
        // Same account - calculate the difference
        final valueDifference = value - oldTransaction.value;
        await _updateAccountByDifference(
          account: newAccount,
          valueDifference: valueDifference,
        );
      }

      return UpdateTransactionResult.success();
    } catch (e) {
      return UpdateTransactionResult.failure(
        'Erro inesperado ao atualizar transação: ${e.toString()}',
      );
    }
  }

  /// Validates the input parameters according to business rules.
  ///
  /// Returns null if valid, or an error message if validation fails.
  String? _validateInput({
    required double value,
    required String description,
  }) {
    if (value <= 0) {
      return 'O valor da transação deve ser maior que zero';
    }

    if (description.trim().isEmpty) {
      return 'A descrição da transação não pode estar vazia';
    }

    return null;
  }

  /// Updates the account balance/credit based on a new transaction value.
  ///
  /// For debit accounts: Decreases the balance
  /// For credit accounts: Increases the creditUsed (amount owed)
  Future<bool> _updateAccountAfterTransaction({
    required AccountModel account,
    required double transactionValue,
  }) async {
    try {
      // Handle debit account update
      if (account.isDebit) {
        final newBalance = account.balance - transactionValue;
        final debitUpdateSuccess =
            await _accountRepository.updateBalance(account.id, newBalance);
        if (!debitUpdateSuccess) return false;
      }

      // Handle credit account update
      if (account.isCredit) {
        final newCreditUsed = account.creditUsed + transactionValue;
        final creditUpdateSuccess =
            await _accountRepository.updateCreditUsed(account.id, newCreditUsed);
        if (!creditUpdateSuccess) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reverses the account update for a transaction (used when changing accounts).
  ///
  /// For debit accounts: Increases the balance (reverses deduction)
  /// For credit accounts: Decreases the creditUsed (reverses charge)
  Future<bool> _reverseAccountUpdate({
    required AccountModel account,
    required double transactionValue,
  }) async {
    try {
      // Reverse debit account update
      if (account.isDebit) {
        final newBalance = account.balance + transactionValue;
        final debitUpdateSuccess =
            await _accountRepository.updateBalance(account.id, newBalance);
        if (!debitUpdateSuccess) return false;
      }

      // Reverse credit account update
      if (account.isCredit) {
        final newCreditUsed = account.creditUsed - transactionValue;
        final creditUpdateSuccess =
            await _accountRepository.updateCreditUsed(account.id, newCreditUsed);
        if (!creditUpdateSuccess) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates the account balance/credit by the difference between old and new values.
  ///
  /// Used when the account stays the same but the value changes.
  Future<bool> _updateAccountByDifference({
    required AccountModel account,
    required double valueDifference,
  }) async {
    try {
      // Handle debit account update
      if (account.isDebit) {
        final newBalance = account.balance - valueDifference;
        final debitUpdateSuccess =
            await _accountRepository.updateBalance(account.id, newBalance);
        if (!debitUpdateSuccess) return false;
      }

      // Handle credit account update
      if (account.isCredit) {
        final newCreditUsed = account.creditUsed + valueDifference;
        final creditUpdateSuccess =
            await _accountRepository.updateCreditUsed(account.id, newCreditUsed);
        if (!creditUpdateSuccess) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
