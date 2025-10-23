import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_notifier.g.dart';

/// Notifier for managing backup state
@riverpod
class Backup extends _$Backup {
  @override
  BackupState build() {
    return BackupState();
  }

  void clear() {
    state = BackupState();
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message, successMessage: null);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setSuccess(String message) {
    state = state.copyWith(successMessage: message, errorMessage: null);
  }
}

/// State for backup/restore operations
class BackupState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  BackupState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  BackupState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return BackupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
