import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/domain/models/dashboard_data.dart';
import 'package:golden_experience/domain/repositories/i_account_repository.dart';
import 'package:golden_experience/domain/repositories/i_app_settings_repository.dart';
import 'package:golden_experience/domain/repositories/i_transaction_repository.dart';
import 'package:golden_experience/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:drift/drift.dart';
import 'package:matcher/matcher.dart' as matcher;

/// Mock implementation of ITransactionRepository for testing
class MockTransactionRepository implements ITransactionRepository {
  final List<TransactionModel> _transactions = [];
  int _nextId = 1;

  void addTransaction({
    required double value,
    required String description,
    required DateTime date,
    required int accountId,
    required int categoryId,
    String? notes,
    String transactionType = 'credit',
  }) {
    _transactions.add(
      TransactionModel(
        id: _nextId++,
        value: value,
        description: description,
        date: date,
        accountId: accountId,
        categoryId: categoryId,
        notes: notes,
        transactionType: transactionType,
      ),
    );
  }

  @override
  Future<int> create(Insertable<TransactionModel> transaction) async {
    return 0;
  }

  @override
  Future<bool> delete(int id) async {
    return false;
  }

  @override
  Future<int> deleteAll() async {
    final count = _transactions.length;
    _transactions.clear();
    return count;
  }

  @override
  Future<List<TransactionModel>> getAll() async => _transactions;

