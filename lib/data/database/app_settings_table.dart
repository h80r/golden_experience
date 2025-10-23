import 'package:drift/drift.dart';

/// Drift table definition for app settings
/// Only one row should exist (id = 1)
@DataClassName('AppSettingsModel')
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  RealColumn get monthlySalary => real()();

  RealColumn get reserveBalance => real()();

  RealColumn get maxReserveUsagePercentage => real()();

  DateTimeColumn get lastRecurringCheck => dateTime()();

  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isAutoCaptureEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
