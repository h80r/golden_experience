/// Represents a notification event from the system
/// Contains metadata about a notification received from a bank app
class NotificationEvent {
  final String? packageName;
  final String? title;
  final String? text;
  final String? bigText;
  final DateTime timestamp;

  const NotificationEvent({
    this.packageName,
    this.title,
    this.text,
    this.bigText,
    required this.timestamp,
  });

  /// Full notification text (prefers bigText, falls back to text)
  String get fullText => (bigText ?? text) ?? '';

  @override
  String toString() {
    return 'NotificationEvent(packageName: $packageName, title: $title, text: $text, timestamp: $timestamp)';
  }
}
