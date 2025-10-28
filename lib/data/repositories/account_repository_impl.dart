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

      final updated = account.copyWith(balance: newBalance);
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
  Future<bool> updateCreditUsed(int accountId, double newCreditUsed) async {
    try {
      final account = await getById(accountId);
      if (account == null) return false;

      final updated = account.copyWith(creditUsed: newCreditUsed);
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

  @override
  Future<AccountModel?> getDefaultAccount() async {
    return await (_db.select(_db.accounts)
          ..where((a) => a.isDefault.equals(true)))
        .getSingleOrNull();
  }

  @override
  Future<bool> setDefaultAccount(int accountId) async {
    try {
      // Use transaction to ensure atomicity (only one default at a time)
      await _db.transaction(() async {
        // Clear all default flags
        await (_db.update(_db.accounts)
              ..where((a) => a.isDefault.equals(true)))
            .write(const AccountModelCompanion(isDefault: Value(false)));

        // Set new default
        await (_db.update(_db.accounts)..where((a) => a.id.equals(accountId)))
            .write(const AccountModelCompanion(isDefault: Value(true)));
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearDefaultAccount() async {
    try {
      await (_db.update(_db.accounts)
            ..where((a) => a.isDefault.equals(true)))
          .write(const AccountModelCompanion(isDefault: Value(false)));
      return true;
    } catch (e) {
      return false;
    }
  }
}
