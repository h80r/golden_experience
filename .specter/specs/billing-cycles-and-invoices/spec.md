# Billing Cycles and Invoices Specification

## Requirements

### Requirement: Closing Day Derived From Payment Day
The system SHALL always compute a credit card's closing day as `paymentDay - 7`; the closing day is never stored as an independent column.

#### Scenario: Payment day 15
- GIVEN `creditPaymentDay = 15`
- WHEN the closing day is computed
- THEN it evaluates to day 8 of the same month

#### Scenario: Payment day within the first 7 days of the month
- GIVEN `creditPaymentDay = 5`
- WHEN the closing day is computed for a reference month
- THEN it falls in the previous month (e.g. day 28/29/30/31 depending on that month's length)

### Requirement: Billing Cycle Boundary at Closing Date
The system SHALL define the current billing cycle as running from the day after the previous closing date (inclusive) to the current closing date (inclusive), transitioning exactly at the closing date, not the payment date.

#### Scenario: Reference date before closing day
- GIVEN payment day 15 (closing day 8) and today is November 6
- WHEN the current billing cycle is computed
- THEN it spans October 9 to November 8

#### Scenario: Reference date after closing day
- GIVEN payment day 15 (closing day 8) and today is November 10
- WHEN the current billing cycle is computed
- THEN it spans November 9 to December 8

### Requirement: Ideal Purchase Period
The system SHALL define a 7-day "ideal purchase period" between the closing date and the payment date, during which purchases are attributed to the next billing cycle rather than the current one.

#### Scenario: Before this month's payment day
- GIVEN payment day 15 and today is November 5
- WHEN the ideal purchase period is computed
- THEN it spans November 9 to November 15 (this month's window)

#### Scenario: On or after this month's payment day
- GIVEN payment day 15 and today is November 16
- WHEN the ideal purchase period is computed
- THEN it spans December 9 to December 15 (next month's window)

### Requirement: Unified Multi-Card Invoice Period
The system SHALL compute a single unified invoice period across all credit accounts with a payment day set, using the earliest cycle start and the latest cycle end among them.

#### Scenario: Two cards with different payment days
- GIVEN card A has payment day 15 (cycle Oct 9–Nov 8) and card B has payment day 25 (cycle Oct 19–Nov 18)
- WHEN the unified invoice period is computed
- THEN the result spans October 9 to November 18

#### Scenario: No eligible credit accounts
- GIVEN no account has both `isCredit = true` and a non-null `creditPaymentDay`
- WHEN the unified invoice period is computed
- THEN the result is null

### Requirement: Invoice Persistence Is Period-and-Status Only
The system SHALL persist an invoice as only its `startDate`, `endDate`, and `isPaid` flag; all monetary totals and per-account breakdowns MUST be computed dynamically from transactions at read time, never cached.

#### Scenario: Reading invoice totals
- GIVEN an invoice row for a given period
- WHEN its details are displayed
- THEN the total and per-account breakdown are computed on the fly by summing credit transactions within that invoice's date range

### Requirement: Lazy Invoice Creation
The system SHALL create an invoice row only when a period containing transactions is first navigated to or viewed, not eagerly for every possible period.

#### Scenario: Navigating to a period with transactions but no invoice row yet
- GIVEN a billing period has credit transactions but no corresponding row in `Invoices`
- WHEN the dashboard displays that period
- THEN an invoice row is created for that exact period

### Requirement: Unpaid Invoice Recalculation on Card Settings Change
The system SHALL recalculate the dates of unpaid invoices that have no associated transactions when a credit account's payment day changes; invoices with transactions or marked paid are never modified.

#### Scenario: Changing a card's payment day with an empty unpaid invoice present
- GIVEN an unpaid invoice with no transactions in its period
- WHEN the associated credit account's `creditPaymentDay` is updated
- THEN that invoice's period is recalculated using the new unified invoice period logic

#### Scenario: Invoice with transactions is untouched
- GIVEN an unpaid invoice that already has transactions within its period
- WHEN a credit account's payment day changes
- THEN that invoice's dates are left unchanged (locked)
