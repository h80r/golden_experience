import 'parsed_invoice_row.dart';

/// Result of parsing an invoice CSV file: successfully parsed rows plus
/// human-readable errors (including line number) for rows that failed to
/// parse, so a malformed row doesn't abort the whole file.
class InvoiceCsvParseResult {
  final List<ParsedInvoiceRow> rows;
  final List<String> errors;

  const InvoiceCsvParseResult({
    required this.rows,
    required this.errors,
  });
}
