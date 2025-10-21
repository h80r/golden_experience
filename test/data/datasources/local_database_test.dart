import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalDatabase', () {
    tearDown(() async {
      // Ensure database is closed after each test
      if (LocalDatabase.isInitialized) {
        await LocalDatabase.close();
      }
    });

    test('should initialize and close Isar instance', () async {
      // Arrange - Check initial state
      expect(LocalDatabase.isInitialized, false);

      // Act - Initialize
      await LocalDatabase.initialize();

      // Assert - Should be initialized
      expect(LocalDatabase.isInitialized, true);
      expect(() => LocalDatabase.instance, returnsNormally);

      // Act - Close
      await LocalDatabase.close();

      // Assert - Should no longer be initialized
      expect(LocalDatabase.isInitialized, false);
    });

    test('should throw error when accessing instance before initialization', () {
      // Arrange - Ensure database is not initialized
      expect(LocalDatabase.isInitialized, false);

      // Act & Assert
      expect(
        () => LocalDatabase.instance,
        throwsA(isA<Exception>()),
      );
    });

    test('should not reinitialize if already initialized', () async {
      // Arrange
      await LocalDatabase.initialize();
      final firstInstance = LocalDatabase.instance;

      // Act - Try to initialize again
      await LocalDatabase.initialize();
      final secondInstance = LocalDatabase.instance;

      // Assert - Should be the same instance
      expect(identical(firstInstance, secondInstance), true);

      // Cleanup
      await LocalDatabase.close();
    });
  });
}
