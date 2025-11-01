import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/utils/billing_cycle_utils.dart';
import '../../../data/providers/repository_providers.dart';

part 'invoice_providers.g.dart';

/// Data class for dynamically calculated invoice information
///
/// This class holds all monetary values and breakdowns that are
/// calculated on-demand from transactions, never stored in the database.
class InvoiceCalculatedData {
  /// Total amount across all credit accounts for the billing period
  final double totalAmount;

  /// Breakdown of amounts by account ID
  /// Map of accountId to amount
  final Map<int, double> breakdown;

  /// Total number of transactions in the billing period
  final int transactionCount;

  const InvoiceCalculatedData({
    required this.totalAmount,
    required this.breakdown,
    required this.transactionCount,
  });

  /// Empty state with zero values
  static const empty = InvoiceCalculatedData(
    totalAmount: 0.0,
    breakdown: {},
    transactionCount: 0,
  );
}

/// Provider that calculates invoice data dynamically from transactions
///
/// **F17-T1 Implementation**: Dynamic Invoice Calculations
///
/// This provider takes an invoice period and:
/// 1. Queries all transactions in that period from credit accounts
/// 2. Calculates the total amount
/// 3. Breaks down amounts by account
/// 4. Returns the calculated data
///
/// **Parameters:**
/// - [startDate]: The start date of the billing period
/// - [endDate]: The end date of the billing period
///
/// **Returns:**
/// InvoiceCalculatedData with all calculated values
@riverpod
Future<InvoiceCalculatedData> invoiceCalculatedData(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);

  // Get all accounts to identify credit accounts
  final accounts = await accountRepo.getAll();
  final creditAccounts = accounts.where((a) => a.isCredit).toList();

  if (creditAccounts.isEmpty) {
    return InvoiceCalculatedData.empty;
  }

  // Get all transactions
  final allTransactions = await transactionRepo.getAll();

  // Add 1 day to end date to make it inclusive (same logic as repository)
  final inclusiveEnd = endDate.add(const Duration(days: 1));

  // Filter transactions for credit accounts in the billing period
  final periodTransactions = allTransactions.where((t) {
    // Check if transaction is from a credit account
    final account = accounts.where((a) => a.id == t.accountId).firstOrNull;
    if (account == null || !account.isCredit) {
      return false;
    }

    // Check if transaction is within the period
    return t.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
        t.date.isBefore(inclusiveEnd);
  }).toList();

  // Calculate breakdown by account
  final breakdown = <int, double>{};
  for (final transaction in periodTransactions) {
    breakdown[transaction.accountId] =
        (breakdown[transaction.accountId] ?? 0.0) + transaction.value;
  }

  // Calculate total
  final total = breakdown.values.fold<double>(0.0, (sum, v) => sum + v);

  return InvoiceCalculatedData(
    totalAmount: total,
    breakdown: breakdown,
    transactionCount: periodTransactions.length,
  );
}

/// Provider that holds the current invoice period being viewed
///
/// **F17-T1 Implementation**: Time Navigation State
///
/// This StateProvider tracks which billing period the user is currently
/// viewing in the dashboard. It can be modified via swipe gestures or
/// arrow button navigation.
///
/// The value is a BillingCyclePeriod representing the current view state.
/// When null, the UI should default to the first unpaid invoice or
/// the current unified billing cycle.
@riverpod
class CurrentInvoicePeriod extends _$CurrentInvoicePeriod {
  @override
  BillingCyclePeriod? build() {
    // Initial state is null - will be set by the UI based on:
    // 1. First unpaid invoice period, or
    // 2. Current unified billing cycle if no invoices exist
    return null;
  }

  /// Navigate to a specific period
  void setPeriod(BillingCyclePeriod period) {
    state = period;
  }

  /// Navigate to the previous billing period
  ///
  /// This method calculates the previous period by finding the earliest
  /// payment day among all credit cards and moving back one cycle.
  Future<void> goToPreviousPeriod() async {
    if (state == null) return;

    final accountRepo = ref.read(accountRepositoryProvider);
    final accounts = await accountRepo.getAll();
    final creditAccounts = accounts.where((a) => a.isCredit).toList();

    if (creditAccounts.isEmpty) return;

    // Find the earliest payment day to determine cycle length
    int? earliestPaymentDay;
    for (final account in creditAccounts) {
      if (account.creditPaymentDay != null) {
        if (earliestPaymentDay == null ||
            account.creditPaymentDay! < earliestPaymentDay) {
          earliestPaymentDay = account.creditPaymentDay;
        }
      }
    }

    if (earliestPaymentDay == null) return;

    // Calculate the previous period using the earliest payment day
    // Move back from the current start date
    final previousReferenceDate =
        state!.start.subtract(const Duration(days: 15));
    final previousPeriod = calculateUnifiedInvoicePeriod(
      creditAccounts,
      previousReferenceDate,
    );

    if (previousPeriod != null) {
      state = previousPeriod;
    }
  }

  /// Navigate to the next billing period
  ///
  /// This method calculates the next period by finding the latest
  /// payment day among all credit cards and moving forward one cycle.
  Future<void> goToNextPeriod() async {
    if (state == null) return;

    final accountRepo = ref.read(accountRepositoryProvider);
    final accounts = await accountRepo.getAll();
    final creditAccounts = accounts.where((a) => a.isCredit).toList();

    if (creditAccounts.isEmpty) return;

    // Find the latest payment day to determine cycle length
    int? latestPaymentDay;
    for (final account in creditAccounts) {
      if (account.creditPaymentDay != null) {
        if (latestPaymentDay == null ||
            account.creditPaymentDay! > latestPaymentDay) {
          latestPaymentDay = account.creditPaymentDay;
        }
      }
    }

    if (latestPaymentDay == null) return;

    // Calculate the next period using the latest payment day
    // Move forward from the current end date
    final nextReferenceDate = state!.end.add(const Duration(days: 15));
    final nextPeriod = calculateUnifiedInvoicePeriod(
      creditAccounts,
      nextReferenceDate,
    );

    if (nextPeriod != null) {
      state = nextPeriod;
    }
  }

  /// Reset to the default period (first unpaid or current cycle)
  Future<void> resetToDefault() async {
    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      final accountRepo = ref.read(accountRepositoryProvider);

      // Try to get first unpaid invoice
      final firstUnpaid = await invoiceRepo.getFirstUnpaidOrFirst();

      if (firstUnpaid != null) {
        state = BillingCyclePeriod(
          start: firstUnpaid.startDate,
          end: firstUnpaid.endDate,
        );
        return;
      }

      // Otherwise, use current unified billing cycle
      final accounts = await accountRepo.getAll();
      final creditAccounts = accounts.where((a) => a.isCredit).toList();

      if (creditAccounts.isEmpty) {
        // No credit accounts - use a default period of current month
        final now = DateTime.now();
        state = BillingCyclePeriod(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0),
        );
        return;
      }

      final currentPeriod = calculateUnifiedInvoicePeriod(creditAccounts);
      if (currentPeriod != null) {
        state = currentPeriod;
      } else {
        // Fallback: use current month if calculation fails
        final now = DateTime.now();
        state = BillingCyclePeriod(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0),
        );
      }
    } catch (e) {
      // Fallback on error: use current month
      final now = DateTime.now();
      state = BillingCyclePeriod(
        start: DateTime(now.year, now.month, 1),
        end: DateTime(now.year, now.month + 1, 0),
      );
    }
  }
}
