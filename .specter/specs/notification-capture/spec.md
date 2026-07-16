# Notification-Based Transaction Capture Specification

## Requirements

### Requirement: Parser Registry Pattern
The system SHALL route incoming Android notifications to a bank-specific parser looked up by package name in a registry, allowing new banks to be added without modifying existing parser code.

#### Scenario: Notification from a registered bank app
- GIVEN a notification arrives from package `com.santander.app`
- WHEN the notification service processes it
- THEN it is routed to `SantanderNotificationParser`

#### Scenario: Notification from an unregistered app
- GIVEN a notification arrives from a package with no registered parser
- WHEN the notification service processes it
- THEN it is ignored (no parsing attempted)

### Requirement: Santander Purchase Notification Parsing
The system SHALL extract transaction value, date/time, and merchant name from Santander purchase-approval notifications matching the expected text pattern.

#### Scenario: Well-formed Santander notification
- GIVEN a notification text containing "Compra aprovada", "cartão final", a "R$" value, and "aprovada"
- WHEN `SantanderNotificationParser.parse` runs
- THEN it returns a `TransactionData` with the extracted value, date, and merchant

#### Scenario: Non-purchase Santander notification
- GIVEN a notification text that does not contain all of "Compra", "cartão final", "R$", "aprovada"
- WHEN `canParse` is checked
- THEN it returns false and the notification is not parsed

### Requirement: Local Notification With Action Button
The system SHALL display a local system notification with an "Adicionar Transação" action button whenever a bank notification is successfully parsed.

#### Scenario: Successful parse
- GIVEN a bank notification was successfully parsed into `TransactionData`
- WHEN the result is handled
- THEN a local notification is shown with an "Adicionar Transação" action

### Requirement: Known Gap — Tap-to-Create Is Incomplete
The action button's tap handler SHALL be understood to be stubbed/incomplete in the current codebase; tapping "Adicionar Transação" does not yet open a pre-filled transaction form.

#### Scenario: User taps the action button
- GIVEN a captured-transaction notification is showing
- WHEN the user taps "Adicionar Transação"
- THEN today's behavior does not reliably open `ExpenseDetailsBottomSheet` pre-filled with the parsed data — this wiring is incomplete

### Requirement: Android-Only
The capability SHALL be understood to function only on Android, since iOS does not permit cross-app notification access.
