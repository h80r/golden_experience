import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/domain/repositories/i_account_repository.dart';
import 'package:golden_experience/domain/repositories/i_transaction_repository.dart';
import 'package:golden_experience/domain/usecases/add_transaction_usecase.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  group('AddTransactionUseCase', () {
    late MockTransactionRepository transactionRepository;
    late MockAccountRepository accountRepository;
    late AddTransactionUseCase useCase;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      accountRepository = MockAccountRepository();
      useCase = AddTransactionUseCase(
        transactionRepository: transactionRepository,
        accountRepository: accountRepository,
      );
    });

    group('Validation', () {
      test('should fail when value is zero', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 0.0,
          description: 'Test',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isFalse);
        expect(
          result.errorMessage,
          'O valor da transação deve ser maior que zero',
        );
      });

      test('should fail when value is negative', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: -50.0,
          description: 'Test',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isFalse);
        expect(
          result.errorMessage,
          'O valor da transação deve ser maior que zero',
        );
      });

      test('should fail when description is empty', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 100.0,
          description: '',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isFalse);
        expect(
          result.errorMessage,
          'A descrição da transação não pode estar vazia',
        );
      });

      test('should fail when description is only whitespace', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 100.0,
          description: '   ',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isFalse);
        expect(
          result.errorMessage,
          'A descrição da transação não pode estar vazia',
        );
      });

      test('should fail when account does not exist', () async {
        // Act
        final result = await useCase.execute(
          value: 100.0,
          description: 'Test Transaction',
          date: DateTime.now(),
          accountId: 999, // Non-existent account
          categoryId: 1,
        );

        // Assert
        expect(result.success, isFalse);
        expect(result.errorMessage, 'Conta não encontrada');
      });
    });

    group('Debit Account Transactions', () {
      test('should successfully add transaction to debit account', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Checking Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 150.0,
          description: 'Grocery Shopping',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
          notes: 'Weekly groceries',
        );

        // Assert
        expect(result.success, isTrue);
        expect(result.transactionId, matcher.isNotNull);
        expect(result.errorMessage, matcher.isNull);
      });

      test('should decrease debit account balance after transaction', () async {
        // Arrange
        const initialBalance = 1000.0;
        const transactionValue = 150.0;
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Checking Account',
            isDebit: true,
            isCredit: false,
            balance: initialBalance,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        await useCase.execute(
          value: transactionValue,
          description: 'Grocery Shopping',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        final account = await accountRepository.getById(1);
        expect(account, matcher.isNotNull);
        expect(account!.balance, initialBalance - transactionValue);
      });

      test('should create transaction in repository', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Checking Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        final testDate = DateTime(2024, 1, 15);

        // Act
        await useCase.execute(
          value: 75.50,
          description: 'Restaurant',
          date: testDate,
          accountId: 1,
          categoryId: 2,
          notes: 'Dinner with friends',
        );

        // Assert
        final transactions = await transactionRepository.getAll();
        expect(transactions.length, 1);
        expect(transactions[0].value, 75.50);
        expect(transactions[0].description, 'Restaurant');
        expect(transactions[0].date, testDate);
        expect(transactions[0].accountId, 1);
        expect(transactions[0].categoryId, 2);
        expect(transactions[0].notes, 'Dinner with friends');
      });
    });

    group('Credit Account Transactions', () {
      test('should successfully add transaction to credit account', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 2,
            name: 'Credit Card',
            isDebit: false,
            isCredit: true,
            balance: 0.0,
            creditLimit: 5000.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 200.0,
          description: 'Online Shopping',
          date: DateTime.now(),
          accountId: 2,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isTrue);
        expect(result.transactionId, matcher.isNotNull);
        expect(result.errorMessage, matcher.isNull);
      });

      test('should increase credit used after transaction', () async {
        // Arrange
        const initialLimit = 5000.0;
        const transactionValue = 200.0;
        accountRepository.addAccount(
          AccountModel(
            id: 2,
            name: 'Credit Card',
            isDebit: false,
            isCredit: true,
            balance: 0.0,
            creditLimit: initialLimit,
            creditUsed: 0.0,
          ),
        );

        // Act
        await useCase.execute(
          value: transactionValue,
          description: 'Online Shopping',
          date: DateTime.now(),
          accountId: 2,
          categoryId: 1,
        );

        // Assert
        final account = await accountRepository.getById(2);
        expect(account, matcher.isNotNull);
        expect(account!.creditUsed, transactionValue);
      });
    });

    group('Error Handling', () {
      test('should rollback transaction if account update fails', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );
        accountRepository.shouldFailOnUpdate = true;

        // Act
        final result = await useCase.execute(
          value: 100.0,
          description: 'Test',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isFalse);
        expect(
          result.errorMessage,
          'Erro ao atualizar saldo/limite da conta',
        );

        // Verify transaction was rolled back
        final transactions = await transactionRepository.getAll();
        expect(transactions.length, 0);
      });

      test('should handle unexpected exceptions gracefully', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );
        transactionRepository.shouldFailOnCreate = true;

        // Act
        final result = await useCase.execute(
          value: 100.0,
          description: 'Test',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isFalse);
        expect(result.errorMessage, contains('Erro inesperado'));
      });
    });

    group('Edge Cases', () {
      test('should handle transaction without notes', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 50.0,
          description: 'Quick purchase',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isTrue);

        final transactions = await transactionRepository.getAll();
        expect(transactions[0].notes, matcher.isNull);
      });

      test('should handle very small transaction values', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 100.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 0.01,
          description: 'Tiny purchase',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isTrue);

        final account = await accountRepository.getById(1);
        expect(account!.balance, closeTo(99.99, 0.001));
      });

      test('should handle very large transaction values', () async {
        // Arrange
        accountRepository.addAccount(
          AccountModel(
            id: 1,
            name: 'Test Account',
            isDebit: true,
            isCredit: false,
            balance: 1000000.0,
            creditLimit: 0.0,
            creditUsed: 0.0,
          ),
        );

        // Act
        final result = await useCase.execute(
          value: 999999.99,
          description: 'Large purchase',
          date: DateTime.now(),
          accountId: 1,
          categoryId: 1,
        );

        // Assert
        expect(result.success, isTrue);

        final account = await accountRepository.getById(1);
        expect(account!.balance, closeTo(0.01, 0.001));
      });
    });
  });
}

