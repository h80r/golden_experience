# Proposal: Import Invoice CSV

## Intent
The user receives monthly credit-card invoice exports as CSV files (from a bill-aggregator app) and currently has to enter each purchase into Golden Experience by hand, including re-deriving installment numbers. This change adds a guided import flow that reads a CSV file, resolves each row's card and category to the user's existing Accounts/Categories, and creates the transactions in bulk — reusing the existing installment logic so multi-installment purchases expand exactly as they would if entered manually.

## Scope
- Parse CSV files shaped like `docs/Faturas - Gastos.csv`: header `Cartão,Título,Valor,Parcelas,Data,Categoria`, BRL currency values (`"R$ 99,88"`), `dd/MM/yyyy` dates, and `current/total` installment notation (`8/12`).
- A one-time-per-file mapping step: every distinct `Cartão` value maps to an existing Account (`isCredit = true`, `creditPaymentDay` set); every distinct `Categoria` value maps to an existing Category, defaulting to an exact name match when one exists and otherwise requiring the user to choose.
- A review step listing all parsed/resolved rows with running totals, allowing individual rows to be excluded before commit.
- Batch commit: single-installment rows use the plain create path; multi-installment rows reuse `createInstallmentTransactions`, with only the current installment's value applied to the account's `creditUsed` — mirroring `dashboard_screen.dart`'s existing installment-save logic exactly. The whole batch commits atomically (all rows or none).
- Entry point wired into the Settings screen, alongside the existing backup/restore import action.
- **Out of scope**: duplicate detection against existing transactions or within the same file; CSV formats with different columns/layout; importing into debit-only accounts; editing a row's parsed values inline (only inclusion/exclusion) in v1; undo-after-import (deletion is manual, same as any other transaction).

## Approach
A new `InvoiceCsvParser` (data layer, mirroring the structure of `santander_notification_parser.dart`) turns file contents into `ParsedInvoiceRow` DTOs. A new Riverpod notifier drives a 3-step wizard (pick file → map Cartão/Categoria → review & confirm) built on `file_picker` (already a dependency) plus the new `csv` package. Commit reuses `ITransactionRepository.create` / `createInstallmentTransactions` and `IAccountRepository.updateCreditUsed` — no changes to existing repositories — wrapped in a single Drift transaction via `LocalDatabase.instance.transaction(...)`.
