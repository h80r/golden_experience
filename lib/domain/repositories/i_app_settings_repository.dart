import '../../../data/models/app_settings_model.dart';

/// Interface for AppSettings repository operations
/// Manages application-wide settings (singleton pattern with id=1)
abstract class IAppSettingsRepository {
  /// Retrieves the app settings
  /// Returns null if not initialized
  Future<AppSettingsModel?> get();

  /// Creates or updates app settings
  /// Always uses id=1 to maintain singleton pattern
  Future<void> save(AppSettingsModel settings);

  /// Updates only the monthly salary
  Future<void> updateMonthlySalary(double salary);

  /// Updates only the reserve balance
  Future<void> updateReserveBalance(double balance);

  /// Updates only the max reserve usage percentage
  Future<void> updateMaxReserveUsagePercentage(double percentage);

  /// Updates only the last recurring check date
  Future<void> updateLastRecurringCheck(DateTime date);

  /// Initializes settings with default values if they don't exist
  /// Should be called on first app launch
  Future<void> initializeDefaults();

  /// Returns a stream of app settings
  /// Updates automatically when data changes
  Stream<AppSettingsModel?> watch();
}
