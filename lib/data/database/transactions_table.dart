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
}
