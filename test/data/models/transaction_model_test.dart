import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    test('should create a valid TransactionModel instance', () {
      // Arrange
      final date = DateTime(2025, 10, 21);

      // Act
      final transaction = TransactionModel(
        value: 50.0,
        description: 'Lunch',
        date: date,
        notes: 'At restaurant',
        accountId: 1,
        categoryId: 1,
      );

      // Assert
      expect(transaction.value, 50.0);
      expect(transaction.description, 'Lunch');
      expect(transaction.date, date);
      expect(transaction.notes, 'At restaurant');
      expect(transaction.accountId, 1);
      expect(transaction.categoryId, 1);
    });

    test('should create TransactionModel with null notes', () {
      // Act
      final transaction = TransactionModel(
        value: 100.0,
        description: 'Salary',
        date: DateTime.now(),
        accountId: 1,
        categoryId: 2,
      );

      // Assert
      expect(transaction.notes, null);
    });
  });
}
