import 'package:drift/drift.dart';
import '../../data/datasources/local_database.dart';

/// Interface for Transaction repository operations
/// Defines CRUD operations and queries for Transaction entities
abstract class ITransactionRepository {
  /// Creates a new transaction
  /// Returns the ID of the created transaction
  Future<int> create(Insertable<TransactionModel> transaction);

  /// Retrieves a transaction by its ID
  /// Returns null if not found
  Future<TransactionModel?> getById(int id);

  /// Retrieves all transactions
  Future<List<TransactionModel>> getAll();

  /// Retrieves transactions for a specific month and year
  /// Returns list of transactions within the specified period
  Future<List<TransactionModel>> getByMonth(int month, int year);

  /// Updates an existing transaction
  /// Returns true if successful, false otherwise
  Future<bool> update(Insertable<TransactionModel> transaction);

  /// Deletes a transaction by its ID
  /// Returns true if successful, false otherwise
  Future<bool> delete(int id);

  /// Deletes every transaction in the database
  /// Returns the number of transactions deleted
  Future<int> deleteAll();

  /// Returns a stream of all transactions
  /// Updates automatically when data changes
  Stream<List<TransactionModel>> watchAll();

  /// Returns a stream of transactions for the current month
  /// Updates automatically when data changes
  Stream<List<TransactionModel>> watchCurrentMonth();

  /// Retrieves transactions within a specific date range
  /// Returns list of transactions between [startDate] and [endDate] (inclusive)
  Future<List<TransactionModel>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Returns a stream of transactions within a specific date range
  /// Updates automatically when data changes
  Stream<List<TransactionModel>> watchByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Retrieves transactions for a specific account within a date range
  /// Returns list of transactions for [accountId] between [startDate] and [endDate]
  Future<List<TransactionModel>> getByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Returns a stream of transactions for a specific account within a date range
  /// Updates automatically when data changes
  Stream<List<TransactionModel>> watchByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Creates an installment transaction with automatic generation of future installments
  ///
  /// Creates the current installment and automatically generates future installments
  /// across billing cycles. All installments share the same [installmentGroupId].
  ///
  /// Parameters:
  /// - [transaction]: The base transaction data (value, description, accountId, etc.)
  /// - [currentInstallment]: The current installment number (e.g., 8 for "8/12")
  /// - [totalInstallments]: Total number of installments (e.g., 12 for "8/12")
  /// - [accountId]: The credit account ID for billing cycle calculation
  ///
  /// Returns the generated installmentGroupId (UUID) for tracking all related installments
  Future<String> createInstallmentTransactions({
    required Insertable<TransactionModel> transaction,
    required int currentInstallment,
    required int totalInstallments,
    required int accountId,
  });

  /// Deletes all transactions in an installment group
  /// Returns the number of transactions deleted
  Future<int> deleteInstallmentGroup(String installmentGroupId);

  /// Retrieves all transactions in an installment group
  Future<List<TransactionModel>> getByInstallmentGroup(String installmentGroupId);
}
