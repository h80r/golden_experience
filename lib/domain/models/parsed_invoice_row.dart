/// A single row parsed from an invoice CSV export, before card/category
/// resolution against the user's existing Accounts/Categories.
class ParsedInvoiceRow {
  final String cardName;
  final String description;
  final double value;
  final int currentInstallment;
  final int totalInstallments;
  final DateTime date;
  final String categoryName;

  const ParsedInvoiceRow({
    required this.cardName,
    required this.description,
    required this.value,
    required this.currentInstallment,
    required this.totalInstallments,
    required this.date,
    required this.categoryName,
  });

  @override
  String toString() {
    return 'ParsedInvoiceRow(cardName: $cardName, description: $description, '
        'value: $value, currentInstallment: $currentInstallment, '
        'totalInstallments: $totalInstallments, date: $date, '
        'categoryName: $categoryName)';
  }
}
