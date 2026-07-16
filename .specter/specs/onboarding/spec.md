# Onboarding Specification

## Requirements

### Requirement: Five-Step Guided Tour
The system SHALL present a 5-step, non-swipeable `PageView` tour (Welcome → Settings → Account → Categories → Completion) on the user's initial setup.

#### Scenario: Progressing through the tour
- GIVEN the user is on the Welcome step
- WHEN they tap continue
- THEN they advance to the Settings step, and so on through Account, Categories, and Completion; swiping directly does not change steps

### Requirement: Gated by hasCompletedOnboarding
The system SHALL show the onboarding screen unless `AppSettings.hasCompletedOnboarding = true`, in which case the main screen is shown instead.

#### Scenario: First launch
- GIVEN `hasCompletedOnboarding = false`
- WHEN the app starts
- THEN the onboarding screen is displayed

#### Scenario: Returning user
- GIVEN `hasCompletedOnboarding = true`
- WHEN the app starts
- THEN the main screen is displayed directly, skipping onboarding

### Requirement: Reactive Screen Swap on Completion
The system SHALL flip `hasCompletedOnboarding` to true on completion and rely on the reactive settings stream to swap to the main screen, without an explicit navigation call.

#### Scenario: Completing the tour
- GIVEN the user reaches the Completion step and confirms
- WHEN `hasCompletedOnboarding` is persisted as true
- THEN the app automatically transitions to the main screen via the settings stream, with no explicit `Navigator` push/replace call
