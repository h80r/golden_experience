import 'package:drift/drift.dart';
import '../../data/datasources/local_database.dart';

/// Interface for Category repository operations
/// Defines CRUD operations and category management
abstract class ICategoryRepository {
  /// Creates a new category
  /// Returns the ID of the created category
  Future<int> create(Insertable<CategoryModel> category);

  /// Retrieves a category by its ID
  /// Returns null if not found
  Future<CategoryModel?> getById(int id);

  /// Retrieves all categories
  Future<List<CategoryModel>> getAll();

  /// Updates an existing category
  /// Returns true if successful, false otherwise
  Future<bool> update(Insertable<CategoryModel> category);

  /// Deletes a category by its ID
  /// Returns true if successful, false otherwise
  Future<bool> delete(int id);

  /// Seeds default categories
  /// Should be called on first app launch
  Future<void> seedDefaultCategories();

  /// Returns a stream of all categories
  /// Updates automatically when data changes
  Stream<List<CategoryModel>> watchAll();
}
