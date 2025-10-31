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
}
