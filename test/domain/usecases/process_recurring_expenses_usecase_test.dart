import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/domain/repositories/i_account_repository.dart';
import 'package:golden_experience/domain/repositories/i_app_settings_repository.dart';
import 'package:golden_experience/domain/repositories/i_recurring_expense_repository.dart';
import 'package:golden_experience/domain/repositories/i_transaction_repository.dart';
import 'package:golden_experience/domain/usecases/process_recurring_expenses_usecase.dart';

void main() {
  group('ProcessRecurringExpensesUseCase', () {
    late MockRecurringExpenseRepository mockRecurringExpenseRepository;
    late MockAppSettingsRepository mockAppSettingsRepository;
    late MockTransactionRepository mockTransactionRepository;
    late MockAccountRepository mockAccountRepository;
    late ProcessRecurringExpensesUseCase useCase;

    setUp(() {
      mockRecurringExpenseRepository = MockRecurringExpenseRepository();
      mockAppSettingsRepository = MockAppSettingsRepository();
      mockTransactionRepository = MockTransactionRepository();
      mockAccountRepository = MockAccountRepository();

      useCase = ProcessRecurringExpensesUseCase(
        recurringExpenseRepository: mockRecurringExpenseRepository,
        appSettingsRepository: mockAppSettingsRepository,
        transactionRepository: mockTransactionRepository,
        accountRepository: mockAccountRepository,
      );
    });

    group('execute', () {
      test('returns failure when AppSettings is not found', () async {
        final result = await useCase.execute();

        expect(result.success, false);
        expect(result.errorMessage, 'Configurações do app não encontradas');
        expect(result.processedCount, 0);
        expect(result.createdTransactionIds, isEmpty);
      });

      test('returns success with 0 processed when lastRecurringCheck is today',
          () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: todayAtMidnight,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        expect(result.success, true);
        expect(result.processedCount, 0);
        expect(result.createdTransactionIds, isEmpty);
      });

      test('returns success with 0 processed when no recurring expenses exist',
          () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        expect(result.success, true);
        expect(result.processedCount, 0);
        expect(result.createdTransactionIds, isEmpty);
      });

      test('processes one recurring expense on single day correctly', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final debitAccount = AccountModel(
          id: 1,
          name: 'Main Account',
          isDebit: true,
          isCredit: false,
          balance: 1000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
        );

        final recurringExpense = RecurringExpenseModel(
          id: 1,
          value: 100.0,
          description: 'Netflix',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockAccountRepository.addAccount(debitAccount);
        mockRecurringExpenseRepository.addExpense(recurringExpense);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        expect(result.success, true);
        expect(result.processedCount, 1);
        expect(result.createdTransactionIds.length, 1);

        // Verify transaction was created
        expect(mockTransactionRepository.createdTransactions.length, 1);
        final createdTx = mockTransactionRepository.createdTransactions[0];
        expect(createdTx.value, 100.0);
        expect(createdTx.description, contains('[Recorrente]'));
        expect(createdTx.accountId, 1);
      });

      test('processes multiple recurring expenses on same day', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final debitAccount = AccountModel(
          id: 1,
          name: 'Main Account',
          isDebit: true,
          isCredit: false,
          balance: 1000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
        );

        final expense1 = RecurringExpenseModel(
          id: 1,
          value: 100.0,
          description: 'Netflix',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        final expense2 = RecurringExpenseModel(
          id: 2,
          value: 50.0,
          description: 'Spotify',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockAccountRepository.addAccount(debitAccount);
        mockRecurringExpenseRepository.addExpense(expense1);
        mockRecurringExpenseRepository.addExpense(expense2);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        expect(result.success, true);
        expect(result.processedCount, 2);
        expect(result.createdTransactionIds.length, 2);

        // Verify transactions were created
        expect(mockTransactionRepository.createdTransactions.length, 2);
      });

      test('processes expenses across multiple days', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final threeDaysAgo = todayAtMidnight.subtract(const Duration(days: 3));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: threeDaysAgo,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final debitAccount = AccountModel(
          id: 1,
          name: 'Main Account',
          isDebit: true,
          isCredit: false,
          balance: 1000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
        );

        // Create expenses for different days
        final twoDaysAgo = threeDaysAgo.add(const Duration(days: 1));
        final tomorrow = todayAtMidnight.add(const Duration(days: 1));

        final expense1 = RecurringExpenseModel(
          id: 1,
          value: 100.0,
          description: 'Netflix',
          chargeDay: twoDaysAgo.day,
          accountId: 1,
          categoryId: 1,
        );

        final expense2 = RecurringExpenseModel(
          id: 2,
          value: 50.0,
          description: 'Spotify',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockAccountRepository.addAccount(debitAccount);
        mockRecurringExpenseRepository.addExpense(expense1);
        mockRecurringExpenseRepository.addExpense(expense2);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        expect(result.success, true);
        expect(result.processedCount, 2);

        // Verify transactions were created
        expect(mockTransactionRepository.createdTransactions.length, 2);
      });

      test('handles credit account type correctly', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final creditAccount = AccountModel(
          id: 1,
          name: 'Credit Card',
          isDebit: false,
          isCredit: true,
          balance: 0.0,
          creditLimit: 5000.0,
          creditUsed: 0.0,
        );

        final recurringExpense = RecurringExpenseModel(
          id: 1,
          value: 200.0,
          description: 'Card Bill',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockAccountRepository.addAccount(creditAccount);
        mockRecurringExpenseRepository.addExpense(recurringExpense);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        expect(result.success, true);
        expect(result.processedCount, 1);

        // Verify credit used was updated
        final updatedAccount = await mockAccountRepository.getById(1);
        expect(updatedAccount!.creditUsed, 200.0);
      });

      test('skips recurring expense when account does not exist', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final recurringExpense = RecurringExpenseModel(
          id: 1,
          value: 100.0,
          description: 'Netflix',
          chargeDay: today.day,
          accountId: 999, // Non-existent account
          categoryId: 1,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockRecurringExpenseRepository.addExpense(recurringExpense);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        expect(result.success, true);
        expect(result.processedCount, 0);

        // Should not create transaction for non-existent account
        expect(mockTransactionRepository.createdTransactions.length, 0);
      });

      test('continues processing when one transaction fails', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final debitAccount = AccountModel(
          id: 1,
          name: 'Main Account',
          isDebit: true,
          isCredit: false,
          balance: 1000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
        );

        final expense1 = RecurringExpenseModel(
          id: 1,
          value: 100.0,
          description: 'Netflix',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        final expense2 = RecurringExpenseModel(
          id: 2,
          value: 50.0,
          description: 'Spotify',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        // Create a custom transaction repository that fails on first create
        var callCount = 0;
        final failingTransactionRepo = MockTransactionRepository();
        final originalCreate = failingTransactionRepo.create;

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockAccountRepository.addAccount(debitAccount);
        mockRecurringExpenseRepository.addExpense(expense1);
        mockRecurringExpenseRepository.addExpense(expense2);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        final result = await useCase.execute();

        // Even if one fails, it continues processing
        expect(result.success, true);
        expect(result.processedCount, 2);
      });

      test('updates lastRecurringCheck after processing', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        await useCase.execute();

        final updatedSettings = await mockAppSettingsRepository.get();
        expect(updatedSettings!.lastRecurringCheck.year, today.year);
        expect(updatedSettings.lastRecurringCheck.month, today.month);
        expect(updatedSettings.lastRecurringCheck.day, today.day);
      });

      test('creates transaction with [Recorrente] prefix in description',
          () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final debitAccount = AccountModel(
          id: 1,
          name: 'Main Account',
          isDebit: true,
          isCredit: false,
          balance: 1000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
        );

        final recurringExpense = RecurringExpenseModel(
          id: 1,
          value: 100.0,
          description: 'Netflix',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockAccountRepository.addAccount(debitAccount);
        mockRecurringExpenseRepository.addExpense(recurringExpense);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        await useCase.execute();

        final createdTx = mockTransactionRepository.createdTransactions[0];
        expect(createdTx.description, '[Recorrente] Netflix');
      });

      test('sets automatic notes on created transactions', () async {
        final today = DateTime.now();
        final todayAtMidnight = DateTime(today.year, today.month, today.day);
        final yesterday = todayAtMidnight.subtract(const Duration(days: 1));

        final settings = AppSettingsModel(
          id: 1,
          monthlySalary: 5000.0,
          reserveBalance: 2000.0,
          maxReserveUsagePercentage: 50.0,
          lastRecurringCheck: yesterday,
          hasCompletedOnboarding: false,
          isAutoCaptureEnabled: false,
        );

        final debitAccount = AccountModel(
          id: 1,
          name: 'Main Account',
          isDebit: true,
          isCredit: false,
          balance: 1000.0,
          creditLimit: 0.0,
          creditUsed: 0.0,
        );

        final recurringExpense = RecurringExpenseModel(
          id: 1,
          value: 100.0,
          description: 'Netflix',
          chargeDay: today.day,
          accountId: 1,
          categoryId: 1,
        );

        mockAppSettingsRepository =
            MockAppSettingsRepository(initialSettings: settings);
        mockAccountRepository.addAccount(debitAccount);
        mockRecurringExpenseRepository.addExpense(recurringExpense);

        useCase = ProcessRecurringExpensesUseCase(
          recurringExpenseRepository: mockRecurringExpenseRepository,
          appSettingsRepository: mockAppSettingsRepository,
          transactionRepository: mockTransactionRepository,
          accountRepository: mockAccountRepository,
        );

        await useCase.execute();

        final createdTx = mockTransactionRepository.createdTransactions[0];
        expect(createdTx.notes, '[Processada automaticamente]');
      });
    });
  });
}

