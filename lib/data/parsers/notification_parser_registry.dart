import '../../domain/parsers/i_notification_parser.dart';
import 'santander_notification_parser.dart';

/// Registry for notification parsers with singleton pattern
///
/// This registry maintains a collection of notification parsers indexed by
/// bank package name. It allows dynamic registration of parsers and provides
/// a way to find the appropriate parser for a given notification.
class NotificationParserRegistry {
  static final NotificationParserRegistry _instance =
      NotificationParserRegistry._internal();

  final Map<String, INotificationParser> _parsers = {};

  factory NotificationParserRegistry() {
    return _instance;
  }

  NotificationParserRegistry._internal() {
    _registerDefaultParsers();
  }

  /// Register default parsers for supported banks
  void _registerDefaultParsers() {
    register(SantanderNotificationParser());
    // Future parsers:
    // register(NubankNotificationParser());
    // register(ItauNotificationParser());
  }

  /// Register a new parser
  ///
  /// If a parser for the same package name already exists, it will be replaced.
  void register(INotificationParser parser) {
    _parsers[parser.packageName] = parser;
  }

  /// Get a parser for the given package name
  ///
  /// Returns the parser if found, null otherwise.
  INotificationParser? getParser(String packageName) {
    return _parsers[packageName];
  }

  /// Get all supported bank names
  List<String> get supportedBanks =>
      _parsers.values.map((p) => p.bankName).toList();

  /// Get all registered parsers
  Map<String, INotificationParser> get parsers => Map.unmodifiable(_parsers);

  /// Check if a bank is supported
  bool isSupported(String packageName) {
    return _parsers.containsKey(packageName);
  }

  /// Clear all parsers (mainly for testing)
  void clear() {
    _parsers.clear();
  }

  /// Reset to default parsers (mainly for testing)
  void reset() {
    _parsers.clear();
    _registerDefaultParsers();
  }
}
