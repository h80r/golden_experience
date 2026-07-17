# Tasks

## 1. Remove Categories step
- [x] 1.1 Delete `lib/presentation/widgets/onboarding/categories_step.dart`
- [x] 1.2 In `onboarding_screen.dart`, remove the `CategoriesStep` import and instantiation, change the step bound from `_currentStep < 4` to `< 3`, the progress dots from `List.generate(5, ...)` to `4`, and `'Passo ${_currentStep + 1} de 5'` to `'de 4'`
- [x] 1.3 In `completion_step.dart`, remove the "Categorias" bullet from the configured-items recap

## 2. Add salary payment date to Settings step
- [x] 2.1 In `settings_step.dart`, add state for `salaryPaymentMode`/`salaryPaymentValue` (mirroring `settings_screen.dart`'s `_salaryPaymentMode`/`_calendarDay`/`_workdayOption` state) and render the `SegmentedToggle` + `InlineCalendar`/`CustomDropdown` section below the reserve slider, reusing the exact widget pattern from `settings_screen.dart::_buildSalaryPaymentSection`
- [x] 2.2 In `_saveSettings`, call `AppSettingsRepositoryImpl.updateSalaryPaymentConfig(mode, value)` alongside the existing `updateMonthlySalary`/`updateMaxReserveUsagePercentage` calls

## 3. Mark onboarding account as default
- [x] 3.1 In `account_step.dart::_createAccount`, add `isDefault: Value(true)` to the `AccountModelCompanion.insert(...)` call

## 4. Add credit payment day to Account step
- [x] 4.1 In `account_step.dart`, add `int? _creditPaymentDay` state and show an `InlineCalendar` (default day 1) when `_isCredit` is true, matching `account_form_bottom_sheet.dart`'s pattern
- [x] 4.2 Pass `creditPaymentDay: Value(_creditPaymentDay)` into the `AccountModelCompanion.insert(...)` call

## 5. Verify
- [x] 5.1 Run `flutter analyze` and fix any issues
- [x] 5.2 Manually walk through onboarding end-to-end (fresh state): confirm 4 steps, salary payment date persists, created account has `isDefault = true`, and credit accounts get a `creditPaymentDay`
