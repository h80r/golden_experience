import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/database/accounts_table.dart';
import 'package:golden_experience/data/repositories/account_repository_impl.dart';
import 'package:golden_experience/domain/repositories/i_account_repository.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;

void main() {
  late IAccountRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });

    await LocalDatabase.initialize();
    repository = AccountRepositoryImpl();
  });

  tearDownAll(() async {
    await LocalDatabase.closeDatabase();
  });

  group('AccountRepositoryImpl', () {
    test('should create a new account', () async {
      final account = AccountModelCompanion.insert(
        name: 'Test Account',
        type: AccountType.debit,
        initialBalance: 1000.0,
        creditLimit: 0.0,
      );

      final id = await repository.create(account);
      expect(id, greaterThan(0));
    });

    test('should retrieve an account by id', () async {
      final account = AccountModelCompanion.insert(
        name: 'Get by ID Account',
        type: AccountType.credit,
        initialBalance: 0.0,
        creditLimit: 5000.0,
      );

      final id = await repository.create(account);
      final retrieved = await repository.getById(id);

      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Get by ID Account'));
      expect(retrieved.type, equals(AccountType.credit));
    });

    test('should return null for non-existent account', () async {
      final retrieved = await repository.getById(99999);
      expect(retrieved, isNull);
    });

    test('should retrieve all accounts', () async {
      final accounts = await repository.getAll();
      expect(accounts, isNotEmpty);
    });

    test('should update an account', () async {
      final account = AccountModelCompanion.insert(
        name: 'Update Account',
        type: AccountType.debit,
        initialBalance: 500.0,
        creditLimit: 0.0,
      );

      final id = await repository.create(account);
      final retrieved = await repository.getById(id);

      final updatedAccount = retrieved!.copyWith(name: 'Updated Account');
      final success = await repository.update(updatedAccount);

      expect(success, isTrue);

      final result = await repository.getById(id);
      expect(result!.name, equals('Updated Account'));
    });

    test('should update account balance', () async {
      final account = AccountModelCompanion.insert(
        name: 'Balance Account',
        type: AccountType.debit,
        initialBalance: 1000.0,
        creditLimit: 0.0,
      );

      final id = await repository.create(account);
      final success = await repository.updateBalance(id, 1500.0);

      expect(success, isTrue);

      final updated = await repository.getById(id);
      expect(updated!.initialBalance, equals(1500.0));
    });

    test('should update credit limit', () async {
      final account = AccountModelCompanion.insert(
        name: 'Credit Account',
        type: AccountType.credit,
        initialBalance: 0.0,
        creditLimit: 2000.0,
      );

      final id = await repository.create(account);
      final success = await repository.updateCreditLimit(id, 3000.0);

      expect(success, isTrue);

      final updated = await repository.getById(id);
      expect(updated!.creditLimit, equals(3000.0));
    });

    test('should delete an account', () async {
      final account = AccountModelCompanion.insert(
        name: 'Delete Account',
        type: AccountType.debit,
        initialBalance: 100.0,
        creditLimit: 0.0,
      );

      final id = await repository.create(account);
      final success = await repository.delete(id);

      expect(success, isTrue);

      final deleted = await repository.getById(id);
      expect(deleted, isNull);
    });

    test('should watch all accounts stream', () async {
      final stream = repository.watchAll();
      expect(stream, isA<Stream<List<AccountModel>>>());

      final firstValue = await stream.first;
      expect(firstValue, isA<List<AccountModel>>());
    });
  });
}
