import 'package:isar/isar.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../datasources/local_database.dart';
import '../models/transaction_model.dart';

/// Implementation of ITransactionRepository using Isar database
class TransactionRepositoryImpl implements ITransactionRepository {
  final Isar _isar = LocalDatabase.instance;

  @override
  Future<int> create(TransactionModel transaction) async {
    return await _isar.writeTxn(() async {
      return await _isar.transactionModels.put(transaction);
    });
  }

  @override
  Future<TransactionModel?> getById(int id) async {
    return await _isar.transactionModels.get(id);
  }

  @override
  Future<List<TransactionModel>> getAll() async {
    return await _isar.transactionModels.where().findAll();
  }

  @override
  Future<List<TransactionModel>> getByMonth(int month, int year) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1).subtract(Duration(seconds: 1));

    return await _isar.transactionModels
        .where()
        .filter()
        .dateBetween(startDate, endDate, includeLower: true, includeUpper: true)
        .findAll();
  }

  @override
  Future<bool> update(TransactionModel transaction) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.transactionModels.put(transaction);
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
        return await _isar.transactionModels.delete(id);
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<TransactionModel>> watchAll() {
    return _isar.transactionModels.where().watch(fireImmediately: true);
  }

  @override
  Stream<List<TransactionModel>> watchCurrentMonth() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 1).subtract(Duration(seconds: 1));

    return _isar.transactionModels
        .where()
        .filter()
        .dateBetween(startDate, endDate, includeLower: true, includeUpper: true)
        .watch(fireImmediately: true);
  }
}
