import 'package:drift/drift.dart';
import '../../domain/repositories/i_app_settings_repository.dart';
import '../datasources/local_database.dart';

/// Implementation of IAppSettingsRepository using Drift database
class AppSettingsRepositoryImpl implements IAppSettingsRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  static const int _settingsId = 1;

  @override
  Future<AppSettingsModel?> get() async {
    return await (_db.select(_db.appSettings)
          ..where((s) => s.id.equals(_settingsId)))
        .getSingleOrNull();
  }

  @override
  Future<void> save(Insertable<AppSettingsModel> settings) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(settings);
  }

  @override
  Future<void> updateMonthlySalary(double salary) async {
    await (_db.update(_db.appSettings)..where((s) => s.id.equals(_settingsId)))
        .write(AppSettingsModelCompanion(monthlySalary: Value(salary)));
  }

  @override
  Future<void> updateMaxReserveUsagePercentage(double percentage) async {
    await (_db.update(_db.appSettings)..where((s) => s.id.equals(_settingsId)))
        .write(AppSettingsModelCompanion(
            maxReserveUsagePercentage: Value(percentage)));
  }

  @override
  Future<void> updateLastRecurringCheck(DateTime date) async {
    await (_db.update(_db.appSettings)..where((s) => s.id.equals(_settingsId)))
        .write(AppSettingsModelCompanion(lastRecurringCheck: Value(date)));
  }

  @override
  Future<void> updateHasCompletedOnboarding(bool completed) async {
    await (_db.update(_db.appSettings)..where((s) => s.id.equals(_settingsId)))
        .write(AppSettingsModelCompanion(
            hasCompletedOnboarding: Value(completed)));
  }

  @override
  Future<void> updateIsAutoCaptureEnabled(bool enabled) async {
    await (_db.update(_db.appSettings)..where((s) => s.id.equals(_settingsId)))
        .write(AppSettingsModelCompanion(isAutoCaptureEnabled: Value(enabled)));
  }

  @override
  Future<void> updateSalaryPaymentConfig(String mode, int value) async {
    await (_db.update(_db.appSettings)..where((s) => s.id.equals(_settingsId)))
        .write(AppSettingsModelCompanion(
      salaryPaymentMode: Value(mode),
      salaryPaymentValue: Value(value),
    ));
  }

  @override
  Future<void> initializeDefaults() async {
    final existing = await get();
    if (existing != null) return;

    final defaultSettings = AppSettingsModelCompanion.insert(
      id: Value(_settingsId),
      monthlySalary: 0.0,
      maxReserveUsagePercentage: 0.0,
      lastRecurringCheck: DateTime.now(),
      hasCompletedOnboarding: Value(false),
      isAutoCaptureEnabled: Value(false),
      salaryPaymentMode: Value('calendar'),
      salaryPaymentValue: Value(1),
    );

    await _db.into(_db.appSettings).insert(defaultSettings);
  }

  @override
  Stream<AppSettingsModel?> watch() {
    return (_db.select(_db.appSettings)..where((s) => s.id.equals(_settingsId)))
        .watchSingleOrNull();
  }
}
