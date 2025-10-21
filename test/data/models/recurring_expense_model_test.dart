import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/models/recurring_expense_model.dart';

void main() {
  group('RecurringExpenseModel', () {
    test('should create a valid RecurringExpenseModel instance', () {
      // Act
      final recurringExpense = RecurringExpenseModel(
        value: 150.0,
        description: 'Internet Bill',
        chargeDay: 15,
        accountId: 1,
        categoryId: 1,
      );

      // Assert
      expect(recurringExpense.value, 150.0);
      expect(recurringExpense.description, 'Internet Bill');
      expect(recurringExpense.chargeDay, 15);
      expect(recurringExpense.accountId, 1);
      expect(recurringExpense.categoryId, 1);
    });

    test('should handle charge day at the beginning of month', () {
      // Act
      final recurringExpense = RecurringExpenseModel(
        value: 500.0,
        description: 'Rent',
        chargeDay: 1,
        accountId: 1,
        categoryId: 2,
      );

      // Assert
      expect(recurringExpense.chargeDay, 1);
    });

    test('should handle charge day at the end of month', () {
      // Act
      final recurringExpense = RecurringExpenseModel(
        value: 100.0,
        description: 'Subscription',
        chargeDay: 31,
        accountId: 1,
        categoryId: 3,
      );

      // Assert
      expect(recurringExpense.chargeDay, 31);
    });
  });
}
