import 'package:drift/drift.dart';

/// Account type enum - debit or credit
enum AccountType {
  debit,
  credit,
}

/// Drift table definition for accounts
@DataClassName('AccountModel')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get type => intEnum<AccountType>()();

  RealColumn get initialBalance => real()();

  RealColumn get creditLimit => real()();
}
