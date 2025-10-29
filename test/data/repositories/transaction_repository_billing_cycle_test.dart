import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/repositories/transaction_repository_impl.dart';
import 'package:drift/drift.dart';

void main() {
  late TransactionRepositoryImpl repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock path_provider method channel for Drift
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return '.';
      },
    );

    await LocalDatabase.initialize();
  });

  tearDownAll(() async {
    await LocalDatabase.closeDatabase();
  });

  setUp(() {
    repository = TransactionRepositoryImpl();
  });

  tearDown(() async {
    // Clean up test data after each test
    final db = LocalDatabase.instance;
    await db.delete(db.transactions).go();
    await db.delete(db.accounts).go();
    await db.delete(db.categories).go();
  });

  group('Transaction Repository - Billing Cycle Filtering', () {
    test('getByDateRange returns transactions within date range', () async {
      final db = LocalDatabase.instance;

      // Create test account and category
      final accountId = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Test Account',
              isDebit: const Value(true),
              isCredit: const Value(false),
              balance: const Value(1000.0),
            ),
          );

      final categoryId = await db.into(db.categories).insert(
            CategoryModelCompanion.insert(
              name: 'Test Category',
            ),
          );

      // Create transactions across different dates
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 100.0,
              description: 'Transaction 1',
              date: DateTime(2024, 11, 10),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 200.0,
              description: 'Transaction 2',
              date: DateTime(2024, 11, 20),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 300.0,
              description: 'Transaction 3',
              date: DateTime(2024, 12, 5),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      // Query transactions between Nov 15 and Nov 30
      final results = await repository.getByDateRange(
        DateTime(2024, 11, 15),
        DateTime(2024, 11, 30),
      );

      expect(results.length, 1);
      expect(results[0].description, 'Transaction 2');
      expect(results[0].value, 200.0);
    });

    test('getByDateRange includes transactions on boundary dates', () async {
      final db = LocalDatabase.instance;

      final accountId = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Test Account',
              isDebit: const Value(true),
            ),
          );

      final categoryId = await db.into(db.categories).insert(
            CategoryModelCompanion.insert(
              name: 'Test Category',
            ),
          );

      // Transaction on start date
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 100.0,
              description: 'Start Date Transaction',
              date: DateTime(2024, 11, 1),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      // Transaction on end date
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 200.0,
              description: 'End Date Transaction',
              date: DateTime(2024, 11, 30),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      // Transaction outside range
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 300.0,
              description: 'Outside Range',
              date: DateTime(2024, 12, 1),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      final results = await repository.getByDateRange(
        DateTime(2024, 11, 1),
        DateTime(2024, 11, 30),
      );

      expect(results.length, 2);
      expect(results.any((t) => t.description == 'Start Date Transaction'),
          isTrue);
      expect(
          results.any((t) => t.description == 'End Date Transaction'), isTrue);
      expect(results.any((t) => t.description == 'Outside Range'), isFalse);
    });

    test('getByAccountAndDateRange filters by account and date range',
        () async {
      final db = LocalDatabase.instance;

      final account1Id = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Account 1',
              isDebit: const Value(true),
            ),
          );

      final account2Id = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Account 2',
              isCredit: const Value(true),
              creditLimit: const Value(5000.0),
            ),
          );

      final categoryId = await db.into(db.categories).insert(
            CategoryModelCompanion.insert(
              name: 'Test Category',
            ),
          );

      // Account 1 transactions
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 100.0,
              description: 'Account 1 - In Range',
              date: DateTime(2024, 11, 15),
              accountId: account1Id,
              categoryId: categoryId,
            ),
          );

      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 150.0,
              description: 'Account 1 - Out of Range',
              date: DateTime(2024, 12, 5),
              accountId: account1Id,
              categoryId: categoryId,
            ),
          );

      // Account 2 transactions
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 200.0,
              description: 'Account 2 - In Range',
              date: DateTime(2024, 11, 20),
              accountId: account2Id,
              categoryId: categoryId,
            ),
          );

      // Query Account 1 transactions in November
      final results = await repository.getByAccountAndDateRange(
        account1Id,
        DateTime(2024, 11, 1),
        DateTime(2024, 11, 30),
      );

      expect(results.length, 1);
      expect(results[0].description, 'Account 1 - In Range');
      expect(results[0].accountId, account1Id);
    });

    test('watchByDateRange emits updates when transactions change', () async {
      final db = LocalDatabase.instance;

      final accountId = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Test Account',
              isDebit: const Value(true),
            ),
          );

      final categoryId = await db.into(db.categories).insert(
            CategoryModelCompanion.insert(
              name: 'Test Category',
            ),
          );

      // Start watching
      final stream = repository.watchByDateRange(
        DateTime(2024, 11, 1),
        DateTime(2024, 11, 30),
      );

      // Collect stream emissions
      final emissions = <List<TransactionModel>>[];
      final subscription = stream.listen((data) {
        emissions.add(data);
      });

      // Wait for initial emission
      await Future.delayed(const Duration(milliseconds: 100));
      expect(emissions.length, greaterThanOrEqualTo(1));
      expect(emissions.last.length, 0); // No transactions yet

      // Add a transaction
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 100.0,
              description: 'New Transaction',
              date: DateTime(2024, 11, 15),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      // Wait for stream update
      await Future.delayed(const Duration(milliseconds: 100));
      expect(emissions.last.length, 1);
      expect(emissions.last[0].description, 'New Transaction');

      await subscription.cancel();
    });

    test('watchByAccountAndDateRange emits updates for specific account',
        () async {
      final db = LocalDatabase.instance;

      final account1Id = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Account 1',
              isDebit: const Value(true),
            ),
          );

      final account2Id = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Account 2',
              isDebit: const Value(true),
            ),
          );

      final categoryId = await db.into(db.categories).insert(
            CategoryModelCompanion.insert(
              name: 'Test Category',
            ),
          );

      // Watch Account 1
      final stream = repository.watchByAccountAndDateRange(
        account1Id,
        DateTime(2024, 11, 1),
        DateTime(2024, 11, 30),
      );

      final emissions = <List<TransactionModel>>[];
      final subscription = stream.listen((data) {
        emissions.add(data);
      });

      await Future.delayed(const Duration(milliseconds: 100));

      // Add transaction to Account 2 (should NOT trigger emission for Account 1)
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 100.0,
              description: 'Account 2 Transaction',
              date: DateTime(2024, 11, 15),
              accountId: account2Id,
              categoryId: categoryId,
            ),
          );

      await Future.delayed(const Duration(milliseconds: 100));
      expect(emissions.last.length, 0); // Still no transactions for Account 1

      // Add transaction to Account 1 (should trigger emission)
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 200.0,
              description: 'Account 1 Transaction',
              date: DateTime(2024, 11, 20),
              accountId: account1Id,
              categoryId: categoryId,
            ),
          );

      await Future.delayed(const Duration(milliseconds: 100));
      expect(emissions.last.length, 1);
      expect(emissions.last[0].description, 'Account 1 Transaction');

      await subscription.cancel();
    });

    test('getByDateRange normalizes dates to day boundaries', () async {
      final db = LocalDatabase.instance;

      final accountId = await db.into(db.accounts).insert(
            AccountModelCompanion.insert(
              name: 'Test Account',
              isDebit: const Value(true),
            ),
          );

      final categoryId = await db.into(db.categories).insert(
            CategoryModelCompanion.insert(
              name: 'Test Category',
            ),
          );

      // Transaction at end of day
      await db.into(db.transactions).insert(
            TransactionModelCompanion.insert(
              value: 100.0,
              description: 'End of Day',
              date: DateTime(2024, 11, 30, 23, 59, 59),
              accountId: accountId,
              categoryId: categoryId,
            ),
          );

      // Query with time components (should be normalized)
      final results = await repository.getByDateRange(
        DateTime(2024, 11, 1, 10, 30),
        DateTime(2024, 11, 30, 14, 45),
      );

      expect(results.length, 1);
      expect(results[0].description, 'End of Day');
    });
  });
}
