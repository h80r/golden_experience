import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/core/utils/billing_cycle_utils.dart';

void main() {
  group('BillingCyclePeriod', () {
    test('contains() returns true for date within cycle', () {
      final period = BillingCyclePeriod(
        start: DateTime(2024, 10, 26),
        end: DateTime(2024, 11, 25),
      );

      expect(period.contains(DateTime(2024, 10, 26)), isTrue);
      expect(period.contains(DateTime(2024, 11, 10)), isTrue);
      expect(period.contains(DateTime(2024, 11, 25)), isTrue);
    });

    test('contains() returns false for date outside cycle', () {
      final period = BillingCyclePeriod(
        start: DateTime(2024, 10, 26),
        end: DateTime(2024, 11, 25),
      );

      expect(period.contains(DateTime(2024, 10, 25)), isFalse);
      expect(period.contains(DateTime(2024, 11, 26)), isFalse);
      expect(period.contains(DateTime(2024, 12, 1)), isFalse);
    });

    test('equality works correctly', () {
      final period1 = BillingCyclePeriod(
        start: DateTime(2024, 10, 26),
        end: DateTime(2024, 11, 25),
      );
      final period2 = BillingCyclePeriod(
        start: DateTime(2024, 10, 26),
        end: DateTime(2024, 11, 25),
      );
      final period3 = BillingCyclePeriod(
        start: DateTime(2024, 10, 27),
        end: DateTime(2024, 11, 25),
      );

      expect(period1, equals(period2));
      expect(period1, isNot(equals(period3)));
    });
  });

  group('calculateCurrentBillingCycle', () {
    test('returns correct cycle when reference date is after closing day', () {
      // Closing day is 25th, today is November 28
      final cycle = calculateCurrentBillingCycle(
        25,
        DateTime(2024, 11, 28),
      );

      expect(cycle.start, DateTime(2024, 11, 26));
      expect(cycle.end, DateTime(2024, 12, 25));
    });

    test('returns correct cycle when reference date is before closing day', () {
      // Closing day is 25th, today is November 15
      final cycle = calculateCurrentBillingCycle(
        25,
        DateTime(2024, 11, 15),
      );

      expect(cycle.start, DateTime(2024, 10, 26));
      expect(cycle.end, DateTime(2024, 11, 25));
    });

    test('returns correct cycle when reference date is on closing day', () {
      // Closing day is 25th, today is November 25
      final cycle = calculateCurrentBillingCycle(
        25,
        DateTime(2024, 11, 25),
      );

      expect(cycle.start, DateTime(2024, 10, 26));
      expect(cycle.end, DateTime(2024, 11, 25));
    });

    test('handles closing day 1 correctly', () {
      // Closing day is 1st, today is November 15
      final cycle = calculateCurrentBillingCycle(
        1,
        DateTime(2024, 11, 15),
      );

      expect(cycle.start, DateTime(2024, 11, 2));
      expect(cycle.end, DateTime(2024, 12, 1));
    });

    test('handles closing day at end of month correctly', () {
      // Closing day is 31st, today is October 15
      final cycle = calculateCurrentBillingCycle(
        31,
        DateTime(2024, 10, 15),
      );

      expect(cycle.start, DateTime(2024, 10, 1)); // Sept 30 + 1 day
      expect(cycle.end, DateTime(2024, 10, 31));
    });

    test('handles February in non-leap year with closing day 31', () {
      // Closing day is 31st, today is February 15, 2023
      final cycle = calculateCurrentBillingCycle(
        31,
        DateTime(2023, 2, 15),
      );

      expect(cycle.start, DateTime(2023, 1, 31)); // Jan has 31 days
      expect(cycle.end, DateTime(2023, 2, 28)); // Feb has 28 days (non-leap)
    });

    test('handles February in leap year with closing day 31', () {
      // Closing day is 31st, today is February 15, 2024
      final cycle = calculateCurrentBillingCycle(
        31,
        DateTime(2024, 2, 15),
      );

      expect(cycle.start, DateTime(2024, 1, 31)); // Jan has 31 days
      expect(cycle.end, DateTime(2024, 2, 29)); // Feb has 29 days (leap year)
    });

    test('handles transition from February to March in leap year', () {
      // Closing day is 31st, today is March 15, 2024
      final cycle = calculateCurrentBillingCycle(
        31,
        DateTime(2024, 3, 15),
      );

      expect(cycle.start, DateTime(2024, 3, 1)); // Feb 29 + 1 day
      expect(cycle.end, DateTime(2024, 3, 31));
    });

    test('handles months with 30 days when closing day is 31', () {
      // Closing day is 31st, today is April 15 (April has 30 days)
      final cycle = calculateCurrentBillingCycle(
        31,
        DateTime(2024, 4, 15),
      );

      expect(cycle.start, DateTime(2024, 3, 31)); // Mar has 31 days
      expect(cycle.end, DateTime(2024, 4, 30)); // April has 30 days
    });

    test('handles year transition correctly', () {
      // Closing day is 25th, today is January 10, 2025
      final cycle = calculateCurrentBillingCycle(
        25,
        DateTime(2025, 1, 10),
      );

      expect(cycle.start, DateTime(2024, 12, 26));
      expect(cycle.end, DateTime(2025, 1, 25));
    });

    test('handles year transition when after closing day', () {
      // Closing day is 25th, today is December 28, 2024
      final cycle = calculateCurrentBillingCycle(
        25,
        DateTime(2024, 12, 28),
      );

      expect(cycle.start, DateTime(2024, 12, 26));
      expect(cycle.end, DateTime(2025, 1, 25));
    });

    test('uses current date when reference date is not provided', () {
      final now = DateTime.now();
      final cycle = calculateCurrentBillingCycle(15);

      // Verify that cycle spans approximately 1 month
      final duration = cycle.end.difference(cycle.start).inDays;
      expect(duration, greaterThanOrEqualTo(28));
      expect(duration, lessThanOrEqualTo(31));

      // Verify that the cycle includes today or is adjacent to it
      final isInCycle = cycle.contains(now);
      final isNearCycle = now.difference(cycle.end).inDays.abs() <= 31;

      expect(isInCycle || isNearCycle, isTrue);
    });
  });

  group('isInCurrentBillingCycle', () {
    test('returns true for transaction within current cycle', () {
      // Closing day 25, reference Nov 15, check Nov 10
      final result = isInCurrentBillingCycle(
        DateTime(2024, 11, 10),
        25,
        DateTime(2024, 11, 15),
      );

      expect(result, isTrue);
    });

    test('returns false for transaction outside current cycle', () {
      // Closing day 25, reference Nov 15, check Dec 1
      final result = isInCurrentBillingCycle(
        DateTime(2024, 12, 1),
        25,
        DateTime(2024, 11, 15),
      );

      expect(result, isFalse);
    });

    test('returns true for transaction on cycle start date', () {
      // Closing day 25, reference Nov 15, check Oct 26 (start of cycle)
      final result = isInCurrentBillingCycle(
        DateTime(2024, 10, 26),
        25,
        DateTime(2024, 11, 15),
      );

      expect(result, isTrue);
    });

    test('returns true for transaction on cycle end date', () {
      // Closing day 25, reference Nov 15, check Nov 25 (end of cycle)
      final result = isInCurrentBillingCycle(
        DateTime(2024, 11, 25),
        25,
        DateTime(2024, 11, 15),
      );

      expect(result, isTrue);
    });
  });

  group('formatBillingCyclePeriod', () {
    test('formats cycle without year by default', () {
      final period = BillingCyclePeriod(
        start: DateTime(2024, 10, 26),
        end: DateTime(2024, 11, 25),
      );

      final formatted = formatBillingCyclePeriod(period);

      expect(formatted, '26/10 - 25/11');
    });

    test('formats cycle with year when requested', () {
      final period = BillingCyclePeriod(
        start: DateTime(2024, 10, 26),
        end: DateTime(2024, 11, 25),
      );

      final formatted = formatBillingCyclePeriod(period, includeYear: true);

      expect(formatted, '26/10/2024 - 25/11/2024');
    });

    test('formats cycle with single-digit days correctly', () {
      final period = BillingCyclePeriod(
        start: DateTime(2024, 10, 1),
        end: DateTime(2024, 11, 5),
      );

      final formatted = formatBillingCyclePeriod(period);

      expect(formatted, '01/10 - 05/11');
    });

    test('formats cycle spanning year boundary', () {
      final period = BillingCyclePeriod(
        start: DateTime(2024, 12, 26),
        end: DateTime(2025, 1, 25),
      );

      final formatted = formatBillingCyclePeriod(period, includeYear: true);

      expect(formatted, '26/12/2024 - 25/01/2025');
    });
  });

  group('getBillingCycleForMonth', () {
    test(
        'returns correct cycle for target month (November 2024, closing day 25)',
        () {
      final cycle = getBillingCycleForMonth(2024, 11, 25);

      expect(cycle.start, DateTime(2024, 10, 26));
      expect(cycle.end, DateTime(2024, 11, 25));
    });

    test('returns correct cycle for January with year transition', () {
      final cycle = getBillingCycleForMonth(2025, 1, 25);

      expect(cycle.start, DateTime(2024, 12, 26));
      expect(cycle.end, DateTime(2025, 1, 25));
    });

    test('returns correct cycle for February in leap year', () {
      final cycle = getBillingCycleForMonth(2024, 2, 31);

      expect(cycle.start, DateTime(2024, 1, 31));
      expect(cycle.end, DateTime(2024, 2, 29)); // Leap year
    });

    test('returns correct cycle for February in non-leap year', () {
      final cycle = getBillingCycleForMonth(2023, 2, 31);

      expect(cycle.start, DateTime(2023, 1, 31));
      expect(cycle.end, DateTime(2023, 2, 28)); // Non-leap year
    });

    test('returns correct cycle for month with 30 days (April)', () {
      final cycle = getBillingCycleForMonth(2024, 4, 31);

      expect(cycle.start, DateTime(2024, 3, 31));
      expect(cycle.end, DateTime(2024, 4, 30)); // April has 30 days
    });
  });

  group('calculateCurrentBillingCycleFromPaymentDay', () {
    test('returns correct cycle when transaction is on first day after closing',
        () {
      // Payment day 1 (closing ~Oct 25), transaction on Oct 26
      // This is the EXACT bug scenario reported by the user
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        1,
        DateTime(2024, 10, 26),
      );

      // Expected: Oct 26 - Nov 24 (cycle ends Nov 24, payment due Dec 1)
      expect(cycle.start, DateTime(2024, 10, 26));
      expect(cycle.end, DateTime(2024, 11, 24));
    });

    test('returns correct cycle when before closing day', () {
      // Payment day 15 (closing ~8th), transaction on Nov 6
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        15,
        DateTime(2024, 11, 6),
      );

      // Expected: Oct 9 - Nov 8 (still in current cycle before closing)
      expect(cycle.start, DateTime(2024, 10, 9));
      expect(cycle.end, DateTime(2024, 11, 8));
    });

    test('returns correct cycle when after closing day', () {
      // Payment day 15 (closing ~8th), transaction on Nov 10
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        15,
        DateTime(2024, 11, 10),
      );

      // Expected: Nov 9 - Dec 8 (in next cycle after closing)
      expect(cycle.start, DateTime(2024, 11, 9));
      expect(cycle.end, DateTime(2024, 12, 8));
    });

    test('returns correct cycle when on closing day', () {
      // Payment day 15 (closing ~8th), transaction on Nov 8
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        15,
        DateTime(2024, 11, 8),
      );

      // Expected: Oct 9 - Nov 8 (on closing day, still in current cycle)
      expect(cycle.start, DateTime(2024, 10, 9));
      expect(cycle.end, DateTime(2024, 11, 8));
    });

    test('handles payment day 1 with transaction in middle of month', () {
      // Payment day 1 (closing varies), transaction on Nov 15
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        1,
        DateTime(2024, 11, 15),
      );

      // Expected: Oct 26 - Nov 24 (cycle for Nov 15)
      expect(cycle.start, DateTime(2024, 10, 26));
      expect(cycle.end, DateTime(2024, 11, 24));
    });

    test('handles payment day 5 (early month) correctly', () {
      // Payment day 5 (closing ~Oct 29), transaction on Oct 30
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        5,
        DateTime(2024, 10, 30),
      );

      // Oct 30 is AFTER Oct 29 closing (Nov 5 - 7 days)
      // So it's in the cycle that ends Nov 28 (Dec 5 - 7 days)
      // Expected: Oct 30 - Nov 28
      expect(cycle.start, DateTime(2024, 10, 30));
      expect(cycle.end, DateTime(2024, 11, 28));
    });

    test('handles year transition correctly with payment day 1', () {
      // Payment day 1, transaction on Dec 26, 2024
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        1,
        DateTime(2024, 12, 26),
      );

      // Expected: Dec 26, 2024 - Dec 25, 2025
      expect(cycle.start, DateTime(2024, 12, 26));
      expect(cycle.end, DateTime(2025, 1, 25));
    });

    test('handles February with payment day 1 in leap year', () {
      // Payment day 1, transaction on Feb 26, 2024 (leap year)
      final cycle = calculateCurrentBillingCycleFromPaymentDay(
        1,
        DateTime(2024, 2, 26),
      );

      // Feb 26 is AFTER Feb 23 closing (Mar 1 - 7 days)
      // So it's in the cycle that ends Mar 25 (Apr 1 - 7 days)
      // Expected: Feb 24 - Mar 25
      expect(cycle.start, DateTime(2024, 2, 24));
      expect(cycle.end, DateTime(2024, 3, 25));
    });

    test('ensures installments distribute correctly across cycles', () {
      // This test simulates the installment scenario:
      // Transaction on Oct 26 with payment day 1
      // Installment 6 should be in Oct 26-Nov 24
      // Installment 7 should be in Nov 25-Dec 25 (approx)

      final cycle1 = calculateCurrentBillingCycleFromPaymentDay(
        1,
        DateTime(2024, 10, 26),
      );
      expect(cycle1.start, DateTime(2024, 10, 26));
      expect(cycle1.end, DateTime(2024, 11, 24));

      // Next cycle starts the day after cycle1 ends
      final cycle2 = calculateCurrentBillingCycleFromPaymentDay(
        1,
        DateTime(2024, 11, 25), // Day after previous cycle ends
      );
      expect(cycle2.start, DateTime(2024, 11, 25));
      expect(cycle2.end, DateTime(2024, 12, 25));

      // Verify cycles don't overlap
      expect(cycle1.end.add(const Duration(days: 1)), equals(cycle2.start));
    });
  });

  group('Edge Cases', () {
    test('handles closing day 29 in February non-leap year', () {
      final cycle = calculateCurrentBillingCycle(
        29,
        DateTime(2023, 2, 15),
      );

      expect(cycle.start, DateTime(2023, 1, 29));
      expect(cycle.end, DateTime(2023, 2, 28)); // Feb has 28 days
    });

    test('handles closing day 30 in February leap year', () {
      final cycle = calculateCurrentBillingCycle(
        30,
        DateTime(2024, 2, 15),
      );

      expect(cycle.start, DateTime(2024, 1, 30));
      expect(cycle.end, DateTime(2024, 2, 29)); // Feb has 29 days in leap year
    });

    test('handles transition from month with 31 days to month with 30 days',
        () {
      // May has 31 days, June has 30 days
      final cycle = calculateCurrentBillingCycle(
        31,
        DateTime(2024, 6, 15),
      );

      expect(cycle.start, DateTime(2024, 5, 31)); // May has 31 days
      expect(cycle.end, DateTime(2024, 6, 30)); // June has 30 days
    });

    test('handles multiple consecutive months with different day counts', () {
      // Closing day 31, checking March (after Feb 29 in leap year)
      final marchCycle = calculateCurrentBillingCycle(
        31,
        DateTime(2024, 3, 20),
      );

      expect(marchCycle.start, DateTime(2024, 3, 1)); // Feb 29 + 1
      expect(marchCycle.end, DateTime(2024, 3, 31));

      // Closing day 31, checking April (after Mar 31)
      final aprilCycle = calculateCurrentBillingCycle(
        31,
        DateTime(2024, 4, 20),
      );

      expect(aprilCycle.start, DateTime(2024, 3, 31)); // Mar has 31
      expect(aprilCycle.end, DateTime(2024, 4, 30)); // Apr has 30
    });
  });
}
