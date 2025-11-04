import 'package:drift/drift.dart';

/// Drift table definition for invoices
/// Represents a unified billing period across all credit accounts
///
/// Simplified schema for F17-T1: Invoice Manager with Time Navigation
/// - Periods are calculated dynamically based on all credit cards
/// - Start date = EARLIEST billing cycle start across all credit accounts
/// - End date = LATEST billing cycle end across all credit accounts
/// - All monetary values are calculated dynamically via queries
@DataClassName('InvoiceModel')
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Start date of the unified billing period
  /// Calculated as the earliest start date among all credit accounts
  DateTimeColumn get startDate => dateTime()();

  /// End date of the unified billing period
  /// Calculated as the latest end date among all credit accounts
  DateTimeColumn get endDate => dateTime()();

  /// Payment status flag
  /// True if the invoice has been marked as paid
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [
    'UNIQUE(start_date, end_date)',
  ];
}
