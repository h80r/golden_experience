# Verification: import-invoice-csv

## Verdict
PASS

## CRITICAL
(none)

## WARNING
- [completeness] `proposal.md` says "no changes to existing repositories" for the commit path, but `ITransactionRepository.deleteAll()` was added to the interface during manual verification (needed to clear a previous import attempt before re-testing). This is a legitimate, user-approved addition (a debugging/maintenance affordance, not a product requirement) but the proposal document itself was not updated to reflect it — `design.md` was updated and documents the rationale.
- [completeness] The date-adjustment fix (billing-cycle start instead of the raw CSV date) and the `deleteAll()` feature were both discovered/added after the original `tasks.md` group 5 was written, and were retrofitted into tasks 5.4/5.5 rather than planned upfront. No functional gap remains — both are implemented, tested manually end-to-end by the user, and documented in `design.md` — but the paper trail is out of the normal proposal → design → tasks sequence.

## Fixed during this verification pass
- [correctness] The mapping step's eligible-account filter (`_CardAccountMapping` in `invoice_import_screen.dart`) only checked `isCredit`, not `creditPaymentDay != null`, contradicting both the spec ("Manual Card-to-Account Mapping" requires both) and `commit()`'s own `accountBeforeInsert!.creditPaymentDay!` null assertion. A credit account without a payment day configured would have passed the mapping UI and then crashed the commit. Fixed: filter now requires `isCredit && creditPaymentDay != null`.
- [coherence] The spec delta's "Row with current installment 8 of 12" scenario still said the transaction is "dated at the row's date" — stale since the billing-cycle date-adjustment fix landed. Updated to say "dated at the start of account A's current billing cycle", and added a new requirement ("Row Date Is Replaced By the Current Billing Cycle") documenting the fix with its own scenario, so the merged living spec matches actual behavior.

## SUGGESTION
- [correctness] `commit()` calls `accountRepository.getById(accountId)` twice per row (once for the date calculation, once after insert for `creditUsed`) instead of reusing the first read and adding `row.value` locally. Functionally correct since both reads happen inside the same Drift transaction before any conflicting write, but it's an avoidable round trip per row (up to 92 in the tested fixture).
