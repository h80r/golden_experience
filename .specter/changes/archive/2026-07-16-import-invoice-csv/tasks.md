# Tasks

## 1. CSV Parsing Foundation
- [x] 1.1 Add `csv` package to `pubspec.yaml` and run `flutter pub get`
- [x] 1.2 Create `ParsedInvoiceRow` and `InvoiceCsvParseResult` DTOs in `lib/domain/models/`
- [x] 1.3 Implement `InvoiceCsvParser` in `lib/data/parsers/invoice_csv_parser.dart` (BRL value parsing, `dd/MM/yyyy` date parsing, `current/total` installment parsing, per-row error collection)
- [x] 1.4 Unit tests for `InvoiceCsvParser` covering: well-formed rows, thousands-separator values, single-installment rows (`1/1`), multi-installment rows, malformed rows (bad date/value/installments), using `docs/Faturas - Gastos.csv` as a fixture

## 2. Import Wizard State
- [x] 2.1 Create `InvoiceImportState` and `InvoiceImportNotifier` (`@riverpod`) in `lib/presentation/state/invoice_import_notifier.dart` with steps `pickFile → mapping → review → importing → done`
- [x] 2.2 Implement distinct card-name and category-name extraction from parsed rows, with exact-name pre-fill for category mapping against `ICategoryRepository.getAll()`
- [x] 2.3 Implement mapping validation (all distinct cards mapped to credit-capable accounts, all distinct categories mapped) gating progression to `review`

## 3. Wizard UI
- [x] 3.1 Create `lib/presentation/screens/invoice_import_screen.dart` with step-based rendering
- [x] 3.2 Build the file-pick step using `FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv'])`, matching the pattern in `settings_screen.dart`'s backup import
- [x] 3.3 Build the mapping step: list of distinct card names and category names, each with a `CustomDropdown` selector; surface a prompt to create/configure an account when no eligible credit account exists
- [x] 3.4 Build the review step: scrollable row list with per-row exclude checkbox, running total of included rows, confirm button
- [x] 3.5 Wire the "Importar Fatura CSV" entry point into `settings_screen.dart` alongside the existing backup/restore import action

## 4. Batch Commit
- [x] 4.1 Implement `InvoiceImportNotifier.commit()`: loop over included rows, route single-installment rows through `ITransactionRepository.create` and multi-installment rows through `createInstallmentTransactions`, apply only the current installment's value to `IAccountRepository.updateCreditUsed` in both cases, all wrapped in `LocalDatabase.instance.transaction(...)`
- [x] 4.2 Surface commit success/failure in the UI (snackbar on success with count imported; error state with rollback message on failure)

## 5. Verification
- [x] 5.1 Widget tests for the mapping step (blocks progression until fully mapped) and review step (exclude toggling updates the total)
- [x] 5.2 `flutter analyze` and `flutter test` pass
- [x] 5.3 Manual run: import `docs/Faturas - Gastos.csv` end-to-end against real accounts/categories, verify created transactions, installment expansion, and `creditUsed` updates on the Accounts and Dashboard screens
- [x] 5.4 Fix: invoice CSV rows' dates are replaced with the account's current billing-cycle start (via `calculateCurrentBillingCycleFromPaymentDay`) instead of the raw CSV date, since bill-aggregator exports repeat one date across unrelated rows/installments and don't reflect each row's actual billing date — found during 5.3's manual run (rows landing a day before the cycle boundary were silently excluded, undercounting the invoice total)
- [x] 5.5 Add `ITransactionRepository.deleteAll()` and an "Excluir Todas as Transações" button in `settings_screen.dart` (confirmation dialog, zeroes `creditUsed` on credit accounts) — needed to re-test 5.3/5.4 against a clean slate
