# Backup and Restore Specification

## Requirements

### Requirement: Versioned JSON Export
The system SHALL export `transactions`, `accounts`, `categories`, `recurringExpenses`, and `appSettings` to a single JSON file tagged with `"version": "1.0"`.

#### Scenario: Exporting a backup
- GIVEN the user triggers a backup export
- WHEN the file is generated
- THEN it contains a `version` field equal to "1.0" and the five listed table dumps

### Requirement: User-Chosen Export Destination
The system SHALL let the user pick the backup file's destination via the native file picker rather than a fixed directory.

#### Scenario: User cancels the file picker
- GIVEN the user starts an export and the save-file dialog opens
- WHEN they cancel the dialog
- THEN no file is written and no error is shown

### Requirement: FK-Safe Import Order
The system SHALL wipe and reinsert all five tables in foreign-key-safe order on import: categories, accounts, transactions, recurringExpenses, appSettings.

#### Scenario: Importing a valid backup
- GIVEN a valid backup file with `version = "1.0"`
- WHEN the user confirms import
- THEN all five tables are cleared and repopulated in that order without foreign key violations

### Requirement: Version Validation
The system SHALL reject import of a backup file whose `version` is not "1.0".

#### Scenario: Importing an unsupported version
- GIVEN a backup file with `version = "2.0"` or missing entirely
- WHEN the user attempts to import it
- THEN the import throws and no data is modified

### Requirement: Backward-Compatible Account Import
The system SHALL accept legacy pre-dual-type account records (single `type` enum + `initialBalance`) during import, translating them to the current `isDebit`/`isCredit`/`balance` shape.

#### Scenario: Importing a very old backup
- GIVEN a backup account record has `type: "debit"` and `initialBalance` instead of `isDebit`/`balance`
- WHEN it is imported
- THEN it is translated to `isDebit=true, isCredit=false, balance=<initialBalance>`

### Requirement: Known Gap — Installment and Invoice Data Not Backed Up
The backup format SHALL be understood to currently omit the `invoices` table entirely and the transaction fields `transactionType`, `installmentNumber`, `installmentTotal`, `installmentGroupId`.

#### Scenario: Restoring a backup with installment transactions
- GIVEN the original data included installment transactions and paid invoices
- WHEN a backup is exported and then re-imported
- THEN the restored transactions lose their installment grouping/numbers and all reset to the default `transactionType` ('credit'), and no invoice rows are restored
