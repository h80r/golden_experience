# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Golden Experience** is a Flutter-based personal finance management app focused on answering: *"How much can I still spend this month?"*

- **Language:** Dart 3.9.2
- **Framework:** Flutter 3.x
- **State Management:** Riverpod 3.0.3 with code generation
- **Database:** Drift 2.23.0 (SQLite wrapper with reactive queries)
- **Architecture:** Clean Architecture (presentation → domain → data)

## Common Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run code generation (for Drift, Freezed, Riverpod)
dart run build_runner build

# Run code generation with cleanup
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run on specific device
flutter run -d <device-id>
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

## Architecture

The codebase follows **Clean Architecture** with three main layers:

### 1. Presentation Layer (`lib/presentation/`)
- **Screens:** Full-page views with bottom navigation (Dashboard, RecurringExpenses, Accounts)
- **Widgets:** Reusable components organized by category:
  - `buttons/` - PrimaryButton, SecondaryButton
  - `calculator/` - CalculatorOverlay
  - `expense/` - ExpenseDetailsBottomSheet
  - `inputs/` - CustomTextField, CustomDropdown
- **Theme:** Design system in `theme/` (AppColors, AppTypography, AppSpacing)
- **State Management:** Riverpod providers for reactive UI

### 2. Domain Layer (`lib/domain/`)
- **Repositories (Interfaces):** Abstract contracts for data operations
  - `i_transaction_repository.dart`
  - `i_account_repository.dart`
  - `i_recurring_expense_repository.dart`
  - `i_category_repository.dart`
  - `i_app_settings_repository.dart`
- **Future:** Use cases will be added here for business logic orchestration

### 3. Data Layer (`lib/data/`)
- **Database Tables:** Drift table definitions with generated models (`.g.dart` files)
  - Transactions, Accounts, RecurringExpenses, Categories, AppSettings tables
  - Located in `lib/data/database/`
- **Repositories (Implementations):** Concrete implementations of domain interfaces
- **Datasources:** `local_database.dart` - Singleton Drift database instance
- **Providers:** `repository_providers.dart` - Riverpod providers exposing repositories

### Key Architecture Patterns

**Dependency Rule:** Presentation → Domain ← Data (domain has no dependencies on outer layers)

**Database Initialization:**
- Drift database must be initialized before use via `LocalDatabase.initialize()`
- Access singleton instance via `LocalDatabase.instance`
- All table definitions registered in `@DriftDatabase` annotation in `local_database.dart`

**Repository Pattern:**
- Domain defines interfaces (contracts)
- Data provides concrete implementations using Drift queries
- Riverpod providers inject implementations

**Reactive Data Flow:**
- Repositories expose Stream methods (e.g., `watchAll()`, `watchCurrentMonth()`)
- UI uses StreamProviders for automatic updates
- Drift's `.watch()` methods automatically propagate database changes to UI

## Project Structure

```
lib/
├── data/
│   ├── datasources/
│   │   └── local_database.dart      # Drift database singleton
│   ├── database/
│   │   └── *_table.dart             # Drift table definitions
│   ├── providers/
│   │   └── repository_providers.dart # Riverpod providers
│   └── repositories/
│       └── *_repository_impl.dart   # Repository implementations
├── domain/
│   └── repositories/
│       └── i_*_repository.dart      # Repository interfaces
├── presentation/
│   ├── screens/
│   │   ├── main_screen.dart         # Shell with BottomNavigationBar
│   │   ├── dashboard_screen.dart
│   │   ├── recurring_expenses_screen.dart
│   │   └── accounts_screen.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_spacing.dart
│   └── widgets/
│       ├── buttons/
│       ├── calculator/
│       ├── expense/
│       └── inputs/
└── main.dart                        # Entry point with ProviderScope

test/
├── data/
│   ├── models/                      # Model tests
│   └── repositories/                # Repository integration tests
└── presentation/
    ├── screens/                     # Screen widget tests
    └── widgets/                     # Component widget tests
```

## Testing Conventions

### Test File Organization
- Mirror the `lib/` structure in `test/`
- Test files end with `_test.dart`

### Database Testing Pattern
All repository tests must:
1. Initialize Flutter bindings: `TestWidgetsFlutterBinding.ensureInitialized()`
2. Mock path_provider method channel for Drift (see example below)
3. Initialize LocalDatabase in `setUpAll()`
4. Close database in `tearDownAll()`

Example:
```dart
setUpAll(() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    return '.';
  });
  await LocalDatabase.initialize();
});

tearDownAll(() async {
  await LocalDatabase.closeDatabase();
});
```

## Code Generation

This project uses code generation for:
- **Drift database:** Table definitions generate database code and data classes (`*.g.dart` files)
- **Freezed:** Immutable state classes with `@freezed` annotation generate `.freezed.dart` files
- **Riverpod:** Providers with `@riverpod` annotation generate `.g.dart` provider files

After modifying tables, state classes, or providers, always run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated files (`.g.dart`, `.freezed.dart`) are automatically created and should NOT be edited manually.

## Git Workflow

### Branch Naming
- `feature/` - New features (e.g., `feature/calculator-ui`)
- `chore/` - Configuration/setup tasks (e.g., `chore/database-models`)
- `refactor/` - Code improvements without functionality changes
- `fix/` - Bug fixes

### Main Branch
- Primary branch: `develop`
- Create feature branches from `develop`
- Merge back to `develop` when complete

### Commit Conventions
Commits use emoji prefixes:
- 📦🗜️ for feature/chore completions (e.g., "📦🗜️ Implement calculator UI with design system")

## Important Files

- **docs/PLAN.md:** Complete implementation roadmap with 21 tasks across 4 phases
- **docs/STATUS.md:** Auto-managed current task tracker
- **docs/specifications/:** Product requirements and technical specifications
- **pubspec.yaml:** Dependencies for Drift, Freezed, and Riverpod code generation
- **build.yaml:** Configuration for code generators

## Development Notes

### Design System
All UI components should use the centralized design system:
- Colors: `app_colors.dart`
- Typography: `app_typography.dart` (uses Google Fonts)
- Spacing: `app_spacing.dart`

### State Management
- Use Riverpod providers with `@riverpod` annotation for dependency injection
- Use Freezed with `@freezed` annotation for immutable state classes
- Repository providers are configured in `repository_providers.dart`
- Generated providers automatically include `.autoDispose` variants

### Database Tables
All Drift tables must:
- Extend `Table` class from `package:drift/drift.dart`
- Use `@DataClassName` annotation to specify the generated model name
- Define columns with appropriate column types (`IntColumn`, `TextColumn`, `RealColumn`, `DateTimeColumn`, etc.)
- Use `autoIncrement()` for primary key IDs
- Be registered in the `@DriftDatabase` tables list in `local_database.dart`

Example:
```dart
@DataClassName('TransactionModel')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get value => real()();
  TextColumn get description => text()();
  // ... other columns
}
```

#### Accounts Table
The Accounts table supports dual-type accounts (can be both debit and credit):
- **isDebit / isCredit**: Boolean flags for account types (both can be true)
- **balance**: Debit account balance
- **creditLimit / creditUsed**: Credit account limits and usage
- **isDefault**: Default account selection flag
- **creditPaymentDay**: Credit card payment due day (1-31, nullable). The closing day is automatically calculated as payment day - 7 days. This creates a 7-day "ideal purchase period" between closing and payment where purchases go to the next bill. (renamed from creditClosingDay in schema v10)
- **excludeFromReserve**: When true, debit account balances are excluded from reserve calculations (added in schema v9)
