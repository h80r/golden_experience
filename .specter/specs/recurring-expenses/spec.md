# Recurring Expenses Specification

## Requirements

### Requirement: Calendar-Day-Based Scheduling
The system SHALL trigger recurring expenses based on a plain calendar day-of-month (`chargeDay`), independent of any credit card billing cycle logic.

#### Scenario: Recurring expense with chargeDay 15
- GIVEN a recurring expense with `chargeDay = 15`
- WHEN the calendar day reaches the 15th of any month
- THEN a transaction is auto-created for that recurring expense on that date

### Requirement: Catch-Up Processing on App Start
The system SHALL process every calendar day strictly after `AppSettings.lastRecurringCheck` up to and including today, once per app cold start, catching up on any days the app was not opened.

#### Scenario: App not opened for 3 days
- GIVEN `lastRecurringCheck` is 3 days in the past
- WHEN the app starts
- THEN all recurring expenses matching any of the 3 missed days (plus today) are processed, and `lastRecurringCheck` is updated to today

#### Scenario: Already processed today
- GIVEN `lastRecurringCheck` equals today
- WHEN the app starts again
- THEN no transactions are created and processing is a no-op

### Requirement: Month-End Day-31 Handling
The system SHALL also fire `chargeDay = 31` recurring expenses on the last calendar day of any month with fewer than 31 days.

#### Scenario: February with 28 days
- GIVEN a recurring expense with `chargeDay = 31`
- WHEN processing reaches February 28th (non-leap year)
- THEN the expense is charged on February 28th, since it is that month's last day

### Requirement: Auto-Created Transaction Metadata
The system SHALL prefix auto-created recurring transactions' descriptions with "[Recorrente] " and set notes to "[Processada automaticamente]".

#### Scenario: Recurring expense fires
- GIVEN a recurring expense described "Netflix"
- WHEN it is auto-processed
- THEN the created transaction has description "[Recorrente] Netflix" and notes "[Processada automaticamente]"

### Requirement: Transaction Type by Account Capability
The system SHALL default recurring-expense transactions to `transactionType = 'credit'`, except for debit-only accounts (`isDebit && !isCredit`), which use `'debit'`.

#### Scenario: Recurring expense on a debit-only account
- GIVEN the recurring expense's account has `isDebit = true` and `isCredit = false`
- WHEN the transaction is auto-created
- THEN `transactionType = 'debit'` and the account's `balance` is decreased

### Requirement: Immediate Transaction on Create/Edit if Charge Day Already Passed
The system SHALL create an immediate transaction when a recurring expense is created or edited and its charge day has already occurred within the current billing period (credit: current billing cycle; debit: current calendar month).

#### Scenario: Credit account, charge day already passed in current cycle
- GIVEN a credit account's current billing cycle contains today, and the recurring expense's charge day falls within that cycle and is before today
- WHEN the recurring expense is created
- THEN a transaction is immediately created dated on the charge day within the current cycle

#### Scenario: Credit account, charge day in the future within the cycle
- GIVEN the charge day falls within the current cycle but has not yet occurred
- WHEN the recurring expense is created
- THEN no immediate transaction is created (it will be picked up by the next catch-up processing)

#### Scenario: Debit account, charge day already passed this month
- GIVEN a debit account and `chargeDay <= today's day-of-month`
- WHEN the recurring expense is created
- THEN a transaction is immediately created dated on the charge day of the current month
