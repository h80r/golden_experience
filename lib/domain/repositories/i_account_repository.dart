import 'package:drift/drift.dart';
import '../../data/datasources/local_database.dart';

/// Interface for Account repository operations
/// Defines CRUD operations and account management
abstract class IAccountRepository {
  /// Creates a new account
  /// Returns the ID of the created account
  Future<int> create(Insertable<AccountModel> account);

  /// Retrieves an account by its ID
  /// Returns null if not found
  Future<AccountModel?> getById(int id);

  /// Retrieves all accounts
  Future<List<AccountModel>> getAll();

  /// Updates an existing account
  /// Returns true if successful, false otherwise
  Future<bool> update(Insertable<AccountModel> account);

  /// Updates the balance of a debit account
  /// Returns true if successful, false otherwise
  Future<bool> updateBalance(int accountId, double newBalance);

  /// Updates the credit limit of a credit account
  /// Returns true if successful, false otherwise
  Future<bool> updateCreditLimit(int accountId, double newLimit);

  /// Updates the amount of credit used in a credit account
  /// Returns true if successful, false otherwise
  Future<bool> updateCreditUsed(int accountId, double newCreditUsed);

  /// Deletes an account by its ID
  /// Returns true if successful, false otherwise
  Future<bool> delete(int id);

  /// Checks if an account has any associated transactions
  /// Used to prevent deletion of accounts with transactions
  Future<bool> hasTransactions(int accountId);

  /// Returns a stream of all accounts
  /// Updates automatically when data changes
  Stream<List<AccountModel>> watchAll();
}
