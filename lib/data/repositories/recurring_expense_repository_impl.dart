import 'package:isar/isar.dart';
import '../../domain/repositories/i_recurring_expense_repository.dart';
import '../datasources/local_database.dart';
import '../models/recurring_expense_model.dart';

/// Implementation of IRecurringExpenseRepository using Isar database
class RecurringExpenseRepositoryImpl implements IRecurringExpenseRepository {
  final Isar _isar = LocalDatabase.instance;

  @override
  Future<int> create(RecurringExpenseModel recurringExpense) async {
    return await _isar.writeTxn(() async {
      return await _isar.recurringExpenseModels.put(recurringExpense);
    });
  }

  @override
  Future<RecurringExpenseModel?> getById(int id) async {
    return await _isar.recurringExpenseModels.get(id);
  }

  @override
  Future<List<RecurringExpenseModel>> getAll() async {
    return await _isar.recurringExpenseModels.where().findAll();
  }

  @override
  Future<List<RecurringExpenseModel>> getByChargeDay(int day) async {
    return await _isar.recurringExpenseModels
        .where()
        .filter()
        .chargeDayEqualTo(day)
        .findAll();
  }

  @override
  Future<bool> update(RecurringExpenseModel recurringExpense) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.recurringExpenseModels.put(recurringExpense);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      return await _isar.writeTxn(() async {
        return await _isar.recurringExpenseModels.delete(id);
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<RecurringExpenseModel>> watchAll() {
    return _isar.recurringExpenseModels.where().watch(fireImmediately: true);
  }
}
