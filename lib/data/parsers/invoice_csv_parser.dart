import 'package:csv/csv.dart';

import '../../domain/models/invoice_csv_parse_result.dart';
import '../../domain/models/parsed_invoice_row.dart';

/// Parses invoice CSV exports shaped like:
/// `Cartão,Título,Valor,Parcelas,Data,Categoria`
/// e.g. `Nubank,Uber,"R$ 99,88",8/12,12/12/2025,Transporte`
///
/// Rows that fail to parse are collected into [InvoiceCsvParseResult.errors]
/// rather than aborting the whole file.
class InvoiceCsvParser {
  static const _expectedColumnCount = 6;

  InvoiceCsvParseResult parse(String csvContent) {
    final table = const CsvToListConverter(shouldParseNumbers: false)
        .convert(csvContent, eol: '\n');

    final rows = <ParsedInvoiceRow>[];
    final errors = <String>[];

    for (var i = 1; i < table.length; i++) {
      final lineNumber = i + 1;
      final fields = table[i];
      if (fields.length == 1 && (fields[0] as String).trim().isEmpty) {
        continue;
      }
      if (fields.length != _expectedColumnCount) {
        errors.add(
          'Linha $lineNumber: esperado $_expectedColumnCount colunas, encontrado ${fields.length}',
        );
        continue;
      }

      final cardName = (fields[0] as String).trim();
      final description = (fields[1] as String).trim();
      final valueStr = (fields[2] as String).trim();
      final installmentsStr = (fields[3] as String).trim();
      final dateStr = (fields[4] as String).trim();
      final categoryName = (fields[5] as String).trim();

      final value = _parseValue(valueStr);
      if (value == null) {
        errors.add('Linha $lineNumber: valor inválido "$valueStr"');
        continue;
      }

      final installments = _parseInstallments(installmentsStr);
      if (installments == null) {
        errors.add('Linha $lineNumber: parcelas inválidas "$installmentsStr"');
        continue;
      }

      final date = _parseDate(dateStr);
      if (date == null) {
        errors.add('Linha $lineNumber: data inválida "$dateStr"');
        continue;
      }

      rows.add(ParsedInvoiceRow(
        cardName: cardName,
        description: description,
        value: value,
        currentInstallment: installments.$1,
        totalInstallments: installments.$2,
        date: date,
        categoryName: categoryName,
      ));
    }

    return InvoiceCsvParseResult(rows: rows, errors: errors);
  }

  /// Parse a Brazilian currency string, e.g. `"R$ 1.234,50"` -> `1234.50`.
  static double? _parseValue(String valueStr) {
    try {
      var cleaned = valueStr.trim();
      cleaned = cleaned.replaceFirst('R\$', '').trim();
      cleaned = cleaned.replaceAll('.', ''); // Remove thousand separator
      cleaned = cleaned.replaceAll(',', '.'); // Replace decimal separator

      return double.tryParse(cleaned);
    } catch (e) {
      return null;
    }
  }

  /// Parse `current/total` installment notation, e.g. `"8/12"` -> `(8, 12)`.
  static (int, int)? _parseInstallments(String installmentsStr) {
    final parts = installmentsStr.split('/');
    if (parts.length != 2) return null;

    final current = int.tryParse(parts[0].trim());
    final total = int.tryParse(parts[1].trim());
    if (current == null || total == null) return null;
    if (current < 1 || total < 1 || current > total) return null;

    return (current, total);
  }

  /// Parse a strict `dd/MM/yyyy` date, avoiding locale-dependent DateFormat.
  static DateTime? _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    try {
      final date = DateTime(year, month, day);
      if (date.day != day || date.month != month || date.year != year) {
        return null;
      }
      return date;
    } catch (e) {
      return null;
    }
  }
}