/// Mock implementation of IAccountRepository for testing
class MockAccountRepository implements IAccountRepository {
  final Map<int, AccountModel> _accounts = {};

  void addAccount(AccountModel account) {
    _accounts[account.id] = account;
  }

  @override
  Future<int> create(Insertable<AccountModel> account) async => 1;

  @override
  Future<bool> delete(int id) async {
    _accounts.remove(id);
    return true;
  }

  @override
  Future<List<AccountModel>> getAll() async => _accounts.values.toList();

  @override
  Future<AccountModel?> getById(int id) async => _accounts[id];

  @override
  Future<bool> hasTransactions(int accountId) async => false;

  @override
  Future<bool> update(Insertable<AccountModel> account) async => true;

  void updateAccountInMemory(AccountModel account) {
    _accounts[account.id] = account;
  }

  @override
  Future<bool> updateBalance(int id, double newBalance) async {
    final account = _accounts[id];
    if (account == null) return false;
    _accounts[id] = account.copyWith(balance: newBalance);
    return true;
  }

  @override
  Future<bool> updateCreditLimit(int id, double newLimit) async {
    final account = _accounts[id];
    if (account == null) return false;
    _accounts[id] = account.copyWith(creditLimit: newLimit);
    return true;
  }

  @override
  Future<bool> updateCreditUsed(int id, double newCreditUsed) async {
    final account = _accounts[id];
    if (account == null) return false;
    _accounts[id] = account.copyWith(creditUsed: newCreditUsed);
    return true;
  }

