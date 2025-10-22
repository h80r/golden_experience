/// Model representing all the financial data needed for the Dashboard
///
/// This model contains all calculations required to answer the core question:
/// "How much can I still spend this month?"
///
/// Calculations:
/// 1. **Total Spent:** Sum of all transactions for the current month
/// 2. **Salary - Spending:** Simple difference between monthly salary and total spent
/// 3. **Remaining Budget:** (Salary + (Reserve * % Maximum)) - Total Spent
/// 4. **Final Reserve:** Reserve Initial - (Total Spent - Salary) (if spent > salary)
/// 5. **Reserve Usage %:** Percentage of reserve that has been used
class DashboardData {
  /// Monthly salary configured in settings
  final double monthlySalary;

  /// Total amount spent in the current month (sum of all transactions)
  final double totalSpent;

  /// Amount still available to spend: (Salary + (Reserve * % Max)) - Total Spent
  /// This is the main answer to "How much can I still spend?"
  final double remainingBudget;

  /// Simple difference: Salary - Total Spent
  /// Shows the situation before considering the reserve
  final double partialResult;

  /// Reserve balance after potentially using it for overspending
  /// = Reserve Initial - (Total Spent - Salary) when Total Spent > Salary
  /// = Reserve Initial (unchanged) when Total Spent <= Salary
  final double finalReserve;

  /// Percentage of the maximum allowed reserve usage that has been consumed
  /// Used to display reserve depletion visually
  final double reserveUsagePercentage;

  /// Initial reserve balance (for reference and calculations)
  final double initialReserve;

  /// Maximum allowed reserve usage percentage (for reference and calculations)
  final double maxReserveUsagePercentage;

  const DashboardData({
    required this.monthlySalary,
    required this.totalSpent,
    required this.remainingBudget,
    required this.partialResult,
    required this.finalReserve,
    required this.reserveUsagePercentage,
    required this.initialReserve,
    required this.maxReserveUsagePercentage,
  });

  /// Factory constructor to create a DashboardData with all zeros
  /// Useful for initial state or error handling
  factory DashboardData.empty() {
    return const DashboardData(
      monthlySalary: 0.0,
      totalSpent: 0.0,
      remainingBudget: 0.0,
      partialResult: 0.0,
      finalReserve: 0.0,
      reserveUsagePercentage: 0.0,
      initialReserve: 0.0,
      maxReserveUsagePercentage: 0.0,
    );
  }

  @override
  String toString() {
    return 'DashboardData('
        'monthlySalary: $monthlySalary, '
        'totalSpent: $totalSpent, '
        'remainingBudget: $remainingBudget, '
        'partialResult: $partialResult, '
        'finalReserve: $finalReserve, '
        'reserveUsagePercentage: $reserveUsagePercentage)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardData &&
          runtimeType == other.runtimeType &&
          monthlySalary == other.monthlySalary &&
          totalSpent == other.totalSpent &&
          remainingBudget == other.remainingBudget &&
          partialResult == other.partialResult &&
          finalReserve == other.finalReserve &&
          reserveUsagePercentage == other.reserveUsagePercentage &&
          initialReserve == other.initialReserve &&
          maxReserveUsagePercentage == other.maxReserveUsagePercentage;

  @override
  int get hashCode =>
      monthlySalary.hashCode ^
      totalSpent.hashCode ^
      remainingBudget.hashCode ^
      partialResult.hashCode ^
      finalReserve.hashCode ^
      reserveUsagePercentage.hashCode ^
      initialReserve.hashCode ^
      maxReserveUsagePercentage.hashCode;
}
