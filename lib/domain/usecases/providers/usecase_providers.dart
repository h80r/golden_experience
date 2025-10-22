import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/repository_providers.dart';
import '../add_transaction_usecase.dart';
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
