import '../../../data/models/recurring_expense_model.dart';

/// Interface for RecurringExpense repository operations
/// Defines CRUD operations and queries for recurring expenses
abstract class IRecurringExpenseRepository {
  /// Creates a new recurring expense
  /// Returns the ID of the created recurring expense
  Future<int> create(RecurringExpenseModel recurringExpense);

  /// Retrieves a recurring expense by its ID
  /// Returns null if not found
  Future<RecurringExpenseModel?> getById(int id);

  /// Retrieves all recurring expenses
  Future<List<RecurringExpenseModel>> getAll();

  /// Retrieves recurring expenses by charge day
  /// Used to process expenses on specific days
  Future<List<RecurringExpenseModel>> getByChargeDay(int day);

  /// Updates an existing recurring expense
  /// Returns true if successful, false otherwise
  Future<bool> update(RecurringExpenseModel recurringExpense);

  /// Deletes a recurring expense by its ID
  /// Returns true if successful, false otherwise
  Future<bool> delete(int id);

  /// Returns a stream of all recurring expenses
  /// Updates automatically when data changes
  Stream<List<RecurringExpenseModel>> watchAll();
}
