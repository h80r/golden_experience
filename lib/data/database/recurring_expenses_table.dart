import 'package:drift/drift.dart';

/// Drift table definition for recurring expenses
@DataClassName('RecurringExpenseModel')
class RecurringExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get value => real()();

  TextColumn get description => text()();

  IntColumn get chargeDay => integer()();

  IntColumn get accountId => integer()();

  IntColumn get categoryId => integer()();
}
