import 'package:drift/drift.dart';
import '../../data/datasources/local_database.dart';

/// Interface for AppSettings repository operations
/// Manages application-wide settings (singleton pattern with id=1)
abstract class IAppSettingsRepository {
  /// Retrieves the app settings
  /// Returns null if not initialized
  Future<AppSettingsModel?> get();

  /// Creates or updates app settings
  /// Always uses id=1 to maintain singleton pattern
  Future<void> save(Insertable<AppSettingsModel> settings);

  /// Updates only the monthly salary
  Future<void> updateMonthlySalary(double salary);

  /// Updates only the max reserve usage percentage
  Future<void> updateMaxReserveUsagePercentage(double percentage);

  /// Updates only the last recurring check date
  Future<void> updateLastRecurringCheck(DateTime date);

  /// Updates only the onboarding completion flag
  Future<void> updateHasCompletedOnboarding(bool completed);

  /// Updates only the auto capture enabled flag
  Future<void> updateIsAutoCaptureEnabled(bool enabled);

  /// Updates salary payment configuration (mode and value)
  /// mode: 'calendar' or 'workday'
  /// value: 1-31 for calendar mode, 1-23 or -1 (last workday) for workday mode
  Future<void> updateSalaryPaymentConfig(String mode, int value);

  /// Initializes settings with default values if they don't exist
  /// Should be called on first app launch
  Future<void> initializeDefaults();

  /// Returns a stream of app settings
  /// Updates automatically when data changes
  Stream<AppSettingsModel?> watch();
}
