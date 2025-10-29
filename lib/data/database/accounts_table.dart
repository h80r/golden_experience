import 'package:drift/drift.dart';

/// Drift table definition for accounts
/// Supports dual-type accounts (can be both debit and credit simultaneously)
@DataClassName('AccountModel')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  // Dual-type support: account can be both debit and credit
  BoolColumn get isDebit => boolean().withDefault(Constant(true))();

  BoolColumn get isCredit => boolean().withDefault(Constant(false))();

  // Balance for debit operations
  RealColumn get balance => real().withDefault(Constant(0.0))();

  // Credit limit for credit operations
  RealColumn get creditLimit => real().withDefault(Constant(0.0))();

  // Amount of credit used (for credit accounts)
  RealColumn get creditUsed => real().withDefault(Constant(0.0))();

  // Default account flag (only one account should be default at a time)
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  // Credit card closing day (1-31, applicable only for credit accounts)
  IntColumn get creditClosingDay => integer().nullable()();

  // Exclude from reserve calculation (applicable only for debit accounts)
  // When true, this account's balance will not be counted in the reserve calculation
  BoolColumn get excludeFromReserve =>
      boolean().withDefault(const Constant(false))();
}
