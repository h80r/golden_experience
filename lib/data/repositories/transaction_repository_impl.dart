import 'package:drift/drift.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../datasources/local_database.dart';

/// Implementation of ITransactionRepository using Drift database
class TransactionRepositoryImpl implements ITransactionRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  @override
  Future<int> create(Insertable<TransactionModel> transaction) async {
    return await _db.into(_db.transactions).insert(transaction);
  }

  @override
  Future<TransactionModel?> getById(int id) async {
    return await (_db.select(_db.transactions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<TransactionModel>> getAll() async {
    return await _db.select(_db.transactions).get();
  }

  @override
  Future<List<TransactionModel>> getByMonth(int month, int year) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1).subtract(Duration(seconds: 1));

    return await (_db.select(_db.transactions)
          ..where((t) => t.date.isBetweenValues(startDate, endDate)))
        .get();
  }

  @override
  Future<bool> update(Insertable<TransactionModel> transaction) async {
    try {
      final result = await _db.update(_db.transactions).replace(transaction);
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final result = await (_db.delete(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .go();
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<TransactionModel>> watchAll() {
    return _db.select(_db.transactions).watch();
  }

  @override
  Stream<List<TransactionModel>> watchCurrentMonth() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 1).subtract(Duration(seconds: 1));

    return (_db.select(_db.transactions)
          ..where((t) => t.date.isBetweenValues(startDate, endDate)))
        .watch();
  }

  @override
  Future<List<TransactionModel>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return await (_db.select(_db.transactions)
          ..where((t) => t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .get();
  }

  @override
  Stream<List<TransactionModel>> watchByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return (_db.select(_db.transactions)
          ..where((t) => t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .watch();
  }

  @override
  Future<List<TransactionModel>> getByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return await (_db.select(_db.transactions)
          ..where((t) =>
              t.accountId.equals(accountId) &
              t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .get();
  }

  @override
  Stream<List<TransactionModel>> watchByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return (_db.select(_db.transactions)
          ..where((t) =>
              t.accountId.equals(accountId) &
              t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .watch();
  }
}
