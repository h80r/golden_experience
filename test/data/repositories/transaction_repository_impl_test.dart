import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/database/transactions_table.dart';
import 'package:golden_experience/data/repositories/transaction_repository_impl.dart';
import 'package:golden_experience/domain/repositories/i_transaction_repository.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;

void main() {
  late ITransactionRepository repository;

  setUpAll(() async {
    // Initialize Flutter bindings
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock the path_provider method channel
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });

    // Initialize test database
    await LocalDatabase.initialize();
    repository = TransactionRepositoryImpl();
  });

  tearDownAll(() async {
    // Clean up database
    await LocalDatabase.closeDatabase();
  });

  group('TransactionRepositoryImpl', () {
    test('should create a new transaction', () async {
      final transaction = TransactionModelCompanion.insert(
        value: 100.0,
        description: 'Test transaction',
        date: DateTime.now(),
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(transaction);
      expect(id, greaterThan(0));
    });

    test('should retrieve a transaction by id', () async {
      final transaction = TransactionModelCompanion.insert(
        value: 50.0,
        description: 'Get by ID test',
        date: DateTime.now(),
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(transaction);
      final retrieved = await repository.getById(id);

      expect(retrieved, isNotNull);
      expect(retrieved!.value, equals(50.0));
      expect(retrieved.description, equals('Get by ID test'));
    });

    test('should return null for non-existent transaction', () async {
      final retrieved = await repository.getById(99999);
      expect(retrieved, isNull);
    });

    test('should retrieve all transactions', () async {
      final transactions = await repository.getAll();
      expect(transactions, isNotEmpty);
    });

    test('should retrieve transactions by month', () async {
      final now = DateTime.now();
      final transaction = TransactionModelCompanion.insert(
        value: 75.0,
        description: 'Monthly test',
        date: now,
        accountId: 1,
        categoryId: 1,
      );

      await repository.create(transaction);
      final monthlyTransactions =
          await repository.getByMonth(now.month, now.year);

      expect(monthlyTransactions, isNotEmpty);
      expect(
        monthlyTransactions.any((t) => t.description == 'Monthly test'),
        isTrue,
      );
    });

    test('should update a transaction', () async {
      final transaction = TransactionModelCompanion.insert(
        value: 100.0,
        description: 'Update test',
        date: DateTime.now(),
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(transaction);
      final retrieved = await repository.getById(id);

      final updatedTransaction = retrieved!.copyWith(value: 150.0);
      final success = await repository.update(updatedTransaction);

      expect(success, isTrue);

      final result = await repository.getById(id);
      expect(result!.value, equals(150.0));
    });

    test('should delete a transaction', () async {
      final transaction = TransactionModelCompanion.insert(
        value: 200.0,
        description: 'Delete test',
        date: DateTime.now(),
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(transaction);
      final success = await repository.delete(id);

      expect(success, isTrue);

      final deleted = await repository.getById(id);
      expect(deleted, isNull);
    });

    test('should watch all transactions stream', () async {
      final stream = repository.watchAll();
      expect(stream, isA<Stream<List<TransactionModel>>>());

      final firstValue = await stream.first;
      expect(firstValue, isA<List<TransactionModel>>());
    });

    test('should watch current month transactions stream', () async {
      final stream = repository.watchCurrentMonth();
      expect(stream, isA<Stream<List<TransactionModel>>>());

      final firstValue = await stream.first;
      expect(firstValue, isA<List<TransactionModel>>());
    });
  });
}
