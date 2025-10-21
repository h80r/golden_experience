import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/account_model.dart';
import '../models/app_settings_model.dart';
import '../models/category_model.dart';
import '../models/recurring_expense_model.dart';
import '../models/transaction_model.dart';

class LocalDatabase {
  static Isar? _isar;

  /// Get the Isar instance. If not initialized, it will throw an error.
  static Isar get instance {
    if (_isar == null) {
      throw Exception(
        'Isar instance not initialized. Call LocalDatabase.initialize() first.',
      );
    }
    return _isar!;
  }

  /// Initialize the Isar database with all collections
  static Future<void> initialize() async {
    if (_isar != null) {
      return; // Already initialized
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        TransactionModelSchema,
        AccountModelSchema,
        RecurringExpenseModelSchema,
        CategoryModelSchema,
        AppSettingsModelSchema,
      ],
      directory: dir.path,
    );
  }

  /// Close the Isar database
  static Future<void> close() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }

  /// Check if database is initialized
  static bool get isInitialized => _isar != null;
}
