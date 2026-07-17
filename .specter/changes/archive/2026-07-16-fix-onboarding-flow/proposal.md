# Proposal: Fix Onboarding Flow

## Intent
User testing surfaced four problems in the guided onboarding flow: it includes a Categories step that implies customization the user can't actually do; it never asks for the salary payment date even though that value drives the core "how much can I spend" calculation; the account it creates isn't marked as the default account; and it never captures the credit card payment day for credit-enabled accounts, leaving billing-cycle data incomplete until the user manually edits the account later.

## Scope
- Remove the Categories step; onboarding becomes 4 steps (Welcome → Settings → Account → Completion). Default categories are still seeded, just not shown/editable during onboarding.
- Add salary payment date configuration (mode + value) to the Settings step, reusing the existing pattern from the main Settings screen.
- Mark the account created during onboarding as the default account (`isDefault = true`).
- Add a credit payment day picker to the Account step, shown only when the account is credit-enabled.
- Out of scope: any changes to the Settings screen or Accounts screen themselves (only reused, not modified); no new database columns or migrations; no automated widget tests (none currently exist for onboarding steps).

## Approach
Rewire the existing onboarding step widgets to reuse already-built widgets/repository methods (`SegmentedToggle`, `InlineCalendar`, `CustomDropdown`, `AppSettingsRepositoryImpl.updateSalaryPaymentConfig`) rather than building new UI, and adjust the `PageView` step count/index bookkeeping in `onboarding_screen.dart` after removing a step.
