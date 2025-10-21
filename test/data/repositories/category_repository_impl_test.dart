import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/models/category_model.dart';
import 'package:golden_experience/data/repositories/category_repository_impl.dart';
import 'package:golden_experience/domain/repositories/i_category_repository.dart';

void main() {
  late ICategoryRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });

    await LocalDatabase.initialize();
    repository = CategoryRepositoryImpl();
  });

  tearDownAll(() async {
    await LocalDatabase.close();
  });

  group('CategoryRepositoryImpl', () {
    test('should create a new category', () async {
      final category = CategoryModel(name: 'Test Category');

      final id = await repository.create(category);
      expect(id, greaterThan(0));
    });

    test('should retrieve a category by id', () async {
      final category = CategoryModel(name: 'Get Category');

      final id = await repository.create(category);
      final retrieved = await repository.getById(id);

      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Get Category'));
    });

    test('should return null for non-existent category', () async {
      final retrieved = await repository.getById(99999);
      expect(retrieved, isNull);
    });

    test('should retrieve all categories', () async {
      final categories = await repository.getAll();
      expect(categories, isA<List<CategoryModel>>());
    });

    test('should update a category', () async {
      final category = CategoryModel(name: 'Update Category');

      final id = await repository.create(category);
      final retrieved = await repository.getById(id);

      retrieved!.name = 'Updated Category';
      final success = await repository.update(retrieved);

      expect(success, isTrue);

      final updated = await repository.getById(id);
      expect(updated!.name, equals('Updated Category'));
    });

    test('should delete a category', () async {
      final category = CategoryModel(name: 'Delete Category');

      final id = await repository.create(category);
      final success = await repository.delete(id);

      expect(success, isTrue);

      final deleted = await repository.getById(id);
      expect(deleted, isNull);
    });

    test('should seed default categories', () async {
      await repository.seedDefaultCategories();

      final categories = await repository.getAll();
      expect(categories.length, greaterThanOrEqualTo(8));

      final categoryNames = categories.map((c) => c.name).toList();
      expect(categoryNames, contains('Alimentação'));
      expect(categoryNames, contains('Transporte'));
      expect(categoryNames, contains('Moradia'));
      expect(categoryNames, contains('Saúde'));
      expect(categoryNames, contains('Educação'));
      expect(categoryNames, contains('Lazer'));
      expect(categoryNames, contains('Vestuário'));
      expect(categoryNames, contains('Outros'));
    });

    test('should not duplicate categories when seeding twice', () async {
      await repository.seedDefaultCategories();
      final countAfterFirst = (await repository.getAll()).length;

      await repository.seedDefaultCategories();
      final countAfterSecond = (await repository.getAll()).length;

      expect(countAfterFirst, equals(countAfterSecond));
    });

    test('should watch all categories stream', () async {
      final stream = repository.watchAll();
      expect(stream, isA<Stream<List<CategoryModel>>>());

      final firstValue = await stream.first;
      expect(firstValue, isA<List<CategoryModel>>());
    });
  });
}
