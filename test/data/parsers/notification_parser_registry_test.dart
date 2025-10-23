import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/parsers/notification_parser_registry.dart';
import 'package:golden_experience/data/parsers/santander_notification_parser.dart';
import 'package:golden_experience/domain/models/notification_event.dart';
import 'package:golden_experience/domain/models/transaction_data.dart';
import 'package:golden_experience/domain/parsers/i_notification_parser.dart';

/// Mock parser for testing
class MockNotificationParser implements INotificationParser {
  @override
  String get packageName => 'com.mock.app';

  @override
  String get bankName => 'MockBank';

  @override
  bool canParse(NotificationEvent event) {
    return event.text?.contains('mock') == true;
  }

  @override
  TransactionData? parse(NotificationEvent event) {
    if (!canParse(event)) return null;
    return TransactionData(
      value: 100.0,
      description: 'Mock Transaction',
      date: DateTime(2025, 10, 22),
      sourceBank: 'MockBank',
    );
  }
}

void main() {
  group('NotificationParserRegistry', () {
    group('Singleton Pattern', () {
      test('returns same instance on multiple calls', () {
        final instance1 = NotificationParserRegistry();
        final instance2 = NotificationParserRegistry();

        expect(identical(instance1, instance2), true);
      });

      test('singleton instance persists across multiple instantiations', () {
        final instance1 = NotificationParserRegistry();
        final instance1Id = identical(instance1, instance1);

        final instance2 = NotificationParserRegistry();
        final bothSame = identical(instance1, instance2);

        expect(bothSame, true);
      });
    });

    group('Default Parsers', () {
      test('initializes with Santander parser', () {
        final registry = NotificationParserRegistry();

        final parser = registry.getParser('com.santander.app');
        expect(parser, isNotNull);
        expect(parser, isA<SantanderNotificationParser>());
      });

      test('supportedBanks includes Santander', () {
        final registry = NotificationParserRegistry();

        expect(registry.supportedBanks, contains('Santander'));
      });

      test('has at least one supported bank', () {
        final registry = NotificationParserRegistry();

        expect(registry.supportedBanks.isNotEmpty, true);
      });
    });

    group('Register', () {
      test('registers a new parser', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final mockParser = MockNotificationParser();
        registry.register(mockParser);

        final retrieved = registry.getParser('com.mock.app');
        expect(retrieved, isNotNull);
        expect(retrieved, isA<MockNotificationParser>());
      });

      test('replaces existing parser with same package name', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final parser1 = MockNotificationParser();
        registry.register(parser1);

        final anotherMockParser = MockNotificationParser();
        registry.register(anotherMockParser);

        final retrieved = registry.getParser('com.mock.app');
        expect(retrieved, isNotNull);
        expect(retrieved, isA<MockNotificationParser>());
      });

      test('can register multiple different parsers', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final mockParser1 = MockNotificationParser();
        registry.register(mockParser1);

        // Create another mock parser (we'd normally have different parsers here)
        final santanderParser = SantanderNotificationParser();
        registry.register(santanderParser);

        expect(registry.getParser('com.mock.app'), isNotNull);
        expect(registry.getParser('com.santander.app'), isNotNull);
        expect(registry.supportedBanks.length, 2);
      });
    });

    group('GetParser', () {
      test('returns parser for registered package name', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());

        final parser = registry.getParser('com.mock.app');

        expect(parser, isNotNull);
        expect(parser!.packageName, 'com.mock.app');
      });

      test('returns null for unregistered package name', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final parser = registry.getParser('com.unregistered.app');

        expect(parser, isNull);
      });

      test('returns null for empty package name', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final parser = registry.getParser('');

        expect(parser, isNull);
      });

      test('returns correct parser for different packages', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());
        registry.register(SantanderNotificationParser());

        final mockParser = registry.getParser('com.mock.app');
        final santanderParser = registry.getParser('com.santander.app');

        expect(mockParser, isA<MockNotificationParser>());
        expect(santanderParser, isA<SantanderNotificationParser>());
        expect(identical(mockParser, santanderParser), false);
      });
    });

    group('SupportedBanks', () {
      test('returns list of supported bank names', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());
        registry.register(SantanderNotificationParser());

        final banks = registry.supportedBanks;

        expect(banks, contains('MockBank'));
        expect(banks, contains('Santander'));
      });

      test('returns empty list when no parsers registered', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final banks = registry.supportedBanks;

        expect(banks.isEmpty, true);
      });

      test('returns list with unique bank names', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        registry.register(MockNotificationParser());
        registry.register(SantanderNotificationParser());

        final banks = registry.supportedBanks;

        // Check no duplicates (set size should equal list size if no duplicates)
        expect(banks.length, banks.toSet().length);
      });

      test('does not include same bank twice', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final mockParser = MockNotificationParser();
        registry.register(mockParser);
        registry.register(mockParser); // Register same instance twice

        final banks = registry.supportedBanks;

        // Should still only have one MockBank entry
        final mockBankCount =
            banks.where((b) => b == 'MockBank').length;
        expect(mockBankCount, 1);
      });
    });

    group('Parsers Property', () {
      test('returns map of all registered parsers', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());

        final parsers = registry.parsers;

        expect(parsers.containsKey('com.mock.app'), true);
        expect(parsers['com.mock.app'], isA<MockNotificationParser>());
      });

      test('returned map is unmodifiable', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        final parsers = registry.parsers;

        expect(
          () => parsers['com.new.app'] = MockNotificationParser(),
          throwsUnsupportedError,
        );
      });
    });

    group('IsSupported', () {
      test('returns true for registered package name', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());

        expect(registry.isSupported('com.mock.app'), true);
      });

      test('returns false for unregistered package name', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        expect(registry.isSupported('com.unregistered.app'), false);
      });

      test('returns false for empty package name', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        expect(registry.isSupported(''), false);
      });

      test('returns false after clearing parsers', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());

        expect(registry.isSupported('com.mock.app'), true);

        registry.clear();

        expect(registry.isSupported('com.mock.app'), false);
      });
    });

    group('Clear', () {
      test('removes all registered parsers', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());
        registry.register(SantanderNotificationParser());

        expect(registry.supportedBanks.isNotEmpty, true);

        registry.clear();

        expect(registry.supportedBanks.isEmpty, true);
        expect(registry.getParser('com.mock.app'), isNull);
        expect(registry.getParser('com.santander.app'), isNull);
      });

      test('allows re-registering after clear', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        registry.register(MockNotificationParser());
        expect(registry.isSupported('com.mock.app'), true);

        registry.clear();
        expect(registry.isSupported('com.mock.app'), false);

        registry.register(MockNotificationParser());
        expect(registry.isSupported('com.mock.app'), true);
      });
    });

    group('Reset', () {
      test('clears and re-registers default parsers', () {
        final registry = NotificationParserRegistry();
        registry.clear();

        expect(registry.isSupported('com.santander.app'), false);

        registry.reset();

        expect(registry.isSupported('com.santander.app'), true);
        expect(registry.supportedBanks.contains('Santander'), true);
      });

      test('removes custom parsers and restores defaults', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());

        expect(registry.isSupported('com.mock.app'), true);
        expect(registry.isSupported('com.santander.app'), false);

        registry.reset();

        expect(registry.isSupported('com.mock.app'), false);
        expect(registry.isSupported('com.santander.app'), true);
      });
    });

    group('Integration with Parsers', () {
      test('registered parser can successfully parse notifications', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());

        final parser = registry.getParser('com.mock.app');
        final event = NotificationEvent(
          packageName: 'com.mock.app',
          text: 'This is a mock notification',
          timestamp: DateTime.now(),
        );

        expect(parser!.canParse(event), true);
        final result = parser.parse(event);
        expect(result, isNotNull);
        expect(result!.value, 100.0);
      });

      test('multiple parsers can coexist', () {
        final registry = NotificationParserRegistry();
        registry.clear();
        registry.register(MockNotificationParser());
        registry.register(SantanderNotificationParser());

        final mockParser = registry.getParser('com.mock.app');
        final santanderParser = registry.getParser('com.santander.app');

        // Both should handle their own notification types
        final mockEvent = NotificationEvent(
          packageName: 'com.mock.app',
          text: 'This is a mock notification',
          timestamp: DateTime.now(),
        );

        final santanderEvent = NotificationEvent(
          packageName: 'com.santander.app',
          text: 'Compra aprovada! Compra no cartão final 1111, de R\$ 100,00, em 10/10/25, às 12:00, em teste, aprovada.',
          timestamp: DateTime.now(),
        );

        expect(mockParser!.canParse(mockEvent), true);
        expect(santanderParser!.canParse(santanderEvent), true);
        expect(mockParser.canParse(santanderEvent), false);
        expect(santanderParser.canParse(mockEvent), false);
      });
    });
  });
}
