import 'package:isar/isar.dart';
import '../../domain/repositories/i_app_settings_repository.dart';
import '../datasources/local_database.dart';
import '../models/app_settings_model.dart';

/// Implementation of IAppSettingsRepository using Isar database
/// Maintains a singleton settings instance with id=1
class AppSettingsRepositoryImpl implements IAppSettingsRepository {
  final Isar _isar = LocalDatabase.instance;

  /// Default values for first-time initialization
  static const double _defaultMonthlySalary = 0.0;
  static const double _defaultReserveBalance = 0.0;
  static const double _defaultMaxReserveUsagePercentage = 50.0;

  @override
  Future<AppSettingsModel?> get() async {
    return await _isar.appSettingsModels.get(1);
  }

  @override
  Future<void> save(AppSettingsModel settings) async {
    await _isar.writeTxn(() async {
      // Ensure id is always 1
      settings.id = 1;
      await _isar.appSettingsModels.put(settings);
    });
  }

  @override
  Future<void> updateMonthlySalary(double salary) async {
    final settings = await get();
    if (settings != null) {
      settings.monthlySalary = salary;
      await save(settings);
    }
  }

  @override
  Future<void> updateReserveBalance(double balance) async {
    final settings = await get();
    if (settings != null) {
      settings.reserveBalance = balance;
      await save(settings);
    }
  }

  @override
  Future<void> updateMaxReserveUsagePercentage(double percentage) async {
    final settings = await get();
    if (settings != null) {
      settings.maxReserveUsagePercentage = percentage;
      await save(settings);
    }
  }

  @override
  Future<void> updateLastRecurringCheck(DateTime date) async {
    final settings = await get();
    if (settings != null) {
      settings.lastRecurringCheck = date;
      await save(settings);
    }
  }

  @override
  Future<void> initializeDefaults() async {
    final existing = await get();

    // Only initialize if settings don't exist
    if (existing == null) {
      final defaultSettings = AppSettingsModel(
        id: 1,
        monthlySalary: _defaultMonthlySalary,
        reserveBalance: _defaultReserveBalance,
        maxReserveUsagePercentage: _defaultMaxReserveUsagePercentage,
        lastRecurringCheck: DateTime.now(),
      );
      await save(defaultSettings);
    }
  }

  @override
  Stream<AppSettingsModel?> watch() {
    return _isar.appSettingsModels.watchObject(1, fireImmediately: true);
  }
}