  @override
  Stream<List<AccountModel>> watchAll() {
    return Stream.value(_accounts.values.toList());
  }
}

/// Mock implementation of IAppSettingsRepository for testing
class MockAppSettingsRepository implements IAppSettingsRepository {
  AppSettingsModel? _settings;

  MockAppSettingsRepository({AppSettingsModel? initialSettings}) {
    _settings = initialSettings;
  }

  @override
  Future<AppSettingsModel?> get() async => _settings;

  @override
  Future<void> initializeDefaults() async {
    // Not needed for tests
  }

  @override
  Future<void> save(Insertable<AppSettingsModel> settings) async {
    // Convert to model
    final companion = settings as AppSettingsModelCompanion;
    _settings = AppSettingsModel(
      id: companion.id.value,
      monthlySalary: companion.monthlySalary.value,
      reserveBalance: companion.reserveBalance.value,
      maxReserveUsagePercentage: companion.maxReserveUsagePercentage.value,
      lastRecurringCheck: companion.lastRecurringCheck.value,
      hasCompletedOnboarding: companion.hasCompletedOnboarding.value,
      isAutoCaptureEnabled: companion.isAutoCaptureEnabled.value,
    );
  }

  @override
  Future<void> updateHasCompletedOnboarding(bool completed) async {
    if (_settings == null) return;
    _settings = _settings!.copyWith(hasCompletedOnboarding: completed);
  }

