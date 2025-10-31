import 'package:drift/drift.dart';

import '../../data/datasources/local_database.dart';
import '../repositories/i_account_repository.dart';
import '../repositories/i_app_settings_repository.dart';
import '../repositories/i_recurring_expense_repository.dart';
import '../repositories/i_transaction_repository.dart';

/// Result of processing recurring expenses
class ProcessRecurringExpensesResult {
  final bool success;
  final int processedCount;
  final String? errorMessage;
  final List<int> createdTransactionIds;

  const ProcessRecurringExpensesResult({
    required this.success,
    required this.processedCount,
    required this.createdTransactionIds,
    this.errorMessage,
  });

  factory ProcessRecurringExpensesResult.failure(String errorMessage) {
    return ProcessRecurringExpensesResult(
      success: false,
      processedCount: 0,
      createdTransactionIds: [],
      errorMessage: errorMessage,
    );
  }

  factory ProcessRecurringExpensesResult.success({
    required int processedCount,
    required List<int> createdTransactionIds,
  }) {
    return ProcessRecurringExpensesResult(
      success: true,
      processedCount: processedCount,
      createdTransactionIds: createdTransactionIds,
    );
  }
}

/// Use case for processing recurring expenses.
///
/// This use case orchestrates the following operations:
/// 1. Gets the lastRecurringCheck date from AppSettings
/// 2. Compares with the current date
/// 3. For each day between lastRecurringCheck and today:
///    - Finds all recurring expenses with chargeDay matching the day
///    - Creates automatic transactions for each recurring expense
/// 4. Updates lastRecurringCheck to today
///
/// Business Rules:
/// - Only processes days in the past (not future)
/// - Handles months with different day counts (Feb, 30-day months, 31-day months)
/// - For charges on day 31: Uses the last day of months with fewer days
/// - On first app initialization: Sets lastRecurringCheck to yesterday
/// - Processes multiple days if app wasn't opened for several days
class ProcessRecurringExpensesUseCase {
  final IRecurringExpenseRepository _recurringExpenseRepository;
  final IAppSettingsRepository _appSettingsRepository;
  final ITransactionRepository _transactionRepository;
  final IAccountRepository _accountRepository;

