import 'package:drift/drift.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../datasources/local_database.dart';

/// Implementation of ICategoryRepository using Drift database
class CategoryRepositoryImpl implements ICategoryRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  @override
  Future<int> create(Insertable<CategoryModel> category) async {
    return await _db.into(_db.categories).insert(category);
  }

  @override
  Future<CategoryModel?> getById(int id) async {
    return await (_db.select(_db.categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<CategoryModel>> getAll() async {
    return await _db.select(_db.categories).get();
  }

  @override
  Future<bool> update(Insertable<CategoryModel> category) async {
    try {
      final result = await _db.update(_db.categories).replace(category);
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final result =
          await (_db.delete(_db.categories)..where((c) => c.id.equals(id)))
              .go();
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteIfUnused(int id) async {
    try {
      // Check if category has any linked transactions
      final transactionsWithCategory = await (_db.select(_db.transactions)
            ..where((t) => t.categoryId.equals(id)))
          .get();

      if (transactionsWithCategory.isNotEmpty) {
        return false; // Category is in use, cannot delete
      }

      // Safe to delete
      final result =
          await (_db.delete(_db.categories)..where((c) => c.id.equals(id)))
              .go();
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setDefaultCategory(int id) async {
    try {
      // First, verify the category exists
      final category = await getById(id);
      if (category == null) return false;

      // Unset all current default categories
      await (_db.update(_db.categories)
            ..where((c) => c.isDefault.equals(true)))
          .write(const CategoryModelCompanion(isDefault: Value(false)));

      // Set the new default category
      await (_db.update(_db.categories)..where((c) => c.id.equals(id)))
          .write(const CategoryModelCompanion(isDefault: Value(true)));

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<CategoryModel?> getDefaultCategory() async {
    return await (_db.select(_db.categories)
          ..where((c) => c.isDefault.equals(true)))
        .getSingleOrNull();
  }

  @override
  Future<void> seedDefaultCategories() async {
    final existingCategories = await getAll();
    if (existingCategories.isNotEmpty) return;

    final defaultCategories = [
      CategoryModelCompanion.insert(name: 'Alimentação'),
      CategoryModelCompanion.insert(name: 'Transporte'),
      CategoryModelCompanion.insert(name: 'Moradia'),
      CategoryModelCompanion.insert(name: 'Saúde'),
      CategoryModelCompanion.insert(name: 'Lazer'),
      CategoryModelCompanion.insert(name: 'Educação'),
      CategoryModelCompanion.insert(name: 'Outros'),
    ];

    for (final category in defaultCategories) {
      await _db.into(_db.categories).insert(category);
    }
  }

  @override
  Stream<List<CategoryModel>> watchAll() {
    return _db.select(_db.categories).watch();
  }
}
