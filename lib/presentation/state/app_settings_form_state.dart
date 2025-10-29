/// Represents the state of the app settings form during configuration
class AppSettingsFormState {
  final double monthlySalary;
  final double maxReserveUsagePercentage;
  final bool isValid;
  final String? errorMessage;

  const AppSettingsFormState({
    required this.monthlySalary,
    required this.maxReserveUsagePercentage,
    required this.isValid,
    this.errorMessage,
  });

  /// Creates an initial state for the app settings form with default values.
  factory AppSettingsFormState.initial() => const AppSettingsFormState(
        monthlySalary: 0.0,
        maxReserveUsagePercentage: 0.0,
        isValid: false,
        errorMessage: null,
      );

  /// Creates a copy of this state with the given fields replaced
  AppSettingsFormState copyWith({
    double? monthlySalary,
    double? maxReserveUsagePercentage,
    bool? isValid,
    String? errorMessage,
  }) {
    return AppSettingsFormState(
      monthlySalary: monthlySalary ?? this.monthlySalary,
      maxReserveUsagePercentage: maxReserveUsagePercentage ?? this.maxReserveUsagePercentage,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsFormState &&
        other.monthlySalary == monthlySalary &&
        other.maxReserveUsagePercentage == maxReserveUsagePercentage &&
        other.isValid == isValid &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      monthlySalary,
      maxReserveUsagePercentage,
      isValid,
      errorMessage,
    );
  }

  @override
  String toString() {
    return 'AppSettingsFormState(monthlySalary: $monthlySalary, maxReserveUsagePercentage: $maxReserveUsagePercentage, isValid: $isValid, errorMessage: $errorMessage)';
  }
}
