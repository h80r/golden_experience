import 'package:isar/isar.dart';

part 'app_settings_model.g.dart';

@collection
class AppSettingsModel {
  // Fixed ID = 1 to ensure only one settings instance exists
  Id id = 1;

  late double monthlySalary;

  late double reserveBalance;

  late double maxReserveUsagePercentage;

  late DateTime lastRecurringCheck;

  AppSettingsModel({
    this.id = 1,
    required this.monthlySalary,
    required this.reserveBalance,
    required this.maxReserveUsagePercentage,
    required this.lastRecurringCheck,
  });
}
