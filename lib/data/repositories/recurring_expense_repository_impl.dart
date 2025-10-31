import 'package:drift/drift.dart';
import '../../domain/repositories/i_recurring_expense_repository.dart';
import '../datasources/local_database.dart';

/// Implementation of IRecurringExpenseRepository using Drift database
class RecurringExpenseRepositoryImpl implements IRecurringExpenseRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  @override
  Future<int> create(Insertable<RecurringExpenseModel> recurringExpense) async {
    return await _db.into(_db.recurringExpenses).insert(recurringExpense);
  }

  @override
  Future<RecurringExpenseModel?> getById(int id) async {
    return await (_db.select(_db.recurringExpenses)
          ..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<RecurringExpenseModel>> getAll() async {
    return await _db.select(_db.recurringExpenses).get();
  }

  @override
  Future<List<RecurringExpenseModel>> getByChargeDay(int day) async {
    return await (_db.select(_db.recurringExpenses)
          ..where((r) => r.chargeDay.equals(day)))
        .get();
  }

  @override
  Future<bool> update(
      Insertable<RecurringExpenseModel> recurringExpense) async {
    try {
      final result =
          await _db.update(_db.recurringExpenses).replace(recurringExpense);
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final result = await (_db.delete(_db.recurringExpenses)
            ..where((r) => r.id.equals(id)))
          .go();
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<RecurringExpenseModel>> watchAll() {
    return _db.select(_db.recurringExpenses).watch();
  }
}
