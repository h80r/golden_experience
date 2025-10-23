import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/repositories/app_settings_repository_impl.dart';
import 'package:golden_experience/domain/repositories/i_app_settings_repository.dart';

void main() {
  late IAppSettingsRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });

    await LocalDatabase.initialize();
    repository = AppSettingsRepositoryImpl();
  });

  tearDownAll(() async {
    await LocalDatabase.closeDatabase();
  });

  group('AppSettingsRepositoryImpl', () {
    test('should initialize default settings', () async {
      await repository.initializeDefaults();

      final settings = await repository.get();
      expect(settings, isNotNull);
      expect(settings!.id, equals(1));
      expect(settings.monthlySalary, equals(0.0));
      expect(settings.reserveBalance, equals(0.0));
      expect(settings.maxReserveUsagePercentage, equals(50.0));
    });

    test('should save settings', () async {
      final newSettings = AppSettingsModelCompanion.insert(
        id: const Value(1),
        monthlySalary: 5000.0,
        reserveBalance: 2000.0,
        maxReserveUsagePercentage: 60.0,
        lastRecurringCheck: DateTime.now(),
      );

      await repository.save(newSettings);

      final retrieved = await repository.get();
      expect(retrieved, isNotNull);
      expect(retrieved!.monthlySalary, equals(5000.0));
      expect(retrieved.reserveBalance, equals(2000.0));
      expect(retrieved.maxReserveUsagePercentage, equals(60.0));
    });

    test('should update monthly salary', () async {
      await repository.updateMonthlySalary(6000.0);

      final settings = await repository.get();
      expect(settings!.monthlySalary, equals(6000.0));
    });

    test('should update reserve balance', () async {
      await repository.updateReserveBalance(3000.0);

      final settings = await repository.get();
      expect(settings!.reserveBalance, equals(3000.0));
    });

    test('should update max reserve usage percentage', () async {
      await repository.updateMaxReserveUsagePercentage(75.0);

      final settings = await repository.get();
      expect(settings!.maxReserveUsagePercentage, equals(75.0));
    });

    test('should update last recurring check', () async {
      final testDate = DateTime(2025, 10, 21);
      await repository.updateLastRecurringCheck(testDate);

      final settings = await repository.get();
      expect(settings!.lastRecurringCheck.year, equals(2025));
      expect(settings.lastRecurringCheck.month, equals(10));
      expect(settings.lastRecurringCheck.day, equals(21));
    });

    test('should not duplicate settings when initializing twice', () async {
      await repository.initializeDefaults();
      final firstSettings = await repository.get();

      await repository.initializeDefaults();
      final secondSettings = await repository.get();

      expect(firstSettings!.id, equals(secondSettings!.id));
    });

    test('should watch settings stream', () async {
      final stream = repository.watch();
      expect(stream, isA<Stream<AppSettingsModel?>>());

      final firstValue = await stream.first;
      expect(firstValue, isNotNull);
    });

    test('should always maintain id as 1', () async {
      final settings = AppSettingsModelCompanion.insert(
        id: const Value(999), // Try to set different id
        monthlySalary: 1000.0,
        reserveBalance: 500.0,
        maxReserveUsagePercentage: 50.0,
        lastRecurringCheck: DateTime.now(),
      );

      await repository.save(settings);

      final retrieved = await repository.get();
      expect(retrieved!.id, equals(1)); // Should always be 1
    });
  });
}
