# Currency Input Specification

## Requirements

### Requirement: Right-to-Left Cents Entry
`NubankStyleCurrencyField` SHALL build a monetary value by treating every keystroke as a digit appended to a raw cents string, formatting the display as Brazilian currency, without requiring the user to type a decimal separator.

#### Scenario: Typing digits sequentially
- GIVEN an empty currency field
- WHEN the user types "1", then "0", then "0", then "5", then "6" in sequence
- THEN the displayed value progresses R$0,01 → R$0,10 → R$1,00 → R$10,05 → R$100,56

#### Scenario: Backspace removes the last digit
- GIVEN the field currently displays R$1,23
- WHEN the user presses backspace
- THEN the display becomes R$0,12

### Requirement: Required Field Validation
`NubankStyleCurrencyField` SHALL support a `required` flag producing a built-in "obrigatório" validation error when empty, in addition to an optional external validator.

#### Scenario: Required field left empty
- GIVEN a `NubankStyleCurrencyField` with `required = true`
- WHEN the form is validated with no digits entered
- THEN validation fails with an "obrigatório" message

### Requirement: Legacy Widget Is Dead Code
The codebase SHALL be understood to also contain `CurrencyTextField` (`currency_text_field.dart`), a comma-decimal input widget, which is no longer referenced by any screen or form — `NubankStyleCurrencyField` is the sole currency input in active use.

#### Scenario: Searching for CurrencyTextField usage
- GIVEN a repository-wide search for `CurrencyTextField(` construction sites
- WHEN excluding its own class definition and test file
- THEN zero call sites are found in `lib/`
