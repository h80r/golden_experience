import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../database/transactions_table.dart';
import '../database/accounts_table.dart';
import '../database/categories_table.dart';
import '../database/recurring_expenses_table.dart';
import '../database/app_settings_table.dart';

part 'local_database.g.dart';

/// Local database using Drift for data persistence
@DriftDatabase(tables: [
  Transactions,
  Accounts,
  Categories,
  RecurringExpenses,
  AppSettings,
])
class LocalDatabase extends _$LocalDatabase {
  static LocalDatabase? _instance;

  /// Private constructor for singleton pattern
  LocalDatabase._() : super(_openConnection());

  /// Get the singleton instance
  static LocalDatabase get instance {
    if (_instance == null) {
      throw Exception(
        'LocalDatabase not initialized. Call LocalDatabase.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initialize the database singleton
  static Future<void> initialize() async {
    if (_instance != null) {
      return; // Already initialized
    }
    _instance = LocalDatabase._();
  }

  /// Close the database
  static Future<void> closeDatabase() async {
    if (_instance != null) {
      await _instance!.close();
      _instance = null;
    }
  }

  /// Check if database is initialized
  static bool get isInitialized => _instance != null;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Add migration logic here when schema changes
        },
      );
}

/// Opens a connection to the database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'golden_experience.db'));
    return NativeDatabase(file);
  });
}
