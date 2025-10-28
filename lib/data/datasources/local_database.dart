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
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migration from v1 to v2: Update accounts table schema
          if (from == 1) {
            // SQLite doesn't support DROP COLUMN, so we need to recreate the table
            // Step 1: Create new accounts table with new schema
            await customStatement('''
              CREATE TABLE accounts_new (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                is_debit INTEGER NOT NULL DEFAULT 1 CHECK ("is_debit" IN (0, 1)),
                is_credit INTEGER NOT NULL DEFAULT 0 CHECK ("is_credit" IN (0, 1)),
                balance REAL NOT NULL DEFAULT 0.0,
                credit_limit REAL NOT NULL DEFAULT 0.0,
                credit_used REAL NOT NULL DEFAULT 0.0
              )
            ''');

            // Step 2: Copy data from old table to new table, converting old schema to new
            await customStatement('''
              INSERT INTO accounts_new (id, name, is_debit, is_credit, balance, credit_limit, credit_used)
              SELECT
                id,
                name,
                CASE WHEN type = 0 THEN 1 ELSE 0 END as is_debit,
                CASE WHEN type = 1 THEN 1 ELSE 0 END as is_credit,
                CASE WHEN type = 0 THEN initial_balance ELSE 0.0 END as balance,
                credit_limit,
                0.0 as credit_used
              FROM accounts
            ''');

            // Step 3: Drop old table
            await customStatement('DROP TABLE accounts');

            // Step 4: Rename new table to original name
            await customStatement('ALTER TABLE accounts_new RENAME TO accounts');
          }

          // Migration from v2 to v3: Add isAutoCaptureEnabled column to app_settings
          if (from <= 2) {
            await customStatement('''
              ALTER TABLE app_settings
              ADD COLUMN is_auto_capture_enabled INTEGER NOT NULL DEFAULT 0
              CHECK ("is_auto_capture_enabled" IN (0, 1))
            ''');
          }

          // Migration from v3 to v4: Add isDefault column to accounts
          if (from <= 3) {
            await customStatement('''
              ALTER TABLE accounts
              ADD COLUMN is_default INTEGER NOT NULL DEFAULT 0
              CHECK ("is_default" IN (0, 1))
            ''');
          }

          // Migration from v4 to v5: Add isDefault column to categories
          if (from <= 4) {
            await customStatement('''
              ALTER TABLE categories
              ADD COLUMN is_default INTEGER NOT NULL DEFAULT 0
              CHECK ("is_default" IN (0, 1))
            ''');
          }
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
