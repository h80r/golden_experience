/// Utility functions for credit card billing cycle calculations.
///
/// This module provides date calculation functions to determine billing cycle
/// periods based on a credit card's payment day. The closing day is automatically
/// calculated as payment day minus 7 days, creating a clear separation between:
/// - **Closing day**: When the billing cycle ends and the statement is generated
/// - **Payment day**: When the bill is due for payment
/// - **Ideal purchase period**: The 7-day window between closing and payment where
///   purchases don't impact the current bill
///
/// Edge cases like month-end transitions, February, and leap years are handled.
library;

/// Represents a billing cycle period with start and end dates.
class BillingCyclePeriod {
  /// The start date of the billing cycle (inclusive).
  final DateTime start;

  /// The end date of the billing cycle (inclusive).
  final DateTime end;

  const BillingCyclePeriod({
    required this.start,
    required this.end,
  });

  /// Returns true if the given [date] falls within this billing cycle period.
  bool contains(DateTime date) {
    return date.isAfter(start.subtract(const Duration(seconds: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }

  @override
  String toString() {
    return 'BillingCyclePeriod(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BillingCyclePeriod &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

/// Calculates the current billing cycle period for a credit card account.
///
/// The billing cycle runs from the previous month's closing day
/// to the current month's closing day (both inclusive).
///
/// **Parameters:**
/// - [closingDay]: The day of the month when the billing cycle closes (1-31).
/// - [referenceDate]: The date to use as reference for "current" cycle.
///   Defaults to today if not provided.
///
/// **Returns:**
/// A [BillingCyclePeriod] representing the current billing cycle.
///
/// **Edge Cases:**
/// - If [closingDay] is greater than the number of days in a month,
///   the last day of that month is used.
/// - Handles February correctly (28 days, 29 in leap years).
/// - Handles month transitions seamlessly.
///
/// **Examples:**
/// ```dart
/// // Closing day is the 25th, today is November 15, 2024
/// final cycle = calculateCurrentBillingCycle(25, DateTime(2024, 11, 15));
/// // Returns: start = Oct 25, 2024, end = Nov 25, 2024
///
/// // Closing day is the 31st, today is June 15, 2024
/// final cycle = calculateCurrentBillingCycle(31, DateTime(2024, 6, 15));
/// // Returns: start = May 31, 2024, end = June 30, 2024 (June has only 30 days)
/// ```
BillingCyclePeriod calculateCurrentBillingCycle(
  int closingDay, [
  DateTime? referenceDate,
]) {
  final now = referenceDate ?? DateTime.now();

  // Normalize the reference date to midnight for consistent comparisons
  final normalizedNow = DateTime(now.year, now.month, now.day);

  // Calculate the closing date for the current month
  final currentMonthClosing = _getClosingDate(now.year, now.month, closingDay);

  // Determine if we're before or after the closing day
  if (normalizedNow.isAfter(currentMonthClosing)) {
    // We're after this month's closing day, so the cycle runs from
    // the day after this month's closing to next month's closing
    final startDate = currentMonthClosing.add(const Duration(days: 1));
    final nextMonth = now.month == 12 ? 1 : now.month + 1;
    final nextYear = now.month == 12 ? now.year + 1 : now.year;
    final endDate = _getClosingDate(nextYear, nextMonth, closingDay);

    return BillingCyclePeriod(start: startDate, end: endDate);
  } else {
    // We're before or on this month's closing day, so the cycle runs from
    // the day after last month's closing to this month's closing
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;
    final prevMonthClosing = _getClosingDate(prevYear, prevMonth, closingDay);

    final startDate = prevMonthClosing.add(const Duration(days: 1));
    final endDate = currentMonthClosing;

    return BillingCyclePeriod(start: startDate, end: endDate);
  }
}

/// Returns the actual closing date for a given year, month, and closing day.
///
/// Handles edge cases where the closing day exceeds the number of days in the month.
/// For example, if closingDay is 31 but the month only has 30 days, returns the 30th.
///
/// **Parameters:**
/// - [year]: The year of the closing date.
/// - [month]: The month of the closing date (1-12).
/// - [closingDay]: The desired closing day (1-31).
///
/// **Returns:**
/// A [DateTime] representing the actual closing date.
DateTime _getClosingDate(int year, int month, int closingDay) {
  // Get the number of days in the specified month
  final daysInMonth = DateTime(year, month + 1, 0).day;

  // Use the smaller of closingDay or daysInMonth
  final actualDay = closingDay > daysInMonth ? daysInMonth : closingDay;

  return DateTime(year, month, actualDay);
}

/// Checks if a transaction date falls within the current billing cycle.
///
/// This is a convenience function that combines [calculateCurrentBillingCycle]
/// and [BillingCyclePeriod.contains].
///
/// **Parameters:**
/// - [transactionDate]: The date of the transaction to check.
/// - [closingDay]: The closing day of the credit card (1-31).
/// - [referenceDate]: The date to use as reference for "current" cycle.
///   Defaults to today if not provided.
///
/// **Returns:**
/// `true` if the transaction falls within the current billing cycle, `false` otherwise.
///
/// **Example:**
/// ```dart
/// // Check if a transaction on Nov 10 is in the current cycle (closing day 25)
/// final isInCycle = isInCurrentBillingCycle(
///   DateTime(2024, 11, 10),
///   25,
///   DateTime(2024, 11, 15), // Reference date
/// );
/// // Returns: true (Nov 10 is between Oct 26 and Nov 25)
/// ```
bool isInCurrentBillingCycle(
  DateTime transactionDate,
  int closingDay, [
  DateTime? referenceDate,
]) {
  final cycle = calculateCurrentBillingCycle(closingDay, referenceDate);
  return cycle.contains(transactionDate);
}

/// Formats a billing cycle period as a readable string.
///
/// **Parameters:**
/// - [period]: The billing cycle period to format.
/// - [includeYear]: Whether to include the year in the formatted output.
///   Defaults to `false`.
///
/// **Returns:**
/// A formatted string representing the billing cycle period.
///
/// **Examples:**
/// ```dart
/// final period = BillingCyclePeriod(
///   start: DateTime(2024, 10, 26),
///   end: DateTime(2024, 11, 25),
/// );
///
/// formatBillingCyclePeriod(period); // Returns: "26/10 - 25/11"
/// formatBillingCyclePeriod(period, includeYear: true); // Returns: "26/10/2024 - 25/11/2024"
/// ```
String formatBillingCyclePeriod(
  BillingCyclePeriod period, {
  bool includeYear = false,
}) {
  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    if (includeYear) {
      return '$day/$month/${date.year}';
    }
    return '$day/$month';
  }

  return '${formatDate(period.start)} - ${formatDate(period.end)}';
}

/// Calculates the billing cycle period for a specific month and year.
///
/// Unlike [calculateCurrentBillingCycle], which determines the cycle based on
/// a reference date, this function calculates the cycle that **includes** the
/// specified month.
///
/// **Parameters:**
/// - [year]: The target year.
/// - [month]: The target month (1-12).
/// - [closingDay]: The closing day of the credit card (1-31).
///
/// **Returns:**
/// A [BillingCyclePeriod] representing the billing cycle for the specified month.
///
/// **Example:**
/// ```dart
/// // Get the billing cycle for November 2024 (closing day 25)
/// final cycle = getBillingCycleForMonth(2024, 11, 25);
/// // Returns: start = Oct 26, 2024, end = Nov 25, 2024
/// ```
BillingCyclePeriod getBillingCycleForMonth(
  int year,
  int month,
  int closingDay,
) {
  // Use the 15th of the month as a safe reference point (always exists)
  final referenceDate = DateTime(year, month, 15);
  return calculateCurrentBillingCycle(closingDay, referenceDate);
}

/// Calculates the closing day from the payment day.
///
/// The closing day is automatically calculated as **payment day minus 7 days**.
/// This creates a 7-day "ideal purchase period" between closing and payment
/// where new purchases don't impact the current bill.
///
/// **Parameters:**
/// - [paymentDay]: The payment due day (1-31).
///
/// **Returns:**
/// The calculated closing day (1-31).
///
/// **Edge Cases:**
/// - If paymentDay is 1-7, the closing day will be in the range 1-31 depending
///   on the previous month's length (handled at the date calculation level).
/// - For example, paymentDay=5 results in closingDay calculated at runtime
///   based on the previous month.
///
/// **Examples:**
/// ```dart
/// calculateClosingDay(15); // Returns: 8
/// calculateClosingDay(1);  // Returns: handled at date level (varies by month)
/// calculateClosingDay(31); // Returns: 24
/// ```
int calculateClosingDay(int paymentDay) {
  return paymentDay - 7;
}

/// Calculates the actual closing date for a given payment date.
///
/// This function handles the complexities of date arithmetic when the closing
/// day falls in the previous month or when dealing with months of varying lengths.
///
/// **Parameters:**
/// - [paymentDay]: The payment day of the month (1-31).
/// - [referenceMonth]: A DateTime in the month for which to calculate the closing date.
///
/// **Returns:**
/// A [DateTime] representing the actual closing date.
///
/// **Examples:**
/// ```dart
/// // Payment on the 15th -> Closing on the 8th (same month)
/// calculateClosingDate(15, DateTime(2024, 11, 1));
/// // Returns: DateTime(2024, 11, 8)
///
/// // Payment on the 5th -> Closing in previous month
/// calculateClosingDate(5, DateTime(2024, 11, 1));
/// // Returns: DateTime(2024, 10, 28) (Oct has 31 days, so 31 - 7 + 5 = 28)
/// ```
DateTime calculateClosingDate(int paymentDay, DateTime referenceMonth) {
  // Get the payment date in the reference month
  final paymentDate = _getClosingDate(
    referenceMonth.year,
    referenceMonth.month,
    paymentDay,
  );

  // Subtract 7 days to get the closing date
  return paymentDate.subtract(const Duration(days: 7));
}

/// Calculates the ideal purchase period for a credit card.
///
/// The "ideal purchase period" is the window between the closing date and the
/// payment date (7 days). Purchases made during this period are included in the
/// **next** billing cycle, not the current one, giving you the maximum float time.
///
/// **Logic:**
/// - If today < this month's payment day → show this month's ideal period
/// - If today >= this month's payment day → show **next month's** ideal period
///
/// **Parameters:**
/// - [paymentDay]: The payment due day (1-31).
/// - [referenceDate]: The date to use as reference. Defaults to today.
///
/// **Returns:**
/// A [BillingCyclePeriod] representing the ideal purchase window.
///
/// **Examples:**
/// ```dart
/// // Payment day is 15th, today is Nov 5, 2024
/// final idealPeriod = calculateIdealPurchasePeriod(15, DateTime(2024, 11, 5));
/// // Returns: BillingCyclePeriod(start: Nov 9, 2024, end: Nov 15, 2024)
/// // (This month's ideal period - payment hasn't happened yet)
///
/// // Payment day is 15th, today is Nov 16, 2024
/// final idealPeriod = calculateIdealPurchasePeriod(15, DateTime(2024, 11, 16));
/// // Returns: BillingCyclePeriod(start: Dec 9, 2024, end: Dec 15, 2024)
/// // (Next month's ideal period - this month's payment already happened)
/// ```
BillingCyclePeriod calculateIdealPurchasePeriod(
  int paymentDay, [
  DateTime? referenceDate,
]) {
  final now = referenceDate ?? DateTime.now();
  final normalizedNow = DateTime(now.year, now.month, now.day);

  // Get this month's payment date
  final thisMonthPaymentDate = _getClosingDate(now.year, now.month, paymentDay);

  DateTime targetMonth;

  if (normalizedNow.isBefore(thisMonthPaymentDate)) {
    // Before this month's payment day → show this month's ideal period
    targetMonth = now;
  } else {
    // On or after this month's payment day → show next month's ideal period
    final nextMonth = now.month == 12 ? 1 : now.month + 1;
    final nextYear = now.month == 12 ? now.year + 1 : now.year;
    targetMonth = DateTime(nextYear, nextMonth, 1);
  }

  // Calculate the ideal period for the target month
  final closingDate = calculateClosingDate(paymentDay, targetMonth);
  final paymentDate =
      _getClosingDate(targetMonth.year, targetMonth.month, paymentDay);
  final startDate = closingDate.add(const Duration(days: 1));

  return BillingCyclePeriod(start: startDate, end: paymentDate);
}

/// Calculates the current billing cycle based on payment day.
///
/// **IMPORTANT**: The "current" billing cycle is the one whose payment is due next
/// (or was most recently due). The cycle transitions happen at the **payment day**,
/// not the closing day.
///
/// **Logic:**
/// - If today < this month's payment day → return cycle ending this month (bill due soon)
/// - If today >= this month's payment day → return cycle ending next month (next bill)
///
/// **Parameters:**
/// - [paymentDay]: The payment due day (1-31).
/// - [referenceDate]: The date to use as reference for "current" cycle.
///   Defaults to today if not provided.
///
/// **Returns:**
/// A [BillingCyclePeriod] representing the current billing cycle.
///
/// **Examples:**
/// ```dart
/// // Payment day is 15th (closing ~8th), today is Nov 10, 2024
/// final cycle = calculateCurrentBillingCycleFromPaymentDay(15, DateTime(2024, 11, 10));
/// // Returns: start = Oct 9, 2024, end = Nov 8, 2024
/// // (Bill due Nov 15, still in this cycle)
///
/// // Payment day is 15th, today is Nov 16, 2024
/// final cycle = calculateCurrentBillingCycleFromPaymentDay(15, DateTime(2024, 11, 16));
/// // Returns: start = Nov 9, 2024, end = Dec 8, 2024
/// // (Bill for Nov 15 already paid, now in next cycle)
/// ```
BillingCyclePeriod calculateCurrentBillingCycleFromPaymentDay(
  int paymentDay, [
  DateTime? referenceDate,
]) {
  final now = referenceDate ?? DateTime.now();
  final normalizedNow = DateTime(now.year, now.month, now.day);

  // Get this month's payment date
  final thisMonthPaymentDate = _getClosingDate(now.year, now.month, paymentDay);

  // Determine which cycle we're in based on payment day
  if (normalizedNow.isBefore(thisMonthPaymentDate)) {
    // Before this month's payment day
    // → Current cycle ends this month (this is the bill we need to pay next)
    final thisMonthClosingDate = calculateClosingDate(paymentDay, now);
    final cycleEnd = thisMonthClosingDate;

    // Cycle start is the day after previous month's closing
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;
    final prevClosingDate =
        calculateClosingDate(paymentDay, DateTime(prevYear, prevMonth, 1));
    final cycleStart = prevClosingDate.add(const Duration(days: 1));

    return BillingCyclePeriod(start: cycleStart, end: cycleEnd);
  } else {
    // On or after this month's payment day
    // → Current cycle ends next month (this is the next bill we'll need to pay)
    final nextMonth = now.month == 12 ? 1 : now.month + 1;
    final nextYear = now.month == 12 ? now.year + 1 : now.year;
    final nextMonthClosingDate =
        calculateClosingDate(paymentDay, DateTime(nextYear, nextMonth, 1));
    final cycleEnd = nextMonthClosingDate;

    // Cycle start is the day after this month's closing
    final thisMonthClosingDate = calculateClosingDate(paymentDay, now);
    final cycleStart = thisMonthClosingDate.add(const Duration(days: 1));

    return BillingCyclePeriod(start: cycleStart, end: cycleEnd);
  }
}

/// Calculates a unified invoice period across all credit accounts.
///
/// **F17-T1 Implementation**: Invoice Manager with Time Navigation
///
/// This function creates a single unified billing period that spans all credit
/// accounts by taking the **earliest start date** and **latest end date** among
/// all credit cards. This ensures all transactions from all credit accounts
/// during a billing cycle are included in a single invoice.
///
/// **Logic:**
/// 1. For each credit account with a creditPaymentDay:
///    - Calculate its billing cycle using calculateCurrentBillingCycleFromPaymentDay
/// 2. Find the EARLIEST start date among all cycles
/// 3. Find the LATEST end date among all cycles
/// 4. Return a BillingCyclePeriod with these unified dates
///
/// **Parameters:**
/// - [creditAccounts]: List of account objects that have isCredit=true and creditPaymentDay set.
///   Each account must have properties: isCredit (bool) and creditPaymentDay (int?).
/// - [referenceDate]: The date to use as reference for calculating cycles.
///   Defaults to today if not provided.
///
/// **Returns:**
/// A [BillingCyclePeriod] representing the unified billing period, or `null` if
/// there are no valid credit accounts with payment days.
///
/// **Examples:**
/// ```dart
/// // Card A: payment day 15 → cycle Oct 9 - Nov 8
/// // Card B: payment day 25 → cycle Oct 19 - Nov 18
/// // Unified period: Oct 9 - Nov 18 (earliest start, latest end)
///
/// final accounts = [
///   AccountModel(isCredit: true, creditPaymentDay: 15),
///   AccountModel(isCredit: true, creditPaymentDay: 25),
/// ];
/// final unified = calculateUnifiedInvoicePeriod(accounts, DateTime(2024, 11, 10));
/// // Returns: BillingCyclePeriod(start: Oct 9, 2024, end: Nov 18, 2024)
/// ```
BillingCyclePeriod? calculateUnifiedInvoicePeriod(
  List<dynamic> creditAccounts, [
  DateTime? referenceDate,
]) {
  final now = referenceDate ?? DateTime.now();

  // Filter to only credit accounts with payment days
  final validAccounts = creditAccounts.where((account) {
    final isCredit = (account as dynamic).isCredit as bool?;
    final creditPaymentDay = (account as dynamic).creditPaymentDay as int?;
    return isCredit == true && creditPaymentDay != null;
  }).toList();

  if (validAccounts.isEmpty) {
    return null;
  }

  // Calculate billing cycle for each account
  final cycles = <BillingCyclePeriod>[];
  for (final account in validAccounts) {
    final paymentDay = (account as dynamic).creditPaymentDay as int;
    final cycle = calculateCurrentBillingCycleFromPaymentDay(paymentDay, now);
    cycles.add(cycle);
  }

  // Find earliest start and latest end
  DateTime? earliestStart;
  DateTime? latestEnd;

  for (final cycle in cycles) {
    if (earliestStart == null || cycle.start.isBefore(earliestStart)) {
      earliestStart = cycle.start;
    }
    if (latestEnd == null || cycle.end.isAfter(latestEnd)) {
      latestEnd = cycle.end;
    }
  }

  if (earliestStart == null || latestEnd == null) {
    return null;
  }

  return BillingCyclePeriod(start: earliestStart, end: latestEnd);
}
