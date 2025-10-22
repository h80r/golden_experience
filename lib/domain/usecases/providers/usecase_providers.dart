import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/repository_providers.dart';
import '../add_transaction_usecase.dart';
import '../get_dashboard_data_usecase.dart';

/// Provider for AddTransactionUseCase
///
/// This provider creates an instance of AddTransactionUseCase with the required
/// repository dependencies injected via Riverpod.
///
/// Usage:
/// ```dart
/// final addTransactionUseCase = ref.read(addTransactionUseCaseProvider);
/// final result = await addTransactionUseCase.execute(
///   value: 100.0,
///   description: 'Grocery shopping',
///   date: DateTime.now(),
///   accountId: 1,
///   categoryId: 1,
/// );
/// ```
final addTransactionUseCaseProvider = Provider<AddTransactionUseCase>((ref) {
  return AddTransactionUseCase(
    transactionRepository: ref.read(transactionRepositoryProvider),
    accountRepository: ref.read(accountRepositoryProvider),
  );
});

/// Provider for GetDashboardDataUseCase
///
/// This provider creates an instance of GetDashboardDataUseCase with the required
/// repository dependencies injected via Riverpod.
///
/// Usage:
/// ```dart
/// final useCase = ref.read(getDashboardDataUseCaseProvider);
/// final dashboardData = await useCase.execute();
/// ```
final getDashboardDataUseCaseProvider =
    Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(
    transactionRepository: ref.read(transactionRepositoryProvider),
    appSettingsRepository: ref.read(appSettingsRepositoryProvider),
  );
});
