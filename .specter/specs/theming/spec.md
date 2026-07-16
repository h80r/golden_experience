# Theming Specification

## Requirements

### Requirement: Dark-Mode-Only
The application SHALL ship a single dark theme (`AppTheme.darkTheme()`) with no light-theme variant; `themeMode` is fixed regardless of system preference.

#### Scenario: Device set to light mode
- GIVEN the OS-level theme preference is set to light
- WHEN the app launches
- THEN it still renders using the dark palette (Obsidian background `#0B1215`, gold primary `#FFC700`, cyan secondary `#22D3EE`)

### Requirement: Three-Font Typographic Roles
The design system SHALL assign distinct Google Fonts families to distinct roles: Prompt Bold for display/title text, Montserrat Alternates SemiBold for headlines, Karma Regular for body/labels.

#### Scenario: Large monetary value on the dashboard
- GIVEN the dashboard's main remaining-budget figure
- WHEN it is rendered
- THEN it uses a `displayLarge`-family style (Prompt Bold), not the body/label font

### Requirement: 8px Spacing Scale
The design system SHALL derive all spacing from an 8px base unit (`AppSpacing.xs=4` through `xxxl=40`) and a fixed border-radius scale (`radiusSmall=4` … `radiusCircle=999`).

#### Scenario: Bottom sheet chrome
- GIVEN any of the app's bottom sheets (expense, account, recurring expense)
- WHEN their top corners and header padding are inspected
- THEN they consistently use `AppSpacing.radiusLarge` and `AppSpacing.md`, matching the shared bottom-sheet chrome pattern
