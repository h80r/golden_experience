import 'package:drift/drift.dart';
import '../../domain/repositories/i_account_repository.dart';
import '../datasources/local_database.dart';

/// Implementation of IAccountRepository using Drift database
class AccountRepositoryImpl implements IAccountRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  @override
  Future<int> create(Insertable<AccountModel> account) async {
    return await _db.into(_db.accounts).insert(account);
  }

  @override
  Future<AccountModel?> getById(int id) async {
    return await (_db.select(_db.accounts)..where((a) => a.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<AccountModel>> getAll() async {
    return await _db.select(_db.accounts).get();
  }

  @override
  Future<bool> update(Insertable<AccountModel> account) async {
    try {
      final result = await _db.update(_db.accounts).replace(account);
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateBalance(int accountId, double newBalance) async {
    try {
      final account = await getById(accountId);
      if (account == null) return false;

      final updated = account.copyWith(initialBalance: newBalance);
      return await update(updated);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateCreditLimit(int accountId, double newLimit) async {
    try {
      final account = await getById(accountId);
      if (account == null) return false;

      final updated = account.copyWith(creditLimit: newLimit);
      return await update(updated);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final result =
          await (_db.delete(_db.accounts)..where((a) => a.id.equals(id))).go();
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasTransactions(int accountId) async {
    final transactions = await (_db.select(_db.transactions)
          ..where((t) => t.accountId.equals(accountId))
          ..limit(1))
        .get();

    return transactions.isNotEmpty;
  }

  @override
  Stream<List<AccountModel>> watchAll() {
    return _db.select(_db.accounts).watch();
  }
}
