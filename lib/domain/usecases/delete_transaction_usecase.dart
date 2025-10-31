import '../../data/datasources/local_database.dart';
import '../repositories/i_account_repository.dart';
import '../repositories/i_transaction_repository.dart';

/// Result of deleting a transaction
class DeleteTransactionResult {
  final bool success;
  final String? errorMessage;

  const DeleteTransactionResult({
    required this.success,
    this.errorMessage,
  });

  factory DeleteTransactionResult.success() {
    return const DeleteTransactionResult(success: true);
  }

  factory DeleteTransactionResult.failure(String errorMessage) {
    return DeleteTransactionResult(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Use case for deleting a transaction.
///
/// This use case orchestrates the following operations:
/// 1. Retrieves the transaction to be deleted
/// 2. Reverses the account balance/credit effects
/// 3. Deletes the transaction from the repository
///
/// Business Rules:
/// - Only existing transactions can be deleted
/// - Account balance/credit must be reversed to maintain consistency
class DeleteTransactionUseCase {
  final ITransactionRepository _transactionRepository;
  final IAccountRepository _accountRepository;

  const DeleteTransactionUseCase({
    required ITransactionRepository transactionRepository,
    required IAccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the use case to delete a transaction.
  ///
  /// [id] - ID of the transaction to delete
  ///
  /// Returns [DeleteTransactionResult] with success status or error message.
  Future<DeleteTransactionResult> execute({
    required int id,
  }) async {
    try {
      // Get the transaction to be deleted
      final transaction = await _transactionRepository.getById(id);
      if (transaction == null) {
        return DeleteTransactionResult.failure('Transação não encontrada');
      }

      // Get the account to reverse its effects
      final account = await _accountRepository.getById(transaction.accountId);
      if (account == null) {
        return DeleteTransactionResult.failure('Conta não encontrada');
      }

      // Reverse the account balance/credit effects
      final reverseSuccess = await _reverseAccountUpdate(
        account: account,
        transactionValue: transaction.value,
      );

      if (!reverseSuccess) {
        return DeleteTransactionResult.failure(
          'Erro ao reverter o saldo/limite da conta',
        );
      }

      // Delete the transaction
      final deleteSuccess = await _transactionRepository.delete(id);
      if (!deleteSuccess) {
        return DeleteTransactionResult.failure(
          'Erro ao deletar a transação',
        );
      }

      return DeleteTransactionResult.success();
    } catch (e) {
      return DeleteTransactionResult.failure(
        'Erro inesperado ao deletar transação: ${e.toString()}',
      );
    }
  }

  /// Reverses the account update for a transaction (adds back the transaction value).
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
        final creditUpdateSuccess = await _accountRepository.updateCreditUsed(
            account.id, newCreditUsed);
        if (!creditUpdateSuccess) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
