/// Utility for handling Brazilian holidays and work-day calculations
/// Supports national Brazilian holidays and Sao Paulo specific holidays
library;

class BrazilianHolidays {
  /// Brazilian national holidays (month, day)
  static const Map<int, List<int>> nationalHolidays = {
    1: [1], // New Year
    3: [29], // Good Friday (varies, but we use fixed for simplicity)
    4: [21], // Tiradentes' Day
    5: [1], // Labor Day
    6: [20], // Corpus Christi (varies)
    9: [7], // Independence Day
    10: [12], // Our Lady Aparecida
    11: [
      2,
      15,
      20
    ], // All Souls' Day, Proclamation of the Republic, Black Consciousness Day
    12: [25], // Christmas
  };

  /// Sao Paulo state specific holidays (month, day)
  static const Map<int, List<int>> saoPauloHolidays = {
    7: [9], // Constitutional Revolution Day
  };

  /// Fixed holiday dates for 2024-2030 (more accurate than calculated)
  /// Returns all holidays for the specified year
  static Set<DateTime> getHolidaysForYear(int year) {
    final holidays = <DateTime>{};

    // Fixed national holidays
    holidays.add(DateTime(year, 1, 1)); // New Year
    holidays.add(DateTime(year, 4, 21)); // Tiradentes
    holidays.add(DateTime(year, 5, 1)); // Labor Day
    holidays.add(DateTime(year, 9, 7)); // Independence Day
    holidays.add(DateTime(year, 10, 12)); // Our Lady
    holidays.add(DateTime(year, 11, 2)); // All Souls
    holidays.add(DateTime(year, 11, 15)); // Republic Day
    holidays.add(DateTime(year, 11, 20)); // Black Consciousness
    holidays.add(DateTime(year, 12, 25)); // Christmas

    // Movable holidays (Good Friday, Corpus Christi, etc.)
    // These dates are calculated for 2024-2030
    final easterDates = _getEasterDatesForYears();
    if (easterDates.containsKey(year)) {
      final easter = easterDates[year]!;
      holidays.add(easter.subtract(Duration(days: 2))); // Good Friday
      holidays.add(easter.add(Duration(days: 60))); // Corpus Christi
    }

    // São Paulo specific holidays
    holidays.add(DateTime(year, 7, 9)); // Constitutional Revolution

    return holidays;
  }

  /// Get Easter dates for 2024-2030 (hardcoded, accurate)
  static Map<int, DateTime> _getEasterDatesForYears() {
    return {
      2024: DateTime(2024, 3, 31),
      2025: DateTime(2025, 4, 20),
      2026: DateTime(2026, 4, 5),
      2027: DateTime(2027, 3, 28),
      2028: DateTime(2028, 4, 16),
      2029: DateTime(2029, 4, 1),
      2030: DateTime(2030, 4, 21),
    };
  }

  /// Check if a date is a work day (Monday-Friday, not a holiday)
  static bool isWorkDay(DateTime date) {
    // Check if it's a weekend (Sunday = 7, Saturday = 6)
    if (date.weekday == DateTime.sunday || date.weekday == DateTime.saturday) {
      return false;
    }

    // Check if it's a holiday
    final holidays = getHolidaysForYear(date.year);
    return !holidays.contains(
      DateTime(date.year, date.month, date.day),
    );
  }

  /// Get the nth work day of the month
  /// n: 1-based (1 = first work day, 5 = fifth work day, etc.)
  /// Returns null if the nth work day doesn't exist
  static DateTime? getNthWorkDay(DateTime month, int n) {
    if (n < 1) return null;

    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = month.month == 12
        ? DateTime(month.year + 1, 1, 0)
        : DateTime(month.year, month.month + 1, 0);

    var workDayCount = 0;
    var currentDate = firstDay;

    while (currentDate.isBefore(lastDay) ||
        currentDate.isAtSameMomentAs(lastDay)) {
      if (isWorkDay(currentDate)) {
        workDayCount++;
        if (workDayCount == n) {
          return currentDate;
        }
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    // nth work day doesn't exist for this month
    return null;
  }

  /// Get the last work day of the month
  static DateTime? getLastWorkDay(DateTime month) {
    final lastDay = month.month == 12
        ? DateTime(month.year + 1, 1, 0)
        : DateTime(month.year, month.month + 1, 0);

    var currentDate = lastDay;
    while (currentDate.month == month.month) {
      if (isWorkDay(currentDate)) {
        return currentDate;
      }
      currentDate = currentDate.subtract(Duration(days: 1));
    }

    return null;
  }

  /// Calculate the actual work-day date for salary payment
  /// If the calculated date is in the past, returns next month's date
  /// value: '1'-'23' for nth work-day, or 'last' for last work-day
  static DateTime? calculateSalaryPaymentDate(String value) {
    final today = DateTime.now();
    final currentMonth = DateTime(today.year, today.month);

    DateTime? candidateDate;

    if (value == 'last') {
      candidateDate = getLastWorkDay(currentMonth);
    } else {
      final n = int.tryParse(value);
      if (n != null) {
        candidateDate = getNthWorkDay(currentMonth, n);
      }
    }

    if (candidateDate == null) return null;

    // If in the past, try next month
    if (candidateDate.isBefore(today)) {
      final nextMonth = currentMonth.month == 12
          ? DateTime(currentMonth.year + 1, 1)
          : DateTime(currentMonth.year, currentMonth.month + 1);

      if (value == 'last') {
        return getLastWorkDay(nextMonth);
      } else {
        final n = int.tryParse(value);
        if (n != null) {
          return getNthWorkDay(nextMonth, n);
        }
      }
    }

    return candidateDate;
  }
}
