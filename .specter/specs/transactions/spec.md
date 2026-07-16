# Transactions Specification

## Requirements

### Requirement: Transaction Type Independent of Account Type
The system SHALL store a `transactionType` ('debit' or 'credit') on each transaction, independent of the owning account's type flags, so dual-type accounts can log both kinds of transactions.

#### Scenario: Debit transaction on a dual-type account
- GIVEN an account with both `isDebit = true` and `isCredit = true`
- WHEN a transaction is created with `transactionType = 'debit'`
- THEN the account's `balance` is decreased by the transaction value, and `creditUsed` is left unchanged

#### Scenario: Credit transaction on a dual-type account
- GIVEN an account with both `isDebit = true` and `isCredit = true`
- WHEN a transaction is created with `transactionType = 'credit'`
- THEN the account's `creditUsed` is increased by the transaction value, and `balance` is left unchanged

### Requirement: Account Balance Consistency on Edit
The system SHALL keep account balance/creditUsed consistent when a transaction is edited, whether or not its account or type changed.

#### Scenario: Editing value only (same account, same type)
- GIVEN an existing transaction of value R$100 with `transactionType = 'credit'`
- WHEN the user edits it to R$150 without changing account or type
- THEN only the R$50 difference is applied to the account's `creditUsed`

#### Scenario: Editing account or type
- GIVEN an existing transaction on account A with `transactionType = 'debit'`
- WHEN the user changes it to account B with `transactionType = 'credit'`
- THEN the original effect is fully reversed on account A's `balance`, and the new effect is fully applied on account B's `creditUsed`

### Requirement: Account Balance Reversal on Delete
The system SHALL reverse a transaction's effect on its account when the transaction is deleted.

#### Scenario: Deleting a debit transaction
- GIVEN a transaction with `transactionType = 'debit'` and value R$50
- WHEN the transaction is deleted
- THEN the account's `balance` is increased by R$50

#### Scenario: Deleting a credit transaction
- GIVEN a transaction with `transactionType = 'credit'` and value R$50
- WHEN the transaction is deleted
- THEN the account's `creditUsed` is decreased by R$50

### Requirement: Installment Transactions
The system SHALL support splitting a transaction into installments, grouped by a shared `installmentGroupId`, restricted to credit accounts with a `creditPaymentDay` set.

#### Scenario: Creating an installment transaction
- GIVEN a credit account with `creditPaymentDay` set
- WHEN the user creates a transaction with current installment 8 of 12
- THEN a transaction dated today is created with `installmentNumber=8`, `installmentTotal=12`, description suffixed "8/12", and a new `installmentGroupId` shared by all related installments

#### Scenario: Future installments are dated to future billing cycles
- GIVEN installment 8/12 is being created today
- WHEN installments 9 through 12 are generated
- THEN each future installment's date is set to the first day of its respective future billing cycle (one cycle further ahead per installment), computed from the account's closing date

#### Scenario: Installment creation rejected for non-credit accounts
- GIVEN an account without `isCredit = true` or without a `creditPaymentDay`
- WHEN the user attempts to create an installment transaction
- THEN the operation throws and no transactions are created

### Requirement: Value Must Be Positive
The system SHALL require a transaction value greater than zero and a non-empty description before saving.

#### Scenario: Saving without a value
- GIVEN the transaction form has no value entered
- WHEN the user attempts to save
- THEN validation fails and the transaction is not persisted
