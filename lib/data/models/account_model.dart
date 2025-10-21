import 'package:isar/isar.dart';

part 'account_model.g.dart';

@collection
class AccountModel {
  Id id = Isar.autoIncrement;

  late String name;

  @Enumerated(EnumType.name)
  late AccountType type;

  late double initialBalance;

  late double creditLimit;

  AccountModel({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.creditLimit,
  });
}

enum AccountType {
  debit,
  credit,
}
