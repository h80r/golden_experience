# Delta for Onboarding

## MODIFIED Requirements

### Requirement: Five-Step Guided Tour
The system SHALL present a 4-step, non-swipeable `PageView` tour (Welcome → Settings → Account → Completion) on the user's initial setup. (Previously: 5 steps including a Categories step between Account and Completion.)

#### Scenario: Progressing through the tour
- GIVEN the user is on the Welcome step
- WHEN they tap continue
- THEN they advance to the Settings step, then Account, then Completion; swiping directly does not change steps

### Requirement: Settings Step Configuration
The system SHALL, on the Settings step, capture monthly salary, max reserve usage percentage, and the salary payment date (mode and value), persisting all three via the existing `AppSettingsRepositoryImpl` methods.

#### Scenario: Configuring salary payment date during onboarding
- GIVEN the user is on the Settings step
- WHEN they select "Dia Específico" and pick day 5 via the inline calendar (or "Dia Útil" and pick a workday option)
- THEN `salaryPaymentMode` and `salaryPaymentValue` are persisted via `updateSalaryPaymentConfig`, alongside monthly salary and reserve percentage

### Requirement: Account Step Creates Default Account
The system SHALL mark the account created during onboarding as the default account (`isDefault = true`), and SHALL prompt for a credit payment day when the account is credit-enabled.

#### Scenario: Onboarding account becomes the default
- GIVEN the user completes the Account step
- WHEN the account is created
- THEN it is persisted with `isDefault = true`

#### Scenario: Credit payment day captured for a credit-enabled account
- GIVEN the user checks "Crédito" on the Account step
- WHEN they select a payment day via the inline calendar
- THEN the account is created with `creditPaymentDay` set to that value
