import '../models/notification_event.dart';
import '../models/transaction_data.dart';

/// Interface for notification parsers that extract transaction data from bank notifications
///
/// This interface allows for extensible support of multiple banks by implementing
/// bank-specific parsing logic. Each parser handles a specific bank's notification format.
abstract class INotificationParser {
  /// Package name of the bank app (e.g., 'com.santander.app')
  String get packageName;

  /// Display name of the bank (e.g., 'Santander')
  String get bankName;

  /// Validates if this parser can handle the notification
  ///
  /// Returns true if the notification appears to be from this bank's
  /// transaction notification format.
  bool canParse(NotificationEvent event);

  /// Attempts to extract transaction data from the notification
  ///
  /// Returns TransactionData if parsing is successful, null otherwise.
  /// Null return means the notification is not a valid transaction notification,
  /// even if it's from the correct bank.
  TransactionData? parse(NotificationEvent event);
}
