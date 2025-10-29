import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dashboard_data.dart';
import '../../../data/providers/repository_providers.dart';
import '../../../data/datasources/local_database.dart';
import '../add_transaction_usecase.dart';
import '../update_transaction_usecase.dart';
import '../delete_transaction_usecase.dart';
import '../get_dashboard_data_usecase.dart';
import '../process_recurring_expenses_usecase.dart';

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
    accountRepository: ref.read(accountRepositoryProvider),
  );
});

/// Provider for ProcessRecurringExpensesUseCase
///
/// This provider creates an instance of ProcessRecurringExpensesUseCase with the
/// required repository dependencies injected via Riverpod.
///
/// This use case handles the automatic creation of transactions for recurring expenses.
/// It should be called during app initialization to process any recurring expenses
/// that are due since the last time the app was opened.
///
/// Usage:
/// ```dart
/// final useCase = ref.read(processRecurringExpensesUseCaseProvider);
/// final result = await useCase.execute();
/// if (result.success) {
///   print('Processed ${result.processedCount} transactions');
/// }
/// ```
final processRecurringExpensesUseCaseProvider =
    Provider<ProcessRecurringExpensesUseCase>((ref) {
  return ProcessRecurringExpensesUseCase(
    recurringExpenseRepository: ref.read(recurringExpenseRepositoryProvider),
    appSettingsRepository: ref.read(appSettingsRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
    accountRepository: ref.read(accountRepositoryProvider),
  );
});

/// Provider for reactive app settings
///
/// This StreamProvider watches for changes in app settings,
/// automatically emitting new AppSettingsModel whenever settings change.
/// Note: NOT using autoDispose because we need this provider to stay alive
/// for the app to properly switch between onboarding and main screens.
///
/// Usage:
/// ```dart
/// final appSettingsAsync = ref.watch(appSettingsStreamProvider);
/// appSettingsAsync.when(
///   data: (settings) => Text('Salary: ${settings?.monthlySalary}'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final appSettingsStreamProvider =
    StreamProvider<AppSettingsModel?>((ref) {
  final repository = ref.read(appSettingsRepositoryProvider);
  return repository.watch();
});

/// Provider for reactive dashboard data
///
/// This StreamProvider watches for changes in transactions and app settings,
/// automatically recalculating and emitting new DashboardData whenever
/// the underlying data changes.
///
/// Usage:
/// ```dart
/// final dashboardDataAsync = ref.watch(dashboardDataStreamProvider);
/// dashboardDataAsync.when(
///   data: (dashboardData) => Text('Remaining: ${dashboardData.remainingBudget}'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final dashboardDataStreamProvider =
    StreamProvider.autoDispose<DashboardData>((ref) {
  final useCase = ref.watch(getDashboardDataUseCaseProvider);
  return useCase.executeReactive();
});

/// Provider for UpdateTransactionUseCase
///
/// This provider creates an instance of UpdateTransactionUseCase with the required
/// repository dependencies injected via Riverpod.
///
/// Usage:
/// ```dart
/// final updateTransactionUseCase = ref.read(updateTransactionUseCaseProvider);
/// final result = await updateTransactionUseCase.execute(
///   id: 1,
///   value: 150.0,
///   description: 'Updated description',
///   date: DateTime.now(),
///   accountId: 1,
///   categoryId: 1,
/// );
/// ```
final updateTransactionUseCaseProvider =
    Provider<UpdateTransactionUseCase>((ref) {
  return UpdateTransactionUseCase(
    transactionRepository: ref.read(transactionRepositoryProvider),
    accountRepository: ref.read(accountRepositoryProvider),
  );
});

/// Provider for DeleteTransactionUseCase
///
/// This provider creates an instance of DeleteTransactionUseCase with the required
/// repository dependencies injected via Riverpod.
///
/// Usage:
/// ```dart
/// final deleteTransactionUseCase = ref.read(deleteTransactionUseCaseProvider);
/// final result = await deleteTransactionUseCase.execute(id: 1);
/// ```
final deleteTransactionUseCaseProvider =
    Provider<DeleteTransactionUseCase>((ref) {
  return DeleteTransactionUseCase(
    transactionRepository: ref.read(transactionRepositoryProvider),
    accountRepository: ref.read(accountRepositoryProvider),
  );
});
