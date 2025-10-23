import 'package:drift/drift.dart';

import '../../data/datasources/local_database.dart';
import '../repositories/i_account_repository.dart';
import '../repositories/i_transaction_repository.dart';

/// Result of adding a transaction
class AddTransactionResult {
  final bool success;
  final String? errorMessage;
  final int? transactionId;

  const AddTransactionResult({
    required this.success,
    this.errorMessage,
    this.transactionId,
  });

  factory AddTransactionResult.failure(String errorMessage) {
    return AddTransactionResult(
      success: false,
      errorMessage: errorMessage,
    );
  }

  factory AddTransactionResult.success(int transactionId) {
    return AddTransactionResult(
      success: true,
      transactionId: transactionId,
    );
  }
}

/// Use case for adding a new transaction to the system.
///
/// This use case orchestrates the following operations:
/// 1. Validates the transaction data
/// 2. Verifies the account exists
/// 3. Creates the transaction in the repository
/// 4. Updates the account balance (debit) and/or credit used (credit)
///
/// Business Rules:
/// - Transaction value must be positive (> 0)
/// - Description cannot be empty
/// - Account must exist
/// - For debit accounts (isDebit=true): Updates the balance (decreases)
/// - For credit accounts (isCredit=true): Updates creditUsed (increases used amount)
class AddTransactionUseCase {
  final ITransactionRepository _transactionRepository;
  final IAccountRepository _accountRepository;

  const AddTransactionUseCase({
    required ITransactionRepository transactionRepository,
    required IAccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the use case to add a new transaction.
  ///
  /// [value] - The transaction amount (must be > 0)
  /// [description] - Description of the transaction (cannot be empty)
  /// [date] - Date of the transaction
  /// [accountId] - ID of the account to charge
  /// [categoryId] - ID of the category for this transaction
  /// [notes] - Optional notes about the transaction
  ///
  /// Returns [AddTransactionResult] with success status and transaction ID or error message.
  Future<AddTransactionResult> execute({
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
        return AddTransactionResult.failure(validationError);
      }

      // Verify account exists
      final account = await _accountRepository.getById(accountId);
      if (account == null) {
        return AddTransactionResult.failure('Conta não encontrada');
      }

      // Create the transaction
      final transactionId = await _transactionRepository.create(
        TransactionModelCompanion.insert(
          value: value,
          description: description,
          date: date,
          accountId: accountId,
          categoryId: categoryId,
          notes: Value(notes),
        ),
      );

      // Update account balance/limit based on account type
      final updateSuccess = await _updateAccountAfterTransaction(
        account: account,
        transactionValue: value,
      );

      if (!updateSuccess) {
        // Rollback: delete the created transaction
        await _transactionRepository.delete(transactionId);
        return AddTransactionResult.failure(
          'Erro ao atualizar saldo/limite da conta',
        );
      }

      return AddTransactionResult.success(transactionId);
    } catch (e) {
      return AddTransactionResult.failure(
        'Erro inesperado ao adicionar transação: ${e.toString()}',
      );
    }
  }

  /// Updates the account balance (debit) and/or creditUsed (credit) after a transaction.
  ///
  /// For debit accounts: Decreases the balance
  /// For credit accounts: Increases the creditUsed (amount owed)
  ///
  /// Returns true if the update was successful, false otherwise.
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
        final creditUpdateSuccess = await _accountRepository.updateCreditUsed(
            account.id, newCreditUsed);
        if (!creditUpdateSuccess) return false;
      }

      return true;
    } catch (e) {
      return false;
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
}
