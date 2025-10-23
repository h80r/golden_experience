import '../../domain/models/notification_event.dart';
import '../../domain/models/transaction_data.dart';
import '../../domain/parsers/i_notification_parser.dart';

/// Parser for Santander bank notification messages
///
/// Extracts transaction data from Santander's purchase approval notifications.
/// Expected format: "Compra aprovada! Compra no cartão final 1234, de R$ 100,50,
/// em 22/10/25, às 14:30, em aliexpress, aprovada."
class SantanderNotificationParser implements INotificationParser {
  @override
  String get packageName => 'com.santander.app';

  @override
  String get bankName => 'Santander';

  // Regex patterns for extracting transaction data
  static final _valueRegex = RegExp(r'de\s+R\$\s*([\d.,]+)');
  static final _dateRegex = RegExp(r'em\s+(\d{1,2})/(\d{1,2})/(\d{2}),\s+às\s+(\d{1,2}):(\d{2})');
  // Updated merchant regex to be more flexible
  static final _merchantRegex = RegExp(r'às\s+\d{1,2}:\d{2},\s+em\s+([^,]+?),\s*(?:aprovada|$)');
  static final _cardRegex = RegExp(r'cartão final\s+(\d+)');

  @override
  bool canParse(NotificationEvent event) {
    final text = event.fullText;

    // Check if this looks like a Santander purchase notification
    return text.contains('Compra aprovada') &&
           text.contains('cartão final') &&
           text.contains('R\$');
  }

  @override
  TransactionData? parse(NotificationEvent event) {
    final text = event.fullText;

    // Try to extract value
    final valueMatch = _valueRegex.firstMatch(text);
    if (valueMatch == null) return null;

    final valueStr = valueMatch.group(1)!;
    final value = _parseValue(valueStr);
    if (value == null) return null;

    // Try to extract date and time
    final dateMatch = _dateRegex.firstMatch(text);
    if (dateMatch == null) return null;

    final day = int.tryParse(dateMatch.group(1) ?? '1') ?? 1;
    final month = int.tryParse(dateMatch.group(2) ?? '1') ?? 1;
    final yearStr = dateMatch.group(3) ?? '25';
    final year = int.tryParse('20$yearStr') ?? DateTime.now().year;
    final hour = int.tryParse(dateMatch.group(4) ?? '0') ?? 0;
    final minute = int.tryParse(dateMatch.group(5) ?? '0') ?? 0;

    DateTime date;
    try {
      date = DateTime(year, month, day, hour, minute);
    } catch (e) {
      return null;
    }

    // Try to extract merchant name - be more flexible with patterns
    String merchant = 'Transação (banco detectado)';

    // Try multiple patterns to find merchant
    final merchantMatch = _merchantRegex.firstMatch(text);
    if (merchantMatch != null && merchantMatch.group(1) != null) {
      merchant = merchantMatch.group(1)!.trim();
    } else {
      // Fallback: try to find text between "em " and a comma
      final altPattern = RegExp(r'em\s+([^,]+)(?:\s*,|\s*$)');
      final altMatch = altPattern.firstMatch(text);
      if (altMatch != null && altMatch.group(1) != null) {
        merchant = altMatch.group(1)!.trim();
      }
    }

    // Try to extract card last 4 digits
    final cardMatch = _cardRegex.firstMatch(text);
    final cardLast4 = cardMatch?.group(1) ?? '';
    final description = cardLast4.isNotEmpty
        ? '$merchant (Cartão final $cardLast4)'
        : merchant;

    return TransactionData(
      value: value,
      description: description,
      date: date,
      sourceBank: bankName,
    );
  }

  /// Parse a Brazilian currency string to double
  /// Handles formats like "100,50" or "1.234,50"
  static double? _parseValue(String valueStr) {
    try {
      // Remove spaces
      String cleaned = valueStr.trim();

      // Replace thousand separators (.) and decimal separator (,) with standard format
      // "1.234,50" -> "1234.50"
      cleaned = cleaned.replaceAll('.', ''); // Remove thousand separator
      cleaned = cleaned.replaceAll(',', '.'); // Replace decimal separator

      return double.tryParse(cleaned);
    } catch (e) {
      return null;
    }
  }
}
