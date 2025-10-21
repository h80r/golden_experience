import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/models/account_model.dart';

void main() {
  group('AccountModel', () {
    test('should create a debit AccountModel instance', () {
      // Act
      final account = AccountModel(
        name: 'Main Account',
        type: AccountType.debit,
        initialBalance: 1000.0,
        creditLimit: 0.0,
      );

      // Assert
      expect(account.name, 'Main Account');
      expect(account.type, AccountType.debit);
      expect(account.initialBalance, 1000.0);
      expect(account.creditLimit, 0.0);
    });

    test('should create a credit AccountModel instance', () {
      // Act
      final account = AccountModel(
        name: 'Credit Card',
        type: AccountType.credit,
        initialBalance: 0.0,
        creditLimit: 5000.0,
      );

      // Assert
      expect(account.name, 'Credit Card');
      expect(account.type, AccountType.credit);
      expect(account.initialBalance, 0.0);
      expect(account.creditLimit, 5000.0);
    });
  });
}
