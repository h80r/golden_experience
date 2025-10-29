/// Utility functions for credit card billing cycle calculations.
///
/// This module provides date calculation functions to determine billing cycle
/// periods based on a credit card's closing day, handling edge cases like
/// month-end transitions, February, and leap years.
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