  const ProcessRecurringExpensesUseCase({
    required IRecurringExpenseRepository recurringExpenseRepository,
    required IAppSettingsRepository appSettingsRepository,
    required ITransactionRepository transactionRepository,
    required IAccountRepository accountRepository,
  })  : _recurringExpenseRepository = recurringExpenseRepository,
        _appSettingsRepository = appSettingsRepository,
        _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the use case to process recurring expenses.
  ///
  /// Returns [ProcessRecurringExpensesResult] with success status, count of processed
  /// transactions, and list of created transaction IDs or error message.
  Future<ProcessRecurringExpensesResult> execute() async {
    try {
      // Get current app settings
      final settings = await _appSettingsRepository.get();
      if (settings == null) {
        return ProcessRecurringExpensesResult.failure(
          'Configurações do app não encontradas',
        );
      }

      final today = DateTime.now();
      final todayAtMidnight = DateTime(today.year, today.month, today.day);

      // Determine the date to start processing from
      DateTime startDate;
      if (settings.lastRecurringCheck.isBefore(todayAtMidnight)) {
        // lastRecurringCheck is in the past, process from the day after
        startDate = settings.lastRecurringCheck
            .add(const Duration(days: 1))
            .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      } else if (settings.lastRecurringCheck
          .isAtSameMomentAs(todayAtMidnight)) {
        // Already processed today
        return ProcessRecurringExpensesResult.success(
          processedCount: 0,
          createdTransactionIds: [],
        );
      } else {
        // This shouldn't happen in normal circumstances, but handle gracefully
        return ProcessRecurringExpensesResult.success(
          processedCount: 0,
          createdTransactionIds: [],
        );
      }

      // Collect all days to process
      final daysToProcess = _generateDaysToProcess(startDate, todayAtMidnight);

      if (daysToProcess.isEmpty) {
        // Update lastRecurringCheck to today and return success with 0 processed
        await _appSettingsRepository.updateLastRecurringCheck(todayAtMidnight);
        return ProcessRecurringExpensesResult.success(
          processedCount: 0,
          createdTransactionIds: [],
        );
      }

      // Process each day and create transactions
      final createdTransactionIds = <int>[];
      int totalProcessedCount = 0;

      for (final date in daysToProcess) {
        final dayOfMonth = date.day;

        // Get all recurring expenses that should be charged on this day
        final recurringExpenses =
            await _recurringExpenseRepository.getByChargeDay(dayOfMonth);

        // Also check for "last day of month" charges (chargeDay == 31)
        if (dayOfMonth == _getLastDayOfMonth(date)) {
          final lastDayExpenses =
              await _recurringExpenseRepository.getByChargeDay(31);
          recurringExpenses.addAll(lastDayExpenses);
        }

        // Create transactions for each recurring expense
        for (final expense in recurringExpenses) {
          try {
            // Verify account exists
            final account = await _accountRepository.getById(expense.accountId);
            if (account == null) {
              // Skip this expense if account doesn't exist
              continue;
            }

            // Determine transaction type based on account type
            // For dual-type accounts, recurring expenses default to credit (billing cycle)
            // For debit-only accounts, use debit
            // For credit-only accounts, use credit
            String transactionType = 'credit';
            if (account.isDebit && !account.isCredit) {
              transactionType = 'debit';
            }

            // Create the automatic transaction
            final transactionId = await _transactionRepository.create(
              TransactionModelCompanion.insert(
                value: expense.value,
                description: '[Recorrente] ${expense.description}',
                date: date,
                accountId: expense.accountId,
                categoryId: expense.categoryId,
                notes: const Value('[Processada automaticamente]'),
              ).copyWith(transactionType: Value(transactionType)),
            );

            // Update account balance/limit based on transaction type
            await _updateAccountAfterTransaction(
              account: account,
              transactionValue: expense.value,
              transactionType: transactionType,
            );

            createdTransactionIds.add(transactionId);
            totalProcessedCount++;
          } catch (e) {
            // Log error but continue processing other expenses
            // In a real app, you might want to handle this differently
            continue;
          }
        }
      }

      // Update lastRecurringCheck to today
      await _appSettingsRepository.updateLastRecurringCheck(todayAtMidnight);

      return ProcessRecurringExpensesResult.success(
        processedCount: totalProcessedCount,
        createdTransactionIds: createdTransactionIds,
      );
    } catch (e) {
      return ProcessRecurringExpensesResult.failure(
        'Erro ao processar despesas recorrentes: ${e.toString()}',
      );
    }
  }

  /// Generates a list of dates to process between startDate and endDate (inclusive).
  ///
  /// Returns an empty list if there are no days to process.
  List<DateTime> _generateDaysToProcess(
    DateTime startDate,
    DateTime endDate,
  ) {
    final days = <DateTime>[];
    var current = startDate;

    while (!current.isAfter(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  /// Gets the last day of the given month.
  ///
  /// For example:
  /// - February 2024: 29 (leap year)
  /// - February 2023: 28
  /// - April 2024: 30
  /// - December 2024: 31
  int _getLastDayOfMonth(DateTime date) {
    final nextMonth = date.month == 12
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  /// Updates the account balance (debit) and/or creditUsed (credit) after a transaction.
  ///
  /// For debit transactions: Decreases the account balance
  /// For credit transactions: Increases the creditUsed (amount owed)
  ///
  /// Note: The transaction type determines behavior, not the account type.
  /// This allows dual-type accounts to have both debit and credit transactions.
  ///
  /// This is a direct copy of the logic in AddTransactionUseCase to maintain consistency.
  Future<void> _updateAccountAfterTransaction({
    required AccountModel account,
    required double transactionValue,
    required String transactionType,
  }) async {
    try {
      // Handle debit transaction
      if (transactionType == 'debit') {
        if (!account.isDebit) return;
        final newBalance = account.balance - transactionValue;
        await _accountRepository.updateBalance(account.id, newBalance);
      }

      // Handle credit transaction
      if (transactionType == 'credit') {
        if (!account.isCredit) return;
        final newCreditUsed = account.creditUsed + transactionValue;
        await _accountRepository.updateCreditUsed(account.id, newCreditUsed);
      }
    } catch (e) {
      // Log error but continue processing other expenses
      // In a real app, you might want to handle this differently
    }
  }
}
