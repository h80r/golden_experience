import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/repositories/account_repository_impl.dart';
import 'package:golden_experience/domain/repositories/i_account_repository.dart';

void main() {
  late IAccountRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return '.';
      },
    );

    await LocalDatabase.initialize();
    repository = AccountRepositoryImpl();
  });

  tearDownAll(() async {
    await LocalDatabase.closeDatabase();
  });

  group('AccountRepositoryImpl', () {
    test('should create a new debit account', () async {
      final account = AccountModelCompanion.insert(
        name: 'Test Debit Account',
        isDebit: Value(true),
        isCredit: Value(false),
        balance: Value(1000.0),
        creditLimit: Value(0.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      expect(id, greaterThan(0));
    });

    test('should create a new credit account', () async {
      final account = AccountModelCompanion.insert(
        name: 'Test Credit Account',
        isDebit: Value(false),
        isCredit: Value(true),
        balance: Value(0.0),
        creditLimit: Value(5000.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      expect(id, greaterThan(0));
    });

    test('should create a dual-type account', () async {
      final account = AccountModelCompanion.insert(
        name: 'Test Dual-Type Account',
        isDebit: Value(true),
        isCredit: Value(true),
        balance: Value(1000.0),
        creditLimit: Value(5000.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      expect(id, greaterThan(0));
    });

    test('should retrieve an account by id', () async {
      final account = AccountModelCompanion.insert(
        name: 'Get by ID Account',
        isDebit: Value(false),
        isCredit: Value(true),
        balance: Value(0.0),
        creditLimit: Value(5000.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      final retrieved = await repository.getById(id);

      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Get by ID Account'));
      expect(retrieved.isCredit, isTrue);
      expect(retrieved.isDebit, isFalse);
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
        isDebit: Value(true),
        isCredit: Value(false),
        balance: Value(500.0),
        creditLimit: Value(0.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
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
        isDebit: Value(true),
        isCredit: Value(false),
        balance: Value(1000.0),
        creditLimit: Value(0.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      final success = await repository.updateBalance(id, 1500.0);

      expect(success, isTrue);

      final updated = await repository.getById(id);
      expect(updated!.balance, equals(1500.0));
    });

    test('should update credit used', () async {
      final account = AccountModelCompanion.insert(
        name: 'Credit Account',
        isDebit: Value(false),
        isCredit: Value(true),
        balance: Value(0.0),
        creditLimit: Value(2000.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      final success = await repository.updateCreditUsed(id, 500.0);

      expect(success, isTrue);

      final updated = await repository.getById(id);
      expect(updated!.creditUsed, equals(500.0));
    });

    test('should update credit limit', () async {
      final account = AccountModelCompanion.insert(
        name: 'Credit Limit Account',
        isDebit: Value(false),
        isCredit: Value(true),
        balance: Value(0.0),
        creditLimit: Value(2000.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
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
        isDebit: Value(true),
        isCredit: Value(false),
        balance: Value(100.0),
        creditLimit: Value(0.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      final success = await repository.delete(id);

      expect(success, isTrue);

      final deleted = await repository.getById(id);
      expect(deleted, isNull);
    });

    test('should create account with excludeFromReserve flag', () async {
      final account = AccountModelCompanion.insert(
        name: 'Test Excluded Account',
        isDebit: Value(true),
        isCredit: Value(false),
        balance: Value(5000.0),
        creditLimit: Value(0.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
        excludeFromReserve: const Value(true),
      );

      final id = await repository.create(account);
      expect(id, greaterThan(0));

      final retrieved = await repository.getById(id);
      expect(retrieved, isNotNull);
      expect(retrieved!.excludeFromReserve, isTrue);
    });

    test('should create account with default excludeFromReserve as false',
        () async {
      final account = AccountModelCompanion.insert(
        name: 'Test Default Excluded Account',
        isDebit: Value(true),
        isCredit: Value(false),
        balance: Value(2000.0),
        creditLimit: Value(0.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
      );

      final id = await repository.create(account);
      expect(id, greaterThan(0));

      final retrieved = await repository.getById(id);
      expect(retrieved, isNotNull);
      expect(retrieved!.excludeFromReserve, isFalse);
    });

    test('should update account excludeFromReserve flag', () async {
      final account = AccountModelCompanion.insert(
        name: 'Test Update Excluded',
        isDebit: Value(true),
        isCredit: Value(false),
        balance: Value(3000.0),
        creditLimit: Value(0.0),
        creditUsed: Value(0.0),
        isDefault: const Value(false),
        excludeFromReserve: const Value(false),
      );

      final id = await repository.create(account);
      final retrieved = await repository.getById(id);
      expect(retrieved!.excludeFromReserve, isFalse);

      final updated = retrieved.copyWith(excludeFromReserve: true);
      final success = await repository.update(updated);

      expect(success, isTrue);

      final result = await repository.getById(id);
      expect(result!.excludeFromReserve, isTrue);
    });

    test('should watch all accounts stream', () async {
      final stream = repository.watchAll();
      expect(stream, isA<Stream<List<AccountModel>>>());

      final firstValue = await stream.first;
      expect(firstValue, isA<List<AccountModel>>());
    });
  });
}
