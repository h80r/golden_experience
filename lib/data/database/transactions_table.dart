import 'package:drift/drift.dart';

/// Drift table definition for transactions
@DataClassName('TransactionModel')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get value => real()();

  TextColumn get description => text()();

  DateTimeColumn get date => dateTime()();

  TextColumn get notes => text().nullable()();

  IntColumn get accountId => integer()();

  IntColumn get categoryId => integer()();

  /// Transaction type: 'debit' or 'credit'
  /// Determines whether the transaction affects account balance (debit) or credit used (credit)
  /// This is independent of the account type - dual-type accounts can have both transaction types
  TextColumn get transactionType =>
      text().withDefault(const Constant('credit'))();

  /// Installment number (e.g., 8 for "8/12")
  /// Null for non-installment transactions
  IntColumn get installmentNumber => integer().nullable()();

  /// Total number of installments (e.g., 12 for "8/12")
  /// Null for non-installment transactions
  IntColumn get installmentTotal => integer().nullable()();

  /// UUID to group related installment transactions
  /// All transactions in the same installment plan share the same group ID
  /// Null for non-installment transactions
  TextColumn get installmentGroupId => text().nullable()();
}