/// Mock implementation of IAccountRepository for testing
class MockAccountRepository implements IAccountRepository {
  final Map<int, AccountModel> _accounts = {};
  bool shouldFailOnUpdate = false;

  void addAccount(AccountModel account) {
    _accounts[account.id] = account;
  }

  @override
  Future<int> create(Insertable<AccountModel> account) async {
    return 0;
  }

  @override
  Future<bool> delete(int id) async {
    return _accounts.remove(id) != null;
  }

  @override
  Future<List<AccountModel>> getAll() async => _accounts.values.toList();

  @override
  Future<AccountModel?> getById(int id) async => _accounts[id];

  @override
  Future<bool> hasTransactions(int accountId) async => false;

  @override
  Future<bool> update(Insertable<AccountModel> account) async => true;

  @override
  Future<bool> updateBalance(int accountId, double newBalance) async {
    if (shouldFailOnUpdate) return false;

    final account = _accounts[accountId];
    if (account == null) return false;

    _accounts[accountId] = AccountModel(
      id: account.id,
      name: account.name,
      isDebit: account.isDebit,
      isCredit: account.isCredit,
      balance: newBalance,
      creditLimit: account.creditLimit,
      creditUsed: account.creditUsed,
    );
    return true;
  }

  @override
  Future<bool> updateCreditLimit(int accountId, double newLimit) async {
    if (shouldFailOnUpdate) return false;

    final account = _accounts[accountId];
    if (account == null) return false;

    _accounts[accountId] = AccountModel(
      id: account.id,
      name: account.name,
      isDebit: account.isDebit,
      isCredit: account.isCredit,
      balance: account.balance,
      creditLimit: newLimit,
      creditUsed: account.creditUsed,
    );
    return true;
  }

  @override
  Future<bool> updateCreditUsed(int accountId, double newCreditUsed) async {
    if (shouldFailOnUpdate) return false;

    final account = _accounts[accountId];
    if (account == null) return false;

    _accounts[accountId] = AccountModel(
      id: account.id,
      name: account.name,
      isDebit: account.isDebit,
      isCredit: account.isCredit,
      balance: account.balance,
      creditLimit: account.creditLimit,
      creditUsed: newCreditUsed,
    );
    return true;
  }

  @override
  Stream<List<AccountModel>> watchAll() {
    return Stream.value(_accounts.values.toList());
  }
}

/// Mock implementation of ITransactionRepository for testing
class MockTransactionRepository implements ITransactionRepository {
  final List<TransactionModel> _transactions = [];
  int _nextId = 1;
  bool shouldFailOnCreate = false;

  @override
  Future<int> create(Insertable<TransactionModel> transaction) async {
    if (shouldFailOnCreate) {
      throw Exception('Failed to create transaction');
    }

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
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transactions.removeAt(index);
      return true;
    }
    return false;
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
}
