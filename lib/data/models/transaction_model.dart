import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late double value;

  late String description;

  late DateTime date;

  String? notes;

  late int accountId;

  late int categoryId;

  TransactionModel({
    this.id = Isar.autoIncrement,
    required this.value,
    required this.description,
    required this.date,
    this.notes,
    required this.accountId,
    required this.categoryId,
  });
}
