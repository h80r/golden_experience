import 'package:isar/isar.dart';
import '../../domain/repositories/i_account_repository.dart';
import '../datasources/local_database.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';

/// Implementation of IAccountRepository using Isar database
class AccountRepositoryImpl implements IAccountRepository {
  final Isar _isar = LocalDatabase.instance;

  @override
  Future<int> create(AccountModel account) async {
    return await _isar.writeTxn(() async {
      return await _isar.accountModels.put(account);
    });
  }

  @override
  Future<AccountModel?> getById(int id) async {
    return await _isar.accountModels.get(id);
  }

  @override
  Future<List<AccountModel>> getAll() async {
    return await _isar.accountModels.where().findAll();
  }

  @override
  Future<bool> update(AccountModel account) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.accountModels.put(account);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateBalance(int accountId, double newBalance) async {
    try {
      final account = await getById(accountId);
      if (account == null) return false;

      account.initialBalance = newBalance;
      return await update(account);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateCreditLimit(int accountId, double newLimit) async {
    try {
      final account = await getById(accountId);
      if (account == null) return false;

      account.creditLimit = newLimit;
      return await update(account);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      return await _isar.writeTxn(() async {
        return await _isar.accountModels.delete(id);
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasTransactions(int accountId) async {
    final count = await _isar.transactionModels
        .where()
        .filter()
        .accountIdEqualTo(accountId)
        .count();
    return count > 0;
  }

  @override
  Stream<List<AccountModel>> watchAll() {
    return _isar.accountModels.where().watch(fireImmediately: true);
  }
}
