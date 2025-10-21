/// Represents the state of the expense form during the registration flow.
class ExpenseFormState {
  final double value;
  final String description;
  final String? notes;
  final int? accountId;
  final String transactionType; // 'debit' | 'credit'
  final int? categoryId;
  final DateTime date;
  final bool isValid;
  final String? errorMessage;

  const ExpenseFormState({
    required this.value,
    required this.description,
    this.notes,
    this.accountId,
    required this.transactionType,
    this.categoryId,
    required this.date,
    required this.isValid,
    this.errorMessage,
  });

  /// Creates an initial state for the expense form with default values.
  factory ExpenseFormState.initial() => ExpenseFormState(
        value: 0.0,
        description: '',
        notes: null,
        accountId: null,
        transactionType: 'debit',
        categoryId: null,
        date: DateTime.now(),
        isValid: false,
        errorMessage: null,
      );

  /// Creates a copy of this state with the given fields replaced
  ExpenseFormState copyWith({
    double? value,
    String? description,
    String? notes,
    int? accountId,
    String? transactionType,
    int? categoryId,
    DateTime? date,
    bool? isValid,
    String? errorMessage,
  }) {
    return ExpenseFormState(
      value: value ?? this.value,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      accountId: accountId ?? this.accountId,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseFormState &&
        other.value == value &&
        other.description == description &&
        other.notes == notes &&
        other.accountId == accountId &&
        other.transactionType == transactionType &&
        other.categoryId == categoryId &&
        other.date == date &&
        other.isValid == isValid &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      value,
      description,
      notes,
      accountId,
      transactionType,
      categoryId,
      date,
      isValid,
      errorMessage,
    );
  }

  @override
  String toString() {
    return 'ExpenseFormState(value: $value, description: $description, notes: $notes, accountId: $accountId, transactionType: $transactionType, categoryId: $categoryId, date: $date, isValid: $isValid, errorMessage: $errorMessage)';
  }
}
