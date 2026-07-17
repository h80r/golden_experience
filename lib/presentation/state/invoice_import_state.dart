import '../../domain/models/parsed_invoice_row.dart';

enum InvoiceImportStep { pickFile, mapping, review, importing, done }

/// State for the invoice CSV import wizard.
class InvoiceImportState {
  final InvoiceImportStep step;
  final List<ParsedInvoiceRow> rows;
  final Map<String, int> cardToAccountId;
  final Map<String, int> categoryToCategoryId;
  final Set<int> excludedRowIndexes;
  final List<String> parseErrors;
  final String? commitError;

  const InvoiceImportState({
    required this.step,
    required this.rows,
    required this.cardToAccountId,
    required this.categoryToCategoryId,
    required this.excludedRowIndexes,
    required this.parseErrors,
    this.commitError,
  });

  factory InvoiceImportState.initial() => const InvoiceImportState(
        step: InvoiceImportStep.pickFile,
        rows: [],
        cardToAccountId: {},
        categoryToCategoryId: {},
        excludedRowIndexes: {},
        parseErrors: [],
        commitError: null,
      );

  List<String> get distinctCardNames =>
      rows.map((r) => r.cardName).toSet().toList();

  List<String> get distinctCategoryNames =>
      rows.map((r) => r.categoryName).toSet().toList();

  bool get isFullyMapped =>
      distinctCardNames.every(cardToAccountId.containsKey) &&
      distinctCategoryNames.every(categoryToCategoryId.containsKey);

  InvoiceImportState copyWith({
    InvoiceImportStep? step,
    List<ParsedInvoiceRow>? rows,
    Map<String, int>? cardToAccountId,
    Map<String, int>? categoryToCategoryId,
    Set<int>? excludedRowIndexes,
    List<String>? parseErrors,
    String? commitError,
  }) {
    return InvoiceImportState(
      step: step ?? this.step,
      rows: rows ?? this.rows,
      cardToAccountId: cardToAccountId ?? this.cardToAccountId,
      categoryToCategoryId: categoryToCategoryId ?? this.categoryToCategoryId,
      excludedRowIndexes: excludedRowIndexes ?? this.excludedRowIndexes,
      parseErrors: parseErrors ?? this.parseErrors,
      commitError: commitError ?? this.commitError,
    );
  }
}
