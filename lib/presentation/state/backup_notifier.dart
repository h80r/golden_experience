import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_notifier.g.dart';

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

/// Notifier for managing backup state
@riverpod
class Backup extends _$Backup {
  @override
  BackupState build() {
    return BackupState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message, successMessage: null);
  }

  void setSuccess(String message) {
    state = state.copyWith(successMessage: message, errorMessage: null);
  }

  void clear() {
    state = BackupState();
  }
}
