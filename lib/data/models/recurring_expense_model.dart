import 'package:isar/isar.dart';

part 'recurring_expense_model.g.dart';

@collection
class RecurringExpenseModel {
  Id id = Isar.autoIncrement;

  late double value;

  late String description;

  late int chargeDay;

  late int accountId;

  late int categoryId;

  RecurringExpenseModel({
    this.id = Isar.autoIncrement,
    required this.value,
    required this.description,
    required this.chargeDay,
    required this.accountId,
    required this.categoryId,
  });
}
