import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/parsers/santander_notification_parser.dart';
import 'package:golden_experience/domain/models/notification_event.dart';

void main() {
  group('SantanderNotificationParser', () {
    final parser = SantanderNotificationParser();

    group('Basic Properties', () {
      test('packageName returns correct Santander package', () {
        expect(parser.packageName, 'com.santander.app');
      });

      test('bankName returns Santander', () {
        expect(parser.bankName, 'Santander');
      });
    });

    group('canParse', () {
      test('returns true for valid Santander purchase notification', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1167, de R\$ 208,05, em 22/10/25, às 07:58, em aliexpress, aprovada.',
          timestamp: DateTime.now(),
        );

        expect(parser.canParse(event), true);
      });

      test('returns false when missing required keywords', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Pagamento recebido com sucesso.',
          timestamp: DateTime.now(),
        );

        expect(parser.canParse(event), false);
      });

      test('returns false for empty text', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: '',
          timestamp: DateTime.now(),
        );

        expect(parser.canParse(event), false);
      });
    });

    group('parse - Valid Transactions', () {
      test('parses standard purchase notification', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1167, de R\$ 208,05, em 22/10/25, às 07:58, em aliexpress, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.value, 208.05);
        expect(result.description, contains('aliexpress'));
        expect(result.description, contains('1167'));
        expect(result.date.day, 22);
        expect(result.date.month, 10);
        expect(result.date.year, 2025);
        expect(result.date.hour, 7);
        expect(result.date.minute, 58);
        expect(result.sourceBank, 'Santander');
      });

      test('parses transaction with large value', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 5678, de R\$ 1.234,56, em 15/11/25, às 14:30, em mercado, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.value, 1234.56);
      });

      test('parses transaction with whole value (no cents)', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1234, de R\$ 100,00, em 10/10/25, às 12:00, em loja, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.value, 100.0);
      });

      test('parses transaction with single digit value', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 9999, de R\$ 5,00, em 01/01/25, às 09:00, em padaria, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.value, 5.0);
      });

      test('includes card last 4 digits in description', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 4567, de R\$ 50,00, em 05/09/25, às 18:20, em supermercado, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.description, contains('Cartão final 4567'));
      });

      test('parses transaction with bigText instead of text', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          bigText: 'Compra aprovada! Compra no cartão final 2020, de R\$ 150,00, em 12/12/25, às 20:00, em cinema, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.value, 150.0);
      });
    });

    group('parse - Edge Cases', () {
      test('returns null for missing value', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1167, em 22/10/25, às 07:58, em aliexpress, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNull);
      });

      test('returns null for missing date', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1167, de R\$ 208,05, em aliexpress, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNull);
      });

      test('returns null for invalid date format', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1167, de R\$ 208,05, em 32/13/25, às 07:58, em aliexpress, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNull);
      });
    });

    group('parse - Date Parsing', () {
      test('correctly parses day and month from notification', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 100,00, em 15/03/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.date.day, 15);
        expect(result!.date.month, 3);
        expect(result!.date.year, 2025);
      });

      test('correctly parses hours and minutes', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 100,00, em 15/10/25, às 23:59, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.date.hour, 23);
        expect(result!.date.minute, 59);
      });

      test('correctly parses single-digit day', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 100,00, em 5/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result, isNotNull);
        expect(result!.date.day, 5);
      });
    });

    group('Value Parsing', () {
      test('parses value with thousand separator correctly', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 1.234,56, em 10/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);
        expect(result!.value, 1234.56);
      });

      test('parses value without thousand separator', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 99,99, em 10/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);
        expect(result!.value, 99.99);
      });

      test('parses value with multiple thousand separators', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 12.345.678,90, em 10/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);
        expect(result!.value, 12345678.90);
      });
    });

    group('TransactionData returned', () {
      test('returned TransactionData has sourceBank set to Santander', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 100,00, em 10/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result!.sourceBank, 'Santander');
      });

      test('returned TransactionData has null notes', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 100,00, em 10/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        final result = parser.parse(event);

        expect(result!.notes, isNull);
      });
    });

    group('fullText usage', () {
      test('prefers bigText when both are available', () {
        final event = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Short text without notification',
          bigText: 'Compra aprovada! Compra no cartão final 1111, de R\$ 100,00, em 10/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        // canParse should check fullText which prefers bigText
        final canParse = parser.canParse(event);
        expect(canParse, true);

        final result = parser.parse(event);
        expect(result, isNotNull);
      });
    });
  });
}
