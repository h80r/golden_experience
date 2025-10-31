import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_experience/presentation/state/expense_form_notifier.dart';

void main() {
  group('ExpenseFormNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Initial State', () {
      test('should start with initial state', () {
        final state = container.read(expenseFormProvider);

        expect(state.value, 0.0);
        expect(state.description, '');
        expect(state.notes, null);
        expect(state.accountId, null);
        expect(state.transactionType, 'debit');
        expect(state.categoryId, null);
        expect(state.isValid, false);
        expect(state.errorMessage, null);
      });

      test('should have a non-null date', () {
        final state = container.read(expenseFormProvider);
        expect(state.date, isNotNull);
      });
    });

    group('updateValue', () {
      test('should update value correctly', () {
        container.read(expenseFormProvider.notifier).updateValue(100.50);
        final state = container.read(expenseFormProvider);
        expect(state.value, 100.50);
      });

      test('should trigger validation', () {
        // Update value to positive number
        container.read(expenseFormProvider.notifier).updateValue(100.0);
        final state = container.read(expenseFormProvider);

        expect(state.value, 100.0);
        // Still invalid due to missing other required fields
        expect(state.isValid, false);
      });

      test('should set error message when value is zero', () {
        container.read(expenseFormProvider.notifier).updateValue(0);
        final state = container.read(expenseFormProvider);

        expect(state.isValid, false);
        expect(state.errorMessage, contains('maior que zero'));
      });

      test('should set error message when value is negative', () {
        container.read(expenseFormProvider.notifier).updateValue(-10.0);
        final state = container.read(expenseFormProvider);

        expect(state.isValid, false);
        expect(state.errorMessage, contains('maior que zero'));
      });
    });

    group('updateDescription', () {
      test('should update description correctly', () {
        container
            .read(expenseFormProvider.notifier)
            .updateDescription('Lunch expense');
        final state = container.read(expenseFormProvider);
        expect(state.description, 'Lunch expense');
      });

      test('should trigger validation', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0); // Set valid value first
        notifier.updateDescription('');
        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('descrição'));
      });

      test('should set error when description is empty', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0); // Set valid value first
        notifier.updateDescription('');
        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('descrição'));
      });

      test('should set error when description is only whitespace', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0); // Set valid value first
        notifier.updateDescription('   ');
        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('descrição'));
      });
    });

    group('updateNotes', () {
      test('should update notes correctly', () {
        container
            .read(expenseFormProvider.notifier)
            .updateNotes('Some additional notes');
        final state = container.read(expenseFormProvider);
        expect(state.notes, 'Some additional notes');
      });

      test('should accept null notes', () {
        container.read(expenseFormProvider.notifier).updateNotes(null);
        final state = container.read(expenseFormProvider);
        expect(state.notes, null);
      });

      test('should not trigger validation that affects result', () {
        // Notes are optional, so updating them shouldn't affect validation
        final initialState = container.read(expenseFormProvider);
        final initialIsValid = initialState.isValid;

        container.read(expenseFormProvider.notifier).updateNotes('Some notes');
        final state = container.read(expenseFormProvider);
        // Validation state should remain the same
        expect(state.isValid, initialIsValid);
      });
    });

    group('updateAccountId', () {
      test('should update accountId correctly', () {
        container.read(expenseFormProvider.notifier).updateAccountId(1);
        final state = container.read(expenseFormProvider);
        expect(state.accountId, 1);
      });

      test('should trigger validation', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0); // Set valid value first
        notifier.updateDescription('Test'); // Set valid description
        notifier.updateAccountId(null);
        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('conta'));
      });

      test('should set error when accountId is null', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0); // Set valid value first
        notifier.updateDescription('Test'); // Set valid description
        notifier.updateAccountId(null);
        final state = container.read(expenseFormProvider);
        expect(state.errorMessage, contains('conta'));
      });
    });

    group('updateTransactionType', () {
      test('should update transaction type to debit', () {
        container
            .read(expenseFormProvider.notifier)
            .updateTransactionType('debit');
        final state = container.read(expenseFormProvider);
        expect(state.transactionType, 'debit');
      });

      test('should update transaction type to credit', () {
        container
            .read(expenseFormProvider.notifier)
            .updateTransactionType('credit');
        final state = container.read(expenseFormProvider);
        expect(state.transactionType, 'credit');
      });

      test('should throw error for invalid transaction type', () {
        expect(
          () => container
              .read(expenseFormProvider.notifier)
              .updateTransactionType('invalid'),
          throwsArgumentError,
        );
      });

      test('should trigger validation', () {
        container
            .read(expenseFormProvider.notifier)
            .updateTransactionType('credit');
        final state = container.read(expenseFormProvider);
        // Should still be invalid due to other missing fields
        expect(state.isValid, false);
      });
    });

    group('updateCategoryId', () {
      test('should update categoryId correctly', () {
        container.read(expenseFormProvider.notifier).updateCategoryId(2);
        final state = container.read(expenseFormProvider);
        expect(state.categoryId, 2);
      });

      test('should trigger validation', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0); // Set valid value first
        notifier.updateDescription('Test'); // Set valid description
        notifier.updateAccountId(1); // Set valid account
        notifier.updateCategoryId(null);
        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('categoria'));
      });

      test('should set error when categoryId is null', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0); // Set valid value first
        notifier.updateDescription('Test'); // Set valid description
        notifier.updateAccountId(1); // Set valid account
        notifier.updateCategoryId(null);
        final state = container.read(expenseFormProvider);
        expect(state.errorMessage, contains('categoria'));
      });
    });

    group('updateDate', () {
      test('should update date correctly', () {
        final newDate = DateTime(2025, 1, 15);
        container.read(expenseFormProvider.notifier).updateDate(newDate);
        final state = container.read(expenseFormProvider);
        expect(state.date, newDate);
      });

      test('should not trigger validation that affects result', () {
        // Date is always required but has a default value
        final initialState = container.read(expenseFormProvider);
        final initialIsValid = initialState.isValid;

        container
            .read(expenseFormProvider.notifier)
            .updateDate(DateTime(2025, 1, 15));
        final state = container.read(expenseFormProvider);
        expect(state.isValid, initialIsValid);
      });
    });

    group('reset', () {
      test('should reset form to initial state', () {
        // Fill out the form
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0);
        notifier.updateDescription('Lunch');
        notifier.updateNotes('With client');
        notifier.updateAccountId(1);
        notifier.updateCategoryId(2);

        // Reset
        notifier.reset();

        // Verify reset to initial state
        final state = container.read(expenseFormProvider);
        expect(state.value, 0.0);
        expect(state.description, '');
        expect(state.notes, null);
        expect(state.accountId, null);
        expect(state.transactionType, 'debit');
        expect(state.categoryId, null);
        expect(state.isValid, false);
      });
    });

    group('Validation Logic', () {
      test('should be valid when all required fields are filled correctly', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0);
        notifier.updateDescription('Lunch expense');
        notifier.updateAccountId(1);
        notifier.updateCategoryId(2);

        final state = container.read(expenseFormProvider);
        expect(state.isValid, true);
        expect(state.errorMessage, null);
      });

      test('should prioritize value validation error', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(0);
        notifier.updateDescription('');
        notifier.updateAccountId(null);
        notifier.updateCategoryId(null);

        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('valor'));
      });

      test('should show description error when value is valid', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0);
        notifier.updateDescription('');
        notifier.updateAccountId(null);
        notifier.updateCategoryId(null);

        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('descrição'));
      });

      test('should show account error when value and description are valid',
          () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0);
        notifier.updateDescription('Lunch');
        notifier.updateAccountId(null);
        notifier.updateCategoryId(null);

        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('conta'));
      });

      test('should show category error when other fields are valid', () {
        final notifier = container.read(expenseFormProvider.notifier);
        notifier.updateValue(100.0);
        notifier.updateDescription('Lunch');
        notifier.updateAccountId(1);
        notifier.updateCategoryId(null);

        final state = container.read(expenseFormProvider);
        expect(state.isValid, false);
        expect(state.errorMessage, contains('categoria'));
      });
    });

    group('Edge Cases', () {
      test('should handle very large values', () {
        container.read(expenseFormProvider.notifier).updateValue(999999999.99);
        final state = container.read(expenseFormProvider);
        expect(state.value, 999999999.99);
      });

      test('should handle very small positive values', () {
        container.read(expenseFormProvider.notifier).updateValue(0.01);
        final state = container.read(expenseFormProvider);
        expect(state.value, 0.01);
      });

      test('should handle long descriptions', () {
        final longDescription = 'A' * 1000;
        container
            .read(expenseFormProvider.notifier)
            .updateDescription(longDescription);
        final state = container.read(expenseFormProvider);
        expect(state.description, longDescription);
      });

      test('should handle special characters in description', () {
        container
            .read(expenseFormProvider.notifier)
            .updateDescription('Café & Restaurant! @123');
        final state = container.read(expenseFormProvider);
        expect(state.description, 'Café & Restaurant! @123');
      });

      test('should handle past dates', () {
        final pastDate = DateTime(2020, 1, 1);
        container.read(expenseFormProvider.notifier).updateDate(pastDate);
        final state = container.read(expenseFormProvider);
        expect(state.date, pastDate);
      });

      test('should handle future dates', () {
        final futureDate = DateTime(2030, 12, 31);
        container.read(expenseFormProvider.notifier).updateDate(futureDate);
        final state = container.read(expenseFormProvider);
        expect(state.date, futureDate);
      });
    });
  });
}
