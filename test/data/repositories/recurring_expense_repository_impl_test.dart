import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/repositories/recurring_expense_repository_impl.dart';
import 'package:golden_experience/domain/repositories/i_recurring_expense_repository.dart';

void main() {
  late IRecurringExpenseRepository repository;

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
    repository = RecurringExpenseRepositoryImpl();
  });

  tearDownAll(() async {
    await LocalDatabase.closeDatabase();
  });

  group('RecurringExpenseRepositoryImpl', () {
    test('should create a new recurring expense', () async {
      final expense = RecurringExpenseModelCompanion.insert(
        value: 500.0,
        description: 'Rent',
        chargeDay: 5,
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(expense);
      expect(id, greaterThan(0));
    });

    test('should retrieve a recurring expense by id', () async {
      final expense = RecurringExpenseModelCompanion.insert(
        value: 100.0,
        description: 'Internet',
        chargeDay: 10,
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(expense);
      final retrieved = await repository.getById(id);

      expect(retrieved, isNotNull);
      expect(retrieved!.value, equals(100.0));
      expect(retrieved.description, equals('Internet'));
      expect(retrieved.chargeDay, equals(10));
    });

    test('should return null for non-existent recurring expense', () async {
      final retrieved = await repository.getById(99999);
      expect(retrieved, isNull);
    });

    test('should retrieve all recurring expenses', () async {
      final expenses = await repository.getAll();
      expect(expenses, isNotEmpty);
    });

    test('should retrieve recurring expenses by charge day', () async {
      final expense = RecurringExpenseModelCompanion.insert(
        value: 200.0,
        description: 'Electricity',
        chargeDay: 15,
        accountId: 1,
        categoryId: 1,
      );

      await repository.create(expense);
      final dayExpenses = await repository.getByChargeDay(15);

      expect(dayExpenses, isNotEmpty);
      expect(
        dayExpenses.any((e) => e.description == 'Electricity'),
        isTrue,
      );
    });

    test('should update a recurring expense', () async {
      final expense = RecurringExpenseModelCompanion.insert(
        value: 300.0,
        description: 'Water',
        chargeDay: 20,
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(expense);
      final retrieved = await repository.getById(id);

      final updatedExpense = retrieved!.copyWith(value: 350.0);
      final success = await repository.update(updatedExpense);

      expect(success, isTrue);

      final updated = await repository.getById(id);
      expect(updated!.value, equals(350.0));
    });

    test('should delete a recurring expense', () async {
      final expense = RecurringExpenseModelCompanion.insert(
        value: 150.0,
        description: 'Gas',
        chargeDay: 25,
        accountId: 1,
        categoryId: 1,
      );

      final id = await repository.create(expense);
      final success = await repository.delete(id);

      expect(success, isTrue);

      final deleted = await repository.getById(id);
      expect(deleted, isNull);
    });

    test('should watch all recurring expenses stream', () async {
      final stream = repository.watchAll();
      expect(stream, isA<Stream<List<RecurringExpenseModel>>>());

      final firstValue = await stream.first;
      expect(firstValue, isA<List<RecurringExpenseModel>>());
    });
  });
}
