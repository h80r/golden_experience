/// Model representing transaction data extracted from bank notifications
/// Used to pass pre-filled transaction information to the expense form
class TransactionData {
  final double value;
  final String description;
  final DateTime date;
  final String? sourceBank;
  final String? notes;

  const TransactionData({
    required this.value,
    required this.description,
    required this.date,
    this.sourceBank,
    this.notes,
  });

  /// Convert to JSON for notification payload
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'description': description,
      'date': date.toIso8601String(),
      'sourceBank': sourceBank,
      'notes': notes,
    };
  }

  /// Create from JSON (for loading from notification payload)
  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      value: (json['value'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      sourceBank: json['sourceBank'] as String?,
      notes: json['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'TransactionData(value: $value, description: $description, date: $date, sourceBank: $sourceBank, notes: $notes)';
  }
}