  @override
  Future<TransactionModel?> getById(int id) async {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<TransactionModel>> getByMonth(int month, int year) async {
    return _transactions
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
  }

  @override
  Future<bool> update(Insertable<TransactionModel> transaction) async {
    return true;
  }

  @override
  Stream<List<TransactionModel>> watchAll() {
    return Stream.value(_transactions);
  }

  @override
  Stream<List<TransactionModel>> watchCurrentMonth() {
    final now = DateTime.now();
    return Stream.value(
      _transactions
          .where((t) => t.date.month == now.month && t.date.year == now.year)
          .toList(),
    );
  }

  @override
  Future<List<TransactionModel>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return _transactions
        .where((t) =>
            t.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  @override
  Stream<List<TransactionModel>> watchByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return Stream.value(
      _transactions
          .where((t) =>
              t.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList(),
    );
  }

  @override
  Future<List<TransactionModel>> getByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return _transactions
        .where((t) =>
            t.accountId == accountId &&
            t.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  @override
  Stream<List<TransactionModel>> watchByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return Stream.value(
      _transactions
          .where((t) =>
              t.accountId == accountId &&
              t.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList(),
    );
  }

  @override
  Future<String> createInstallmentTransactions({
    required Insertable<TransactionModel> transaction,
    required int currentInstallment,
    required int totalInstallments,
    required int accountId,
  }) async {
    // Mock implementation - just return a fake UUID
    return 'mock-uuid-123';
  }

  @override
  Future<int> deleteInstallmentGroup(String installmentGroupId) async {
    // Mock implementation - return 0 (no deletions)
    return 0;
  }

  @override
  Future<List<TransactionModel>> getByInstallmentGroup(String installmentGroupId) async {
    // Mock implementation - return empty list
    return [];
  }
}

/// Mock implementation of IAccountRepository for testing
class MockAccountRepository implements IAccountRepository {
  final List<AccountModel> _accounts = [];

  void addAccount(AccountModel account) {
    _accounts.add(account);
  }

  void clearAccounts() {
    _accounts.clear();
  }

  @override
  Future<int> create(Insertable<AccountModel> account) async {
    return 0;
  }

  @override
  Future<AccountModel?> getById(int id) async {
    try {
      return _accounts.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<AccountModel>> getAll() async => _accounts;

  @override
  Future<bool> update(Insertable<AccountModel> account) async {
    return true;
  }

  @override
  Future<bool> updateBalance(int accountId, double newBalance) async {
    return true;
  }

  @override
  Future<bool> updateCreditLimit(int accountId, double newLimit) async {
    return true;
  }

  @override
  Future<bool> updateCreditUsed(int accountId, double newCreditUsed) async {
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    return false;
  }

  @override
  Future<bool> hasTransactions(int accountId) async {
    return false;
  }

  @override
  Stream<List<AccountModel>> watchAll() {
    return Stream.value(_accounts);
  }

  @override
  Future<AccountModel?> getDefaultAccount() async {
    try {
      return _accounts.firstWhere((a) => a.isDefault);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setDefaultAccount(int accountId) async {
    return true;
  }

  @override
  Future<bool> clearDefaultAccount() async {
    return true;
  }
}

/// Mock implementation of IAppSettingsRepository for testing
class MockAppSettingsRepository implements IAppSettingsRepository {
  AppSettingsModel? _settings;

  void setSettings(AppSettingsModel settings) {
    _settings = settings;
  }

  @override
  Future<AppSettingsModel?> get() async => _settings;

  @override
  Future<void> save(Insertable<AppSettingsModel> settings) async {}

  @override
  Future<void> updateMonthlySalary(double salary) async {}

  @override
  Future<void> updateMaxReserveUsagePercentage(double percentage) async {}

  @override
  Future<void> updateLastRecurringCheck(DateTime date) async {}

  @override
  Future<void> updateHasCompletedOnboarding(bool completed) async {}

  @override
  Future<void> updateIsAutoCaptureEnabled(bool enabled) async {}

  @override
  Future<void> updateSalaryPaymentConfig(String mode, int value) async {}

  @override
  Future<void> initializeDefaults() async {}

  @override
  Stream<AppSettingsModel?> watch() {
    return Stream.value(_settings);
  }
}

void main() {
  group('GetDashboardDataUseCase', () {
    late MockTransactionRepository transactionRepository;
    late MockAppSettingsRepository appSettingsRepository;
    late MockAccountRepository accountRepository;
    late GetDashboardDataUseCase useCase;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      appSettingsRepository = MockAppSettingsRepository();
      accountRepository = MockAccountRepository();

      // Add default account with 2000.0 balance (used as reserve in most tests)
      // Individual tests can clear and add custom accounts if needed
      accountRepository.addAccount(AccountModel(
        id: 1,
        name: 'Default Test Account',
        isDebit: true,
        isCredit: false,
        balance: 2000.0,
        creditLimit: 0.0,
        creditUsed: 0.0,
        isDefault: false,
        creditPaymentDay: null,
        excludeFromReserve: false,
      ));

      useCase = GetDashboardDataUseCase(
        transactionRepository: transactionRepository,
        appSettingsRepository: appSettingsRepository,
        accountRepository: accountRepository,
      );
    });

    group('Basic Functionality', () {
      test('should throw exception when settings are not initialized',
          () async {
        // Act & Assert
        expect(
          () => useCase.execute(),
          throwsException,
        );
      });

      test('should return DashboardData when settings exist', () async {
        // Arrange
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        // Note: Default account with 2000.0 balance is added in setUp()

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, matcher.isNotNull);
        expect(result, isA<DashboardData>());
        expect(result.monthlySalary, 5000.0);
      });

      test('should handle empty transaction list', () async {
        // Arrange
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, 0.0);
        expect(result.partialResult, 5000.0); // Salary - 0
      });
    });

    group('Calculation: Total Spent', () {
      test('should calculate total spent correctly', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 100.0,
          description: 'Grocery',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );
        transactionRepository.addTransaction(
          value: 50.0,
          description: 'Coffee',
          date: DateTime(now.year, now.month, 10),
          accountId: 1,
          categoryId: 2,
        );
        transactionRepository.addTransaction(
          value: 75.0,
          description: 'Lunch',
          date: DateTime(now.year, now.month, 15),
          accountId: 1,
          categoryId: 2,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, 225.0);
      });

      test('should only count current month transactions', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 100.0,
          description: 'Current month',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );
        transactionRepository.addTransaction(
          value: 500.0,
          description: 'Previous month',
          date: DateTime(now.year, now.month - 1, 10),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, 100.0);
      });
    });

    group('Calculation: Partial Result', () {
      test('should calculate partial result (Salary - Spent) correctly',
          () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 1500.0,
          description: 'Rent',
          date: DateTime(now.year, now.month, 1),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.partialResult, 3500.0); // 5000 - 1500
      });

      test('should handle negative partial result', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 3500.0,
          description: 'Overspending',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.partialResult, -500.0); // 3000 - 3500
      });
    });

    group('Calculation: Remaining Budget', () {
      test('should calculate remaining budget correctly (no overspend)',
          () async {
        // Arrange: Salary 5000, Reserve 2000 (50% = 1000 allowed)
        // Spent 1000, so remaining should be (5000 + 1000) - 1000 = 5000
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 1000.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        // (5000 + (2000 * 0.5)) - 1000 = (5000 + 1000) - 1000 = 5000
        expect(result.remainingBudget, 5000.0);
      });

      test('should calculate remaining budget correctly (with overspend)',
          () async {
        // Arrange: Salary 3000, Reserve 2000 (50% = 1000 allowed)
        // Spent 4500, so remaining should be (3000 + 1000) - 4500 = -500
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 4500.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        // (3000 + (2000 * 0.5)) - 4500 = (3000 + 1000) - 4500 = -500
        expect(result.remainingBudget, -500.0);
      });
    });

    group('Calculation: Final Reserve', () {
      test('should keep reserve unchanged when spending is within salary',
          () async {
        // Arrange: Spent 1000, Salary 3000, so no reserve depletion
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 1000.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.finalReserve, 2000.0); // Reserve unchanged
      });

      test('should deplete reserve when spending exceeds salary', () async {
        // Arrange: Spent 4000, Salary 3000, so 1000 from reserve
        // Initial Reserve: 2000, Final Reserve: 2000 - 1000 = 1000
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 4000.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.finalReserve, 1000.0); // 2000 - (4000 - 3000)
      });

      test('should handle negative reserve when overspending is large',
          () async {
        // Arrange: Spent 6000, Salary 3000, Overspend 3000
        // Initial Reserve: 2000, Final Reserve: 2000 - 3000 = -1000
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 6000.0,
          description: 'Large expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.finalReserve, -1000.0); // 2000 - (6000 - 3000)
      });
    });

    group('Calculation: Reserve Usage Percentage', () {
      test('should calculate zero reserve usage when no overspending',
          () async {
        // Arrange: Spent 1000, Salary 3000, no overspend
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 1000.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.reserveUsagePercentage, 0.0);
      });

      test('should calculate reserve usage percentage correctly', () async {
        // Arrange: Salary 3000, Reserve 2000 (50% = 1000 max)
        // Spent 3500, Overspend 500
        // Usage: (500 / 1000) * 100 = 50%
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 3500.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        // Max allowed reserve = 2000 * 0.5 = 1000
        // Overspend = 3500 - 3000 = 500
        // Usage = (500 / 1000) * 100 = 50%
        expect(result.reserveUsagePercentage, closeTo(50.0, 0.01));
      });

      test('should calculate 100% reserve usage when maximum is reached',
          () async {
        // Arrange: Salary 3000, Reserve 2000 (50% = 1000 max)
        // Spent 4000, Overspend 1000
        // Usage: (1000 / 1000) * 100 = 100%
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 4000.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.reserveUsagePercentage, closeTo(100.0, 0.01));
      });

      test('should handle 0% max reserve usage percentage', () async {
        // Arrange: 0% max reserve usage means no reserve can be used
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 0.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 3500.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        // Max allowed = 2000 * 0.0 = 0
        // Since division by 0 would occur, usage should be 0%
        expect(result.reserveUsagePercentage, 0.0);
      });
    });

    group('Edge Cases', () {
      test('should handle zero salary', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 0.0,
            maxReserveUsagePercentage: 100.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 500.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.partialResult, -500.0); // 0 - 500
        expect(result.finalReserve, 500.0); // 1000 - 500
      });

      test('should handle zero reserve', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 2000.0,
          description: 'Expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.remainingBudget, 1000.0); // (3000 + 0) - 2000
        expect(result.finalReserve, 0.0);
      });

      test('should handle very small values', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 0.01,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 0.005,
          description: 'Tiny expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, closeTo(0.005, 0.0001));
        expect(result.partialResult, closeTo(0.005, 0.0001));
      });

      test('should handle very large values', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 1000000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 999999.99,
          description: 'Large expense',
          date: DateTime(now.year, now.month, 5),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, closeTo(999999.99, 0.01));
        expect(result.partialResult, closeTo(0.01, 0.01));
      });
    });

    group('DashboardData Model', () {
      test('should create empty DashboardData', () {
        // Act
        final emptyData = DashboardData.empty();

        // Assert
        expect(emptyData.monthlySalary, 0.0);
        expect(emptyData.totalSpent, 0.0);
        expect(emptyData.remainingBudget, 0.0);
        expect(emptyData.partialResult, 0.0);
        expect(emptyData.finalReserve, 0.0);
        expect(emptyData.reserveUsagePercentage, 0.0);
      });

      test('should implement equality correctly', () {
        // Arrange
        const data1 = DashboardData(
          monthlySalary: 5000.0,
          totalSpent: 1000.0,
          remainingBudget: 4000.0,
          partialResult: 4000.0,
          finalReserve: 2000.0,
          reserveUsagePercentage: 0.0,
          initialReserve: 2000.0,
          maxReserveUsagePercentage: 50.0,
        );

        const data2 = DashboardData(
          monthlySalary: 5000.0,
          totalSpent: 1000.0,
          remainingBudget: 4000.0,
          partialResult: 4000.0,
          finalReserve: 2000.0,
          reserveUsagePercentage: 0.0,
          initialReserve: 2000.0,
          maxReserveUsagePercentage: 50.0,
        );

        const data3 = DashboardData(
          monthlySalary: 5000.0,
          totalSpent: 2000.0,
          remainingBudget: 3000.0,
          partialResult: 3000.0,
          finalReserve: 2000.0,
          reserveUsagePercentage: 0.0,
          initialReserve: 2000.0,
          maxReserveUsagePercentage: 50.0,
        );

        // Assert
        expect(data1, equals(data2));
        expect(data1, isNot(equals(data3)));
      });

      test('should have meaningful toString', () {
        // Arrange
        const data = DashboardData(
          monthlySalary: 5000.0,
          totalSpent: 1000.0,
          remainingBudget: 4000.0,
          partialResult: 4000.0,
          finalReserve: 2000.0,
          reserveUsagePercentage: 0.0,
          initialReserve: 2000.0,
          maxReserveUsagePercentage: 50.0,
        );

        // Act
        final stringRep = data.toString();

        // Assert
        expect(stringRep, contains('DashboardData'));
        expect(stringRep, contains('5000.0'));
        expect(stringRep, contains('1000.0'));
      });
    });

    group('Multiple Transactions', () {
      test('should aggregate multiple transactions correctly', () async {
        // Arrange
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        // Add 10 transactions
        for (int i = 0; i < 10; i++) {
          transactionRepository.addTransaction(
            value: 100.0 * (i + 1),
            description: 'Expense $i',
            date: DateTime(now.year, now.month, i + 1),
            accountId: 1,
            categoryId: 1,
          );
        }

        // Act
        final result = await useCase.execute();

        // Assert
        // Total: 100 + 200 + 300 + 400 + 500 + 600 + 700 + 800 + 900 + 1000 = 5500
        expect(result.totalSpent, 5500.0);
        expect(result.partialResult, -500.0); // 5000 - 5500
      });
    });

    group('Real-world Scenarios', () {
      test('Scenario: Healthy financial situation', () async {
        // User has healthy spending within salary and no reserve usage
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 5000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 2000.0,
          description: 'Rent',
          date: DateTime(now.year, now.month, 1),
          accountId: 1,
          categoryId: 1,
        );
        transactionRepository.addTransaction(
          value: 800.0,
          description: 'Groceries',
          date: DateTime(now.year, now.month, 10),
          accountId: 1,
          categoryId: 2,
        );
        transactionRepository.addTransaction(
          value: 500.0,
          description: 'Utilities',
          date: DateTime(now.year, now.month, 15),
          accountId: 1,
          categoryId: 3,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, 3300.0);
        // remainingBudget = (Salary + Reserve*Max%) - Spent = (5000 + 1500) - 3300 = 3200
        expect(result.remainingBudget, 3200.0);
        expect(result.finalReserve, 3000.0); // No reserve depletion
        expect(result.reserveUsagePercentage, 0.0);
      });

      test('Scenario: Moderate overspending using reserve', () async {
        // User slightly exceeds salary, using some reserve
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 3300.0,
          description: 'Various expenses',
          date: DateTime(now.year, now.month, 15),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, 3300.0);
        expect(result.partialResult, -300.0); // 3000 - 3300
        expect(result.finalReserve, 1700.0); // 2000 - 300
        expect(result.reserveUsagePercentage,
            closeTo(30.0, 0.01)); // 300/1000 = 30%
      });

      test('Scenario: Critical: Reserve almost depleted', () async {
        // User is using almost all of their allowed reserve
        final now = DateTime.now();
        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 3000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        transactionRepository.addTransaction(
          value: 3990.0,
          description: 'Heavy expenses',
          date: DateTime(now.year, now.month, 15),
          accountId: 1,
          categoryId: 1,
        );

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.totalSpent, 3990.0);
        // Overspend = 3990 - 3000 = 990
        // finalReserve = 2000 - 990 = 1010
        expect(result.finalReserve, closeTo(1010.0, 0.01));
        expect(result.reserveUsagePercentage, closeTo(99.0, 0.1)); // 990/1000
      });
    });

    group('Exclude From Reserve Feature', () {
      test(
          'should exclude accounts with excludeFromReserve=true from reserve calculation',
          () async {
        // Arrange: Clear default accounts and add custom setup
        accountRepository.clearAccounts();

        // Add regular debit account (included in reserve)
        accountRepository.addAccount(AccountModel(
          id: 1,
          name: 'Regular Account',
          isDebit: true,
          isCredit: false,
          balance: 3000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
          isDefault: false,
          creditPaymentDay: null,
          excludeFromReserve: false,
        ));

        // Add excluded debit account (NOT included in reserve)
        accountRepository.addAccount(AccountModel(
          id: 2,
          name: 'Excluded Account',
          isDebit: true,
          isCredit: false,
          balance: 5000.0, // This should NOT be counted
          creditLimit: 0.0,
          creditUsed: 0.0,
          isDefault: false,
          creditPaymentDay: null,
          excludeFromReserve: true,
        ));

        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 4000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        // Act
        final result = await useCase.execute();

        // Assert: Reserve should be 3000.0 (only from account 1, not 8000.0 total)
        expect(result.initialReserve, 3000.0);
      });

      test('should include all debit accounts when excludeFromReserve=false',
          () async {
        // Arrange: Clear default accounts and add custom setup
        accountRepository.clearAccounts();

        // Add two regular debit accounts (both included in reserve)
        accountRepository.addAccount(AccountModel(
          id: 1,
          name: 'Account 1',
          isDebit: true,
          isCredit: false,
          balance: 2000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
          isDefault: false,
          creditPaymentDay: null,
          excludeFromReserve: false,
        ));

        accountRepository.addAccount(AccountModel(
          id: 2,
          name: 'Account 2',
          isDebit: true,
          isCredit: false,
          balance: 3000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
          isDefault: false,
          creditPaymentDay: null,
          excludeFromReserve: false,
        ));

        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 4000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        // Act
        final result = await useCase.execute();

        // Assert: Reserve should be sum of both accounts = 5000.0
        expect(result.initialReserve, 5000.0);
      });

      test('should handle all accounts excluded from reserve (zero reserve)',
          () async {
        // Arrange: Clear default accounts and add custom setup
        accountRepository.clearAccounts();

        // Add only excluded accounts
        accountRepository.addAccount(AccountModel(
          id: 1,
          name: 'Excluded Account 1',
          isDebit: true,
          isCredit: false,
          balance: 2000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
          isDefault: false,
          creditPaymentDay: null,
          excludeFromReserve: true,
        ));

        accountRepository.addAccount(AccountModel(
          id: 2,
          name: 'Excluded Account 2',
          isDebit: true,
          isCredit: false,
          balance: 3000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
          isDefault: false,
          creditPaymentDay: null,
          excludeFromReserve: true,
        ));

        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 4000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        // Act
        final result = await useCase.execute();

        // Assert: Reserve should be 0.0 (all accounts excluded)
        expect(result.initialReserve, 0.0);
        expect(result.finalReserve, 0.0);
      });

      test('should not exclude credit accounts from any calculations',
          () async {
        // Arrange: Clear default accounts and add custom setup
        accountRepository.clearAccounts();

        // Add debit account
        accountRepository.addAccount(AccountModel(
          id: 1,
          name: 'Debit Account',
          isDebit: true,
          isCredit: false,
          balance: 2000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
          isDefault: false,
          creditPaymentDay: null,
          excludeFromReserve: false,
        ));

        // Add credit account (excludeFromReserve flag should have no effect)
        accountRepository.addAccount(AccountModel(
          id: 2,
          name: 'Credit Account',
          isDebit: false,
          isCredit: true,
          balance: 0.0,
          creditLimit: 5000.0,
          creditUsed: 1000.0,
          isDefault: false,
          creditPaymentDay: 10,
          excludeFromReserve:
              true, // This flag is irrelevant for credit accounts
        ));

        appSettingsRepository.setSettings(
          AppSettingsModel(
            id: 1,
            monthlySalary: 4000.0,
            maxReserveUsagePercentage: 50.0,
            lastRecurringCheck: DateTime(2024, 10, 1),
            hasCompletedOnboarding: false,
            isAutoCaptureEnabled: false,
            salaryPaymentMode: 'calendar',
            salaryPaymentValue: 1,
          ),
        );

        // Act
        final result = await useCase.execute();

        // Assert: Reserve should only include debit account (2000.0)
        // Credit account shouldn't contribute to reserve regardless of flag
        expect(result.initialReserve, 2000.0);
      });
    });
  });
}
