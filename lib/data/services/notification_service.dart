import 'dart:async';
import 'dart:developer' as dev;

import 'package:notification_listener/models/notification.dart';
import 'package:notification_listener/notification_listener.dart';

import '../../domain/models/notification_event.dart';
import '../parsers/notification_parser_registry.dart';
import 'transaction_notification_service.dart';

/// Service that listens to system notifications and processes bank transactions
///
/// This service integrates with Android's NotificationListenerService to detect
/// bank transaction notifications, parse them using registered parsers, and
/// display local notifications to the user for quick transaction entry.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static bool _initialized = false;
  static StreamSubscription<AndroidNotificationEvent>? _subscription;
  static final _registry = NotificationParserRegistry();

  /// Check if the notification service is initialized
  static bool get isInitialized => _initialized;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  /// Stop listening to notifications (for cleanup)
  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }

  /// Check if notification permission is granted
  static Future<bool> hasPermission() async {
    try {
      return await AndroidNotificationListener.isGranted();
    } catch (e) {
      return false;
    }
  }

  /// Initialize the notification listener service
  ///
  /// Starts listening to system notifications and processes them through
  /// registered bank parsers.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Check if permission is granted
      final hasPermission = await AndroidNotificationListener.isGranted();

      if (!hasPermission) {
        // Permission not granted - service will be inactive until permission is granted
        _initialized = true;
        return;
      }

      // Start listening to notifications
      _subscription = AndroidNotificationListener.accessStream.listen(
        _handleNotification,
        onError: (error) {
          // Log error but don't crash
          dev.log('Notification listener error: $error',
              name: 'NotificationService');
        },
      );

      _initialized = true;
    } catch (e) {
      dev.log('Error initializing notification service: $e',
          name: 'NotificationService');
      _initialized = true;
    }
  }

  /// Open system settings for notification permission
  static Future<void> openPermissionSettings() async {
    try {
      await AndroidNotificationListener.request();
    } catch (e) {
      // Silently fail
      dev.log('Error opening permission settings: $e',
          name: 'NotificationService');
    }
  }

  /// Handle incoming notification events
  static void _handleNotification(AndroidNotificationEvent event) {
    try {
      // Skip if event is removed or has no package name
      if (event.hasRemoved == true || event.packageName == null) {
        return;
      }

      // if (event.packageName == 'dev.h80r.golden_experience') {
      //   // Ignore self notifications
      //   return;
      // }

      // event = AndroidNotificationEvent(
      //   packageName: 'com.santander.app',
      //   title: 'Compra aprovada!',
      //   content:
      //       'Compra no cartão final 1167, de R\$ 11,11, em 30/10/25, às 09:21, em UBER . PENDING, aprovada.',
      // ); // TODO: remove testing data

      // Convert ServiceNotificationEvent to our NotificationEvent model
      final notificationEvent = NotificationEvent(
        packageName: event.packageName,
        title: event.title,
        text: event.content, // Package uses 'content' field
        bigText: event.content, // Use same content for bigText
        timestamp: DateTime.now(),
      );

      // Try to find a parser for this package
      final parser = _registry.getParser(event.packageName!);
      if (parser == null) {
        // No parser registered for this app - ignore
        return;
      }

      // Check if parser can handle this notification
      if (!parser.canParse(notificationEvent)) {
        // Parser exists but can't parse this specific notification
        return;
      }

      // Parse the notification to extract transaction data
      final transactionData = parser.parse(notificationEvent);
      if (transactionData == null) {
        // Parsing failed
        return;
      }

      // Show local notification with transaction data
      TransactionNotificationService.show(transactionData);
    } catch (e) {
      // Silently fail - don't crash the app for notification processing errors
      dev.log('Error handling notification: $e', name: 'NotificationService');
    }
  }
}
