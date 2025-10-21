import 'package:drift/drift.dart';

/// Drift table definition for categories
@DataClassName('CategoryModel')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}
