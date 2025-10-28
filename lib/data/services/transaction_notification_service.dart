import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/models/transaction_data.dart';

/// Service that shows local notifications for detected transactions
///
/// Displays user-friendly notifications in the system notification panel
/// with an action button to quickly add the detected transaction to the app.
class TransactionNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize the local notifications plugin
  ///
  /// Must be called once during app startup, typically before NotificationService.
  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _handleNotificationTap,
    );

    _initialized = true;
  }

  /// Handle notification tap/action
  ///
  /// This is a static callback called by the notifications plugin.
  /// The actual navigation logic should be handled in main.dart
  static void _handleNotificationTap(NotificationResponse response) {
    if (response.actionId == 'add_transaction' && response.payload != null) {
      try {
        // Future: Parse and use transaction data for navigation
        // final data = TransactionData.fromJson(
        //   jsonDecode(response.payload!),
        // );
        // The actual navigation will be handled by the app's root observer
      } catch (e) {
        // Silently fail
      }
    }
  }

  /// Show a transaction notification with action button
  static Future<void> show(TransactionData data) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'transaction_channel',
        'Transações Detectadas',
        channelDescription: 'Notificações de transações bancárias detectadas',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        actions: [
          AndroidNotificationAction(
            'add_transaction',
            'Adicionar Transação',
            showsUserInterface: true,
          ),
        ],
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        data.hashCode, // Use hash as notification ID for uniqueness
        '💰 Nova transação detectada',
        'R\$ ${data.value.toStringAsFixed(2)} em ${data.description}',
        notificationDetails,
        payload: jsonEncode(data.toJson()),
      );
    } catch (e) {
      dev.log('Error showing transaction notification: $e', name: 'TransactionNotificationService');
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      dev.log('Error canceling notifications: $e', name: 'TransactionNotificationService');
    }
  }

  /// Cancel a specific notification
  static Future<void> cancel(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      dev.log('Error canceling notification: $e', name: 'TransactionNotificationService');
    }
  }
}
