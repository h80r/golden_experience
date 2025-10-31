import 'dart:async';
import '../../core/utils/billing_cycle_utils.dart';
import '../models/dashboard_data.dart';
import '../repositories/i_account_repository.dart';
import '../repositories/i_app_settings_repository.dart';
import '../repositories/i_transaction_repository.dart';

/// Use case for fetching and calculating all dashboard financial data
///
/// This use case is responsible for:
/// 1. Fetching the current month's transactions
/// 2. Fetching app settings (salary, limits)
/// 3. Calculating reserve from debit account balances
/// 4. Performing all financial calculations according to business logic
/// 5. Returning a complete DashboardData object for UI consumption
///
/// The calculations follow the PRD specifications:
/// - **Reserve Balance:** Sum of all debit account balances (calculated dynamically)
/// - **Total Spent:** Sum of all transactions for the current month
/// - **Salary - Spending:** Simple difference
/// - **Remaining Budget:** (Salary + (Reserve * % Max)) - Total Spent
/// - **Final Reserve:** Reserve - (Total Spent - Salary) when spent > salary
/// - **Reserve Usage %:** Percentage of max allowed reserve that was consumed
class GetDashboardDataUseCase {
  final ITransactionRepository _transactionRepository;
  final IAppSettingsRepository _appSettingsRepository;
  final IAccountRepository _accountRepository;

  const GetDashboardDataUseCase({
    required ITransactionRepository transactionRepository,
    required IAppSettingsRepository appSettingsRepository,
    required IAccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _appSettingsRepository = appSettingsRepository,
        _accountRepository = accountRepository;

  /// Executes the use case to fetch and calculate dashboard data
  ///
  /// This method:
  /// 1. Retrieves the current month's transactions with billing cycle filtering
  /// 2. Fetches the app settings
  /// 3. Calculates reserve balance from debit accounts
  /// 4. Performs all required calculations
  /// 5. Returns a complete DashboardData object
  ///
  /// For credit accounts with a creditPaymentDay, transactions are filtered
  /// by their billing cycle (calculated from payment day - 7).
  /// For debit accounts, calendar month filtering applies.
  ///
  /// Returns [DashboardData] with all calculated values
  /// Throws an exception if settings are not initialized
  Future<DashboardData> execute() async {
    try {
      final now = DateTime.now();

      // Fetch all accounts to determine billing cycle filtering
      final allAccounts = await _accountRepository.getAll();

      // Fetch transactions with billing cycle filtering applied
      final transactions = await _getFilteredTransactions(now, allAccounts);

      // Fetch app settings
      final settings = await _appSettingsRepository.get();
      if (settings == null) {
        throw Exception(
          'App settings not initialized. Please configure your salary and reserve in settings.',
        );
      }

      // Calculate reserve balance from debit account balances
      // Exclude accounts with excludeFromReserve flag (intocável)
      final reserveBalance = allAccounts
          .where((account) => account.isDebit && !account.excludeFromReserve)
          .fold<double>(0.0, (sum, account) => sum + account.balance);

      // Calculate total spent this month/cycle
      final totalSpent = _calculateTotalSpent(transactions);

      // Calculate partial result (Salary - Spending)
      final partialResult = settings.monthlySalary - totalSpent;

      // Calculate reserve-related values
      final maxAllowedReserveUsage =
          reserveBalance * (settings.maxReserveUsagePercentage / 100);

      // Calculate remaining budget:
      // (Salary + (Reserve * % Max)) - Total Spent
      final remainingBudget =
          (settings.monthlySalary + maxAllowedReserveUsage) - totalSpent;

      // Calculate final reserve
      // If spent > salary: Reserve is reduced by the overspending amount
      // Otherwise: Reserve remains intact
      final reserveOverspending = totalSpent > settings.monthlySalary
          ? (totalSpent - settings.monthlySalary)
          : 0.0;
      final finalReserve = reserveBalance - reserveOverspending;

      // Calculate reserve usage percentage
      final reserveUsagePercentage = maxAllowedReserveUsage > 0
          ? (reserveOverspending / maxAllowedReserveUsage) * 100
          : 0.0;

      return DashboardData(
        monthlySalary: settings.monthlySalary,
        totalSpent: totalSpent,
        remainingBudget: remainingBudget,
        partialResult: partialResult,
        finalReserve: finalReserve,
        reserveUsagePercentage: reserveUsagePercentage,
        initialReserve: reserveBalance,
        maxReserveUsagePercentage: settings.maxReserveUsagePercentage,
      );
    } catch (e) {
      throw Exception('Error fetching dashboard data: ${e.toString()}');
    }
  }

  /// Executes the use case reactively, returning a stream of dashboard data
  ///
  /// This method combines streams from both repositories and recalculates
  /// the dashboard data whenever any of the underlying data changes.
  /// This enables real-time UI updates without manual refresh.
  ///
  /// Returns a Stream of DashboardData that emits new values whenever
  /// transactions or app settings change
  Stream<DashboardData> executeReactive() async* {
    try {
      final transactionStream = _transactionRepository.watchCurrentMonth();

      // Emit new DashboardData whenever transaction stream changes
      await for (final _ in transactionStream) {
        try {
          final data = await execute();
          yield data;
        } catch (e) {
          yield* Stream.error(e);
        }
      }
    } catch (e) {
      yield* Stream.error(e);
    }
  }

  /// Calculates the total amount spent based on transaction list
  ///
  /// Sums up the value field of all transactions
  double _calculateTotalSpent(List<dynamic> transactions) {
    double total = 0.0;
    for (final transaction in transactions) {
      // Assumes transaction has a 'value' property
      total += (transaction as dynamic).value as double;
    }
    return total;
  }

  /// Fetches transactions filtered by billing cycle for credit accounts
  /// and by calendar month for debit accounts
  ///
  /// For each account:
  /// - If it's a credit account with a creditPaymentDay, fetch transactions
  ///   within the current billing cycle (calculated from payment - 7)
  /// - Otherwise, fetch transactions for the calendar month
  ///
  /// Returns a combined list of all filtered transactions
  Future<List<dynamic>> _getFilteredTransactions(
    DateTime referenceDate,
    List<dynamic> accounts,
  ) async {
    final allTransactions = <dynamic>[];

    for (final account in accounts) {
      final accountId = (account as dynamic).id as int;
      final isCredit = (account).isCredit as bool;
      final creditPaymentDay = (account).creditPaymentDay as int?;

      if (isCredit && creditPaymentDay != null) {
        // Credit account with billing cycle - use payment day to determine current cycle
        final cycle = calculateCurrentBillingCycleFromPaymentDay(
            creditPaymentDay, referenceDate);
        final transactions =
            await _transactionRepository.getByAccountAndDateRange(
          accountId,
          cycle.start,
          cycle.end,
        );
        allTransactions.addAll(transactions);
      } else {
        // Debit account or credit account without closing day - use calendar month
        final startDate = DateTime(referenceDate.year, referenceDate.month, 1);
        final endDate = DateTime(referenceDate.year, referenceDate.month + 1, 1)
            .subtract(const Duration(seconds: 1));
        final transactions =
            await _transactionRepository.getByAccountAndDateRange(
          accountId,
          startDate,
          endDate,
        );
        allTransactions.addAll(transactions);
      }
    }

    return allTransactions;
  }
}
