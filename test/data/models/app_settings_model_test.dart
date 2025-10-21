import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/models/app_settings_model.dart';

void main() {
  group('AppSettingsModel', () {
    test('should create a valid AppSettingsModel instance', () {
      // Arrange
      final lastCheck = DateTime(2025, 10, 21);

      // Act
      final settings = AppSettingsModel(
        monthlySalary: 5000.0,
        reserveBalance: 1000.0,
        maxReserveUsagePercentage: 50.0,
        lastRecurringCheck: lastCheck,
      );

      // Assert
      expect(settings.id, 1); // Should always be 1
      expect(settings.monthlySalary, 5000.0);
      expect(settings.reserveBalance, 1000.0);
      expect(settings.maxReserveUsagePercentage, 50.0);
      expect(settings.lastRecurringCheck, lastCheck);
    });

    test('should always have id equal to 1', () {
      // Act
      final settings1 = AppSettingsModel(
        monthlySalary: 3000.0,
        reserveBalance: 500.0,
        maxReserveUsagePercentage: 30.0,
        lastRecurringCheck: DateTime.now(),
      );

      final settings2 = AppSettingsModel(
        monthlySalary: 4000.0,
        reserveBalance: 800.0,
        maxReserveUsagePercentage: 40.0,
        lastRecurringCheck: DateTime.now(),
      );

      // Assert - Both should have id = 1 (singleton pattern)
      expect(settings1.id, 1);
      expect(settings2.id, 1);
    });
  });
}
