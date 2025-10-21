import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';

void main() {
  group('LocalDatabase', () {
    test('should throw error when accessing instance before initialization', () {
      // Arrange - Ensure database is not initialized
      expect(LocalDatabase.isInitialized, false);

      // Act & Assert
      expect(
        () => LocalDatabase.instance,
        throwsA(isA<Exception>()),
      );
    });

    test('should check isInitialized flag', () {
      // Initially should not be initialized
      expect(LocalDatabase.isInitialized, false);
    });
  });
}
