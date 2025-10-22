import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_settings_form_state.dart';

part 'app_settings_form_notifier.g.dart';

/// Notifier that manages the app settings form state.
///
/// This notifier handles:
/// - Field updates with automatic validation
/// - Form state validation
/// - Error message management
/// - Form reset functionality
@riverpod
class AppSettingsFormNotifier extends _$AppSettingsFormNotifier {
  @override
  AppSettingsFormState build() => AppSettingsFormState.initial();

  /// Updates the monthly salary field and validates the form.
  void updateMonthlySalary(double salary) {
    state = state.copyWith(monthlySalary: salary);
    _validate();
  }

  /// Updates the reserve balance field and validates the form.
  void updateReserveBalance(double balance) {
    state = state.copyWith(reserveBalance: balance);
    _validate();
  }

  /// Updates the max reserve usage percentage field and validates the form.
  /// Value should be between 0 and 100.
  void updateMaxReserveUsagePercentage(double percentage) {
    state = state.copyWith(maxReserveUsagePercentage: percentage);
    _validate();
  }

  /// Resets the form to its initial state.
  void reset() {
    state = AppSettingsFormState.initial();
  }

  /// Sets the form state from existing settings values.
  void setFromExisting({
    required double monthlySalary,
    required double reserveBalance,
    required double maxReserveUsagePercentage,
  }) {
    state = AppSettingsFormState(
      monthlySalary: monthlySalary,
      reserveBalance: reserveBalance,
      maxReserveUsagePercentage: maxReserveUsagePercentage,
      isValid: true,
      errorMessage: null,
    );
  }

  /// Validates the current state and updates isValid and errorMessage fields.
  ///
  /// Validation rules (in priority order):
  /// 1. Monthly salary must be greater than or equal to zero
  /// 2. Reserve balance must be greater than or equal to zero
  /// 3. Max reserve usage percentage must be between 0 and 100
  void _validate() {
    String? errorMessage;
    bool isValid = true;

    if (state.monthlySalary < 0) {
      isValid = false;
      errorMessage = 'O salário não pode ser negativo';
    } else if (state.reserveBalance < 0) {
      isValid = false;
      errorMessage = 'O saldo de reserva não pode ser negativo';
    } else if (state.maxReserveUsagePercentage < 0 ||
        state.maxReserveUsagePercentage > 100) {
      isValid = false;
      errorMessage = 'O percentual deve estar entre 0 e 100';
    } else {
      // All fields must be properly filled (at least one value > 0 indicates attempt to set)
      isValid = true;
      errorMessage = null;
    }

    state = state.copyWith(
      isValid: isValid,
      errorMessage: errorMessage,
    );
  }
}
