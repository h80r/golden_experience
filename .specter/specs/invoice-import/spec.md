# Invoice Import Specification

## Requirements

### Requirement: CSV Column Format Recognition
The system SHALL parse invoice CSV files with header `Cartão,Título,Valor,Parcelas,Data,Categoria`, extracting the card name, description, BRL-formatted value, installment notation, date, and category from each row.

#### Scenario: Well-formed row
- GIVEN a CSV row `Nubank,Merak Gastrobar,"R$ 280,00",1/1,12/07/2026,Alimentação`
- WHEN the row is parsed
- THEN it yields card `"Nubank"`, description `"Merak Gastrobar"`, value `280.00`, current installment `1`, total installments `1`, date July 12 2026, category `"Alimentação"`

#### Scenario: BRL value with thousands separator
- GIVEN a CSV row with value `"R$ 1.806,62"`
- WHEN the value is parsed
- THEN it evaluates to `1806.62`

### Requirement: Manual Card-to-Account Mapping
The system SHALL require every distinct `Cartão` value found in the CSV to be mapped by the user to an existing Account with `isCredit = true` and a non-null `creditPaymentDay` before import can proceed; no automatic or fuzzy matching by name is performed.

#### Scenario: Mapping step shown once per distinct card name
- GIVEN a CSV containing rows for "Nubank", "Santander", and "Mercado Pago"
- WHEN the mapping step is displayed
- THEN exactly three card names are shown, each requiring a selection from the user's existing credit-capable accounts

#### Scenario: No eligible account exists for a card
- GIVEN the user has no account with `isCredit = true` and `creditPaymentDay` set
- WHEN the mapping step is displayed
- THEN the user is prompted to create or configure such an account before the mapping can be completed

#### Scenario: Import blocked until all cards are mapped
- GIVEN at least one distinct card name has no account selected
- WHEN the user attempts to proceed to the review step
- THEN the app blocks progression and indicates which card names remain unmapped

### Requirement: Manual Category Mapping With Exact-Match Default
The system SHALL pre-select a Category for each distinct `Categoria` value in the CSV when its name exactly matches an existing category, and SHALL require manual selection when no exact match exists.

#### Scenario: Exact match pre-selected
- GIVEN the CSV contains category `"Alimentação"` and an existing category is also named `"Alimentação"`
- WHEN the mapping step is displayed
- THEN that category is pre-selected for the user, editable but not blocking

#### Scenario: No exact match
- GIVEN the CSV contains a category name with no existing category of the same name
- WHEN the mapping step is displayed
- THEN no category is pre-selected and the user must choose one before proceeding

### Requirement: Installment Rows Reuse Existing Installment Logic
The system SHALL create a multi-installment CSV row (`Parcelas` other than `1/1`) using the same repository logic as manual installment entry, expanding the current and remaining future installments, and SHALL apply only the current installment's value to the target account's `creditUsed`.

#### Scenario: Row with current installment 8 of 12
- GIVEN a parsed row with current installment `8`, total `12`, value `R$ 99,88`, mapped to account A
- WHEN the row is committed
- THEN a transaction dated at the start of account A's current billing cycle is created with `installmentNumber=8`, `installmentTotal=12`, and account A's `creditUsed` increases by `99.88` only (future installments 9–12 do not affect `creditUsed` at import time)

#### Scenario: Row with no installments
- GIVEN a parsed row with `Parcelas = 1/1`
- WHEN the row is committed
- THEN a single transaction is created via the plain create path and the full value is applied to `creditUsed`

### Requirement: Row Date Is Replaced By the Current Billing Cycle
The system SHALL ignore the `Data` value parsed from each CSV row when committing a transaction, and SHALL instead date every committed transaction (current installment) at the start of the mapped account's current billing cycle, calculated from today via the same cycle logic used to place future installments.

#### Scenario: CSV row date predates the cycle boundary
- GIVEN a parsed row whose `Data` falls one or more days before the mapped account's current billing-cycle start (as commonly happens because bill-aggregator exports stamp rows with the export-generation date rather than each installment's real billing date)
- WHEN the row is committed
- THEN the resulting transaction is dated at the account's current billing-cycle start, not the row's original date, and is included when querying transactions for the current cycle

### Requirement: Atomic Batch Commit
The system SHALL commit all included rows of an import as a single atomic operation: if any row fails to commit, no transactions from that import are persisted.

#### Scenario: A row fails mid-batch
- GIVEN 92 rows are queued for import and row 47 fails (e.g. an invalid account reference)
- WHEN the batch commit runs
- THEN none of the 92 rows' transactions are persisted and the account balances are left unchanged

### Requirement: Row Exclusion Before Commit
The system SHALL allow the user to exclude individual parsed rows from the import during the review step before committing.

#### Scenario: Excluding a row
- GIVEN the review step lists a row the user does not want to import
- WHEN the user excludes that row
- THEN it is omitted from the batch commit and from the displayed running total

### Requirement: No Duplicate Detection
The system SHALL import every included row as a new transaction without checking for duplicates against other rows in the same file or against existing transactions in the database.

#### Scenario: Two identical rows in the same file
- GIVEN the CSV contains two rows with identical card, description, value, and date
- WHEN both are included and the batch is committed
- THEN two separate transactions are created
