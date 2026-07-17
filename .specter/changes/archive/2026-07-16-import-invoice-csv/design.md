# Design: Import Invoice CSV

## New DTOs (domain layer)

`lib/domain/models/parsed_invoice_row.dart`
```dart
class ParsedInvoiceRow {
  final String cardName;        // raw "Cartão" value, e.g. "Nubank"
  final String description;     // raw "Título" value
  final double value;           // parsed from "R$ 99,88" -> 99.88
  final int currentInstallment; // from "8/12" -> 8
  final int totalInstallments;  // from "8/12" -> 12
  final DateTime date;          // parsed from dd/MM/yyyy
  final String categoryName;    // raw "Categoria" value
}
```
Plain immutable class (matches `TransactionData`'s style in the notification-capture feature), not a Freezed/Drift model — it never touches the database directly.

## Parser (data layer)

`lib/data/parsers/invoice_csv_parser.dart` — a plain class (no interface; only one CSV shape exists, so `INotificationParser`-style polymorphism is unwarranted):
```dart
class InvoiceCsvParser {
  List<ParsedInvoiceRow> parse(String csvContent);
}
```
- Uses the new `csv` package to split rows (handles quoted fields like `"R$ 99,88"` correctly, which naive `.split(',')` would not, since commas can appear before/after the quoted value on the same line).
- Value parsing: strip `"R$ "` prefix, remove `.` (thousands), replace `,` with `.` (decimal) — same transformation as the private `_parseValue` in `santander_notification_parser.dart`, reimplemented here (not extracted into a shared util, since it's a single 3-line transform and the two call sites parse structurally different input strings).
- Date parsing: strict `dd/MM/yyyy` via manual split (avoids locale-dependent `DateFormat` ambiguity).
- Installment parsing: split `Parcelas` on `/` into ints.
- A row that fails to parse (malformed value/date/installments) is collected into a separate `errors` list surfaced in the UI rather than throwing and aborting the whole file; the parser method signature returns both:
```dart
class InvoiceCsvParseResult {
  final List<ParsedInvoiceRow> rows;
  final List<String> errors; // human-readable, includes line number
}
```

## Wizard state (presentation layer)

New Riverpod notifier `lib/presentation/state/invoice_import_notifier.dart` (`@riverpod`, matching the existing `BackupNotifier` / `expenseFormProvider` conventions):

```dart
enum InvoiceImportStep { pickFile, mapping, review, importing, done }

class InvoiceImportState {
  final InvoiceImportStep step;
  final List<ParsedInvoiceRow> rows;
  final Map<String, int> cardToAccountId;      // distinct cardName -> Account.id
  final Map<String, int> categoryToCategoryId; // distinct categoryName -> Category.id
  final Set<int> excludedRowIndexes;
  final List<String> parseErrors;
  final String? commitError;
}
```

State transitions:
1. `pickFile` — user picks a `.csv` via `file_picker` (`FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv'])`, same call shape as `settings_screen.dart`'s backup import), file is read and parsed immediately on selection.
2. `mapping` — notifier computes distinct card/category names from `rows`, pre-fills `categoryToCategoryId` for exact name matches against `ICategoryRepository.getAll()`, leaves `cardToAccountId` empty (no auto-match by design decision). Screen blocks "Next" until every distinct card name has an entry in `cardToAccountId` and every distinct category name has an entry in `categoryToCategoryId`.
3. `review` — rows rendered with resolved account/category names, a running total, and a per-row exclude toggle (`excludedRowIndexes`).
4. `importing` → `done` — see commit flow below.

## Commit flow

New method on the notifier, `commit()`, executes inside a single Drift transaction for atomicity (Requirement: Atomic Batch Commit):

```dart
await LocalDatabase.instance.transaction(() async {
  for (final row in includedRows) {
    final accountId = cardToAccountId[row.cardName]!;
    final categoryId = categoryToCategoryId[row.categoryName]!;

    final account = await accountRepository.getById(accountId);
    final adjustedDate = calculateCurrentBillingCycleFromPaymentDay(
      account!.creditPaymentDay!,
    ).start;

    if (row.totalInstallments > 1) {
      await transactionRepository.createInstallmentTransactions(
        transaction: TransactionModelCompanion.insert(
          value: row.value,
          description: row.description,
          date: adjustedDate,
          accountId: accountId,
          categoryId: categoryId,
          transactionType: const Value('credit'),
        ),
        currentInstallment: row.currentInstallment,
        totalInstallments: row.totalInstallments,
        accountId: accountId,
      );
    } else {
      await transactionRepository.create(TransactionModelCompanion.insert(
        value: row.value,
        description: row.description,
        date: adjustedDate,
        accountId: accountId,
        categoryId: categoryId,
        transactionType: const Value('credit'),
      ));
    }

    final updatedAccount = await accountRepository.getById(accountId);
    await accountRepository.updateCreditUsed(accountId, updatedAccount!.creditUsed + row.value);
  }
});
```

This is a direct copy of the logic already in `dashboard_screen.dart:455-483`, generalized to loop over rows instead of a single form submission — no changes to `TransactionRepositoryImpl` or `AccountRepositoryImpl` are needed for the commit path itself. Wrapping in `LocalDatabase.instance.transaction` is new: the existing single-transaction save path doesn't need atomicity across multiple writes the way a 92-row batch does, since a partial single-row failure today just fails one form submission, not 92.

### Date adjustment (discovered during manual verification)

`row.date` from the CSV is **not** the current installment's actual billing date — real-world bill-aggregator exports repeat the same date value across dozens of unrelated rows and installment numbers within one export batch (it reflects when the export was generated, not per-row billing dates). Using it as-is caused rows whose date landed even one day before the account's cycle boundary to be silently excluded from the invoice period the user was importing for, undercounting the total by as much as ~40% in testing.

Since every import is for the current invoice (never historical, per the proposal's scope), each row's date is replaced with `calculateCurrentBillingCycleFromPaymentDay(account.creditPaymentDay!).start` — the same billing-cycle utility `createInstallmentTransactions` already uses internally to place future installments, now also applied to the current installment. This guarantees every non-excluded row lands in the cycle being imported for, regardless of what date the CSV happens to carry.

### Deleting all transactions (added during manual verification)

Iterating on the importer requires re-testing against a clean slate, and there was no in-app way to clear previously-imported transactions. `ITransactionRepository.deleteAll()` was added (wipes every transaction, returns the count deleted) and exposed in `settings_screen.dart` as "Excluir Todas as Transações", directly below the CSV import entry point, gated by a confirmation `AlertDialog` since it's destructive and irreversible. On confirm it also zeroes `creditUsed` on every credit account, leaving the app in a consistent state for a clean re-import. This is a debugging/maintenance affordance, not a product requirement from the original proposal — it earns its place here because it was necessary to verify the date-adjustment fix above.

## UI

- Entry point: new "Importar Fatura CSV" action in `lib/presentation/screens/settings_screen.dart`, alongside the existing backup/restore import button, following the same `FilePicker` → confirmation-dialog → repository-call shape already there.
- New screen `lib/presentation/screens/invoice_import_screen.dart` (pushed via `Navigator`, not a bottom sheet, since it's a multi-step flow) — renders the current `InvoiceImportStep` via a simple `switch`, no need for a generalized wizard widget given there's only one flow.
- Mapping step reuses `CustomDropdown` (existing design-system widget) for both card→account and category→category selection.
- Review step is a scrollable list of rows with a checkbox per row and a header showing the running total of included rows.

## Alternatives rejected

- **Extending `INotificationParser`**: rejected — that interface is shaped around single-notification-event parsing (`canParse`/`parse` on one `NotificationEvent`), not batch file parsing; forcing CSV import through it would add indirection with no reuse benefit since there's exactly one CSV format.
- **Extracting a shared `parseBrlValue` util**: considered, but the notification parser's version is private and tied to different surrounding regex context; duplicating a 3-line transform is cheaper than introducing a new shared utility module for two call sites.
- **Auto-matching account/category by fuzzy name**: rejected per explicit user decision — manual mapping avoids silently importing into the wrong account.
