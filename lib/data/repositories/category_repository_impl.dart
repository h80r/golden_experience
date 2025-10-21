import 'package:isar/isar.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../datasources/local_database.dart';
import '../models/category_model.dart';

/// Implementation of ICategoryRepository using Isar database
class CategoryRepositoryImpl implements ICategoryRepository {
  final Isar _isar = LocalDatabase.instance;

  /// Default categories to seed on first launch
  static const List<String> _defaultCategories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Saúde',
    'Educação',
    'Lazer',
    'Vestuário',
    'Outros',
  ];

  @override
  Future<int> create(CategoryModel category) async {
    return await _isar.writeTxn(() async {
      return await _isar.categoryModels.put(category);
    });
  }

  @override
  Future<CategoryModel?> getById(int id) async {
    return await _isar.categoryModels.get(id);
  }

  @override
  Future<List<CategoryModel>> getAll() async {
    return await _isar.categoryModels.where().findAll();
  }

  @override
  Future<bool> update(CategoryModel category) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.categoryModels.put(category);
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
        return await _isar.categoryModels.delete(id);
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> seedDefaultCategories() async {
    final existingCategories = await getAll();

    // Only seed if no categories exist
    if (existingCategories.isEmpty) {
      await _isar.writeTxn(() async {
        for (final categoryName in _defaultCategories) {
          final category = CategoryModel(name: categoryName);
          await _isar.categoryModels.put(category);
        }
      });
    }
  }

  @override
  Stream<List<CategoryModel>> watchAll() {
    return _isar.categoryModels.where().watch(fireImmediately: true);
  }
}
