import '../models/dashboard_data.dart';
import '../repositories/i_app_settings_repository.dart';
import '../repositories/i_transaction_repository.dart';

/// Use case for fetching and calculating all dashboard financial data
///
/// This use case is responsible for:
/// 1. Fetching the current month's transactions
/// 2. Fetching app settings (salary, reserve, limits)
/// 3. Performing all financial calculations according to business logic
/// 4. Returning a complete DashboardData object for UI consumption
///
/// The calculations follow the PRD specifications:
/// - **Total Spent:** Sum of all transactions for the current month
/// - **Salary - Spending:** Simple difference
/// - **Remaining Budget:** (Salary + (Reserve * % Max)) - Total Spent
/// - **Final Reserve:** Reserve - (Total Spent - Salary) when spent > salary
/// - **Reserve Usage %:** Percentage of max allowed reserve that was consumed
class GetDashboardDataUseCase {
  final ITransactionRepository _transactionRepository;
  final IAppSettingsRepository _appSettingsRepository;

  const GetDashboardDataUseCase({
    required ITransactionRepository transactionRepository,
    required IAppSettingsRepository appSettingsRepository,
  })  : _transactionRepository = transactionRepository,
        _appSettingsRepository = appSettingsRepository;

  /// Executes the use case to fetch and calculate dashboard data
  ///
  /// This method:
  /// 1. Retrieves the current month's transactions
  /// 2. Fetches the app settings
  /// 3. Performs all required calculations
  /// 4. Returns a complete DashboardData object
  ///
  /// Returns [DashboardData] with all calculated values
  /// Throws an exception if settings are not initialized
  Future<DashboardData> execute() async {
    try {
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      // Fetch transactions for current month
      final transactions =
          await _transactionRepository.getByMonth(currentMonth, currentYear);

      // Fetch app settings
      final settings = await _appSettingsRepository.get();
      if (settings == null) {
        throw Exception(
          'App settings not initialized. Please configure your salary and reserve in settings.',
        );
      }

      // Calculate total spent this month
      final totalSpent = _calculateTotalSpent(transactions);

      // Calculate partial result (Salary - Spending)
      final partialResult = settings.monthlySalary - totalSpent;

      // Calculate reserve-related values
      final maxAllowedReserveUsage =
          settings.reserveBalance * (settings.maxReserveUsagePercentage / 100);

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
      final finalReserve = settings.reserveBalance - reserveOverspending;

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
        initialReserve: settings.reserveBalance,
        maxReserveUsagePercentage: settings.maxReserveUsagePercentage,
      );
    } catch (e) {
      throw Exception('Error fetching dashboard data: ${e.toString()}');
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
}