  @override
  Future<void> updateIsAutoCaptureEnabled(bool enabled) async {
    if (_settings == null) return;
    _settings = _settings!.copyWith(isAutoCaptureEnabled: enabled);
  }

  @override
  Future<void> updateLastRecurringCheck(DateTime date) async {
    if (_settings == null) return;
    _settings = _settings!.copyWith(lastRecurringCheck: date);
  }

  @override
  Future<void> updateMaxReserveUsagePercentage(double percentage) async {
    if (_settings == null) return;
    _settings = _settings!.copyWith(maxReserveUsagePercentage: percentage);
  }

  @override
  Future<void> updateMonthlySalary(double salary) async {
    if (_settings == null) return;
    _settings = _settings!.copyWith(monthlySalary: salary);
  }

  @override
  Future<void> updateReserveBalance(double balance) async {
    if (_settings == null) return;
    _settings = _settings!.copyWith(reserveBalance: balance);
  }

  @override
  Stream<AppSettingsModel?> watch() {
    return Stream.value(_settings);
  }
}

/// Mock implementation of IRecurringExpenseRepository for testing
class MockRecurringExpenseRepository implements IRecurringExpenseRepository {
  final Map<int, List<RecurringExpenseModel>> _expensesByDay = {};
  final List<RecurringExpenseModel> _allExpenses = [];

  MockRecurringExpenseRepository() {
    // Initialize all days to empty lists
    for (int i = 1; i <= 31; i++) {
      _expensesByDay[i] = [];
    }
  }

  void addExpense(RecurringExpenseModel expense) {
    _allExpenses.add(expense);
    _expensesByDay[expense.chargeDay] ??= [];
    _expensesByDay[expense.chargeDay]!.add(expense);
  }

  @override
  Future<int> create(Insertable<RecurringExpenseModel> expense) async => 1;

  @override
  Future<bool> delete(int id) async {
    _allExpenses.removeWhere((e) => e.id == id);
    return true;
  }

  @override
  Future<List<RecurringExpenseModel>> getAll() async => _allExpenses;

  @override
  Future<List<RecurringExpenseModel>> getByChargeDay(int day) async {
    return _expensesByDay[day] ?? [];
  }

  @override
  Future<RecurringExpenseModel?> getById(int id) async {
    try {
      return _allExpenses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> update(Insertable<RecurringExpenseModel> expense) async => true;

  @override
  Stream<List<RecurringExpenseModel>> watchAll() {
    return Stream.value(_allExpenses);
  }
}

/// Mock implementation of ITransactionRepository for testing
class MockTransactionRepository implements ITransactionRepository {
  final List<TransactionModel> _transactions = [];
  int _nextId = 1;

  List<TransactionModel> get createdTransactions => _transactions;

  @override
  Future<int> create(Insertable<TransactionModel> transaction) async {
    final companion = transaction as TransactionModelCompanion;
    final model = TransactionModel(
      id: _nextId,
      value: companion.value.value,
      description: companion.description.value,
      date: companion.date.value,
      accountId: companion.accountId.value,
      categoryId: companion.categoryId.value,
      notes: companion.notes.value,
    );
    _transactions.add(model);
    return _nextId++;
  }

  @override
  Future<bool> delete(int id) async {
    final initialLength = _transactions.length;
    _transactions.removeWhere((t) => t.id == id);
    return _transactions.length < initialLength;
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
  Future<bool> update(Insertable<TransactionModel> transaction) async => true;

  @override
  Stream<List<TransactionModel>> watchAll() {
    return Stream.value(_transactions);
  }

  @override
  Stream<List<TransactionModel>> watchByMonth(int month, int year) {
    return Stream.value(
      _transactions
          .where((t) => t.date.month == month && t.date.year == year)
          .toList(),
    );
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
}
