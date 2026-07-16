# Accounts Specification

## Requirements

### Requirement: Dual-Type Accounts
The system SHALL allow an account to be debit-enabled, credit-enabled, or both simultaneously, via independent `isDebit`/`isCredit` boolean flags.

#### Scenario: Account created as both debit and credit
- GIVEN a user creates a new account
- WHEN they check both "Débito" and "Crédito"
- THEN the account is persisted with `isDebit = true` and `isCredit = true`, tracking both a `balance` (debit) and `creditLimit`/`creditUsed` (credit)

#### Scenario: At least one type is required
- GIVEN a user is creating or editing an account
- WHEN neither "Débito" nor "Crédito" is checked
- THEN the form shows an inline error and does not save

### Requirement: Credit Payment Day Drives Billing Cycle
The system SHALL store only a `creditPaymentDay` (1–31, nullable) for credit accounts; the closing day MUST always be derived as `paymentDay - 7` and is never persisted as a separate column.

#### Scenario: Setting the payment day
- GIVEN a credit-enabled account
- WHEN the user selects a payment day of 15 via the inline calendar
- THEN `creditPaymentDay = 15` is saved, and the closing day (8) is computed on demand, never written to the database

#### Scenario: Editing an existing credit account's payment day
- GIVEN an existing credit account with unpaid invoices
- WHEN the user changes `creditPaymentDay`
- THEN the account update triggers recalculation of unpaid, transaction-less invoice periods to match the new billing cycle

### Requirement: Single Default Account
The system SHALL allow at most one account to be marked as the default at any time.

#### Scenario: Marking a new default clears the previous one
- GIVEN account A is currently the default
- WHEN the user marks account B as default
- THEN this happens atomically in a single database transaction: A's `isDefault` becomes `false` and B's becomes `true`

#### Scenario: Default account pre-fills transaction creation
- GIVEN an account is marked as default
- WHEN the user opens the transaction creation bottom sheet
- THEN that account is pre-selected in the account dropdown

### Requirement: Exclude Account From Reserve
The system SHALL allow a debit account to be excluded from the dashboard's reserve calculation via an `excludeFromReserve` flag.

#### Scenario: Excluded account balance is not counted
- GIVEN a debit account has `excludeFromReserve = true`
- WHEN the dashboard computes the reserve balance
- THEN that account's balance is omitted from the sum, regardless of its actual balance value

### Requirement: Account Deletion Guard
The system SHALL prevent deletion of an account that has associated transactions.

#### Scenario: Deleting an account with transaction history
- GIVEN an account has at least one transaction referencing it
- WHEN the user attempts to delete that account
- THEN the repository reports the account has transactions and the deletion is blocked
