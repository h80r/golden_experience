import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'expense_form_state.dart';

part 'expense_form_notifier.g.dart';

/// Notifier that manages the expense form state during registration.
///
/// This notifier handles:
/// - Field updates with automatic validation
/// - Form state validation
/// - Error message management
/// - Form reset functionality
@riverpod
class ExpenseFormNotifier extends _$ExpenseFormNotifier {
  @override
  ExpenseFormState build() => ExpenseFormState.initial();

  /// Updates the value field and validates the form.
  void updateValue(double value) {
    state = state.copyWith(value: value);
    _validate();
  }

  /// Updates the description field and validates the form.
  void updateDescription(String description) {
    state = state.copyWith(description: description);
    _validate();
  }

  /// Updates the optional notes field.
  void updateNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  /// Updates the account ID and validates the form.
  void updateAccountId(int? accountId) {
    state = state.copyWith(accountId: accountId);
    _validate();
  }

  /// Updates the transaction type (debit or credit) and validates the form.
  /// Throws ArgumentError if the type is neither 'debit' nor 'credit'.
  void updateTransactionType(String transactionType) {
    if (transactionType != 'debit' && transactionType != 'credit') {
      throw ArgumentError(
        'Transaction type must be either "debit" or "credit"',
      );
    }
    state = state.copyWith(transactionType: transactionType);
    _validate();
  }

  /// Updates the category ID and validates the form.
  void updateCategoryId(int? categoryId) {
    state = state.copyWith(categoryId: categoryId);
    _validate();
  }

  /// Updates the transaction date.
  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  /// Resets the form to its initial state.
  void reset() {
    state = ExpenseFormState.initial();
  }

  /// Validates the current state and updates isValid and errorMessage fields.
  ///
  /// Validation rules (in priority order):
  /// 1. Value must be greater than zero
  /// 2. Description cannot be empty or whitespace
  /// 3. Account ID must be selected
  /// 4. Category ID must be selected
  void _validate() {
    String? errorMessage;
    bool isValid = true;

    if (state.value <= 0) {
      isValid = false;
      errorMessage = 'O valor deve ser maior que zero';
    } else if (state.description.trim().isEmpty) {
      isValid = false;
      errorMessage = 'A descrição é obrigatória';
    } else if (state.accountId == null) {
      isValid = false;
      errorMessage = 'Selecione uma conta';
    } else if (state.categoryId == null) {
      isValid = false;
      errorMessage = 'Selecione uma categoria';
    }

    state = state.copyWith(
      isValid: isValid,
      errorMessage: errorMessage,
    );
  }
}
