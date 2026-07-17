import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/parsers/invoice_csv_parser.dart';

void main() {
  group('InvoiceCsvParser', () {
    final parser = InvoiceCsvParser();
    const header = 'Cartão,Título,Valor,Parcelas,Data,Categoria';

    group('well-formed rows', () {
      test('parses a standard row', () {
        final result = parser.parse(
          '$header\nNubank,Uber,"R\$ 24,93",1/1,14/07/2026,Transporte',
        );

        expect(result.errors, isEmpty);
        expect(result.rows, hasLength(1));

        final row = result.rows.single;
        expect(row.cardName, 'Nubank');
        expect(row.description, 'Uber');
        expect(row.value, 24.93);
        expect(row.currentInstallment, 1);
        expect(row.totalInstallments, 1);
        expect(row.date, DateTime(2026, 7, 14));
        expect(row.categoryName, 'Transporte');
      });

      test('parses multiple rows', () {
        final result = parser.parse('''
$header
Nubank,Uber,"R\$ 24,93",1/1,14/07/2026,Transporte
Santander,Netflix,"R\$ 39,90",1/1,05/07/2026,Lazer
''');

        expect(result.errors, isEmpty);
        expect(result.rows, hasLength(2));
      });
    });

    group('thousands-separator values', () {
      test('parses a value with a thousands separator', () {
        final result = parser.parse(
          '$header\nNubank,Notebook,"R\$ 1.234,56",1/1,01/01/2026,Outros',
        );

        expect(result.errors, isEmpty);
        expect(result.rows.single.value, 1234.56);
      });

      test('parses a value with multiple thousands separators', () {
        final result = parser.parse(
          '$header\nNubank,Carro,"R\$ 12.345.678,90",1/1,01/01/2026,Outros',
        );

        expect(result.errors, isEmpty);
        expect(result.rows.single.value, 12345678.90);
      });
    });

    group('single-installment rows', () {
      test('parses "1/1" as current=1, total=1', () {
        final result = parser.parse(
          '$header\nNubank,Farmacia,"R\$ 29,52",1/1,12/07/2026,Saúde',
        );

        expect(result.errors, isEmpty);
        expect(result.rows.single.currentInstallment, 1);
        expect(result.rows.single.totalInstallments, 1);
      });
    });

    group('multi-installment rows', () {
      test('parses "8/12" as current=8, total=12', () {
        final result = parser.parse(
          '$header\nMercado Pago,Compra Mercado Livre,"R\$ 99,88",8/12,12/12/2025,Outros',
        );

        expect(result.errors, isEmpty);
        final row = result.rows.single;
        expect(row.currentInstallment, 8);
        expect(row.totalInstallments, 12);
      });
    });

    group('malformed rows', () {
      test('collects an error for a bad date', () {
        final result = parser.parse(
          '$header\nNubank,Uber,"R\$ 24,93",1/1,32/13/2026,Transporte',
        );

        expect(result.rows, isEmpty);
        expect(result.errors, hasLength(1));
        expect(result.errors.single, contains('Linha 2'));
      });

      test('collects an error for a bad value', () {
        final result = parser.parse(
          '$header\nNubank,Uber,"não é dinheiro",1/1,14/07/2026,Transporte',
        );

        expect(result.rows, isEmpty);
        expect(result.errors, hasLength(1));
      });

      test('collects an error for bad installments', () {
        final result = parser.parse(
          '$header\nNubank,Uber,"R\$ 24,93",abc,14/07/2026,Transporte',
        );

        expect(result.rows, isEmpty);
        expect(result.errors, hasLength(1));
      });

      test('collects an error when current installment exceeds total', () {
        final result = parser.parse(
          '$header\nNubank,Uber,"R\$ 24,93",5/3,14/07/2026,Transporte',
        );

        expect(result.rows, isEmpty);
        expect(result.errors, hasLength(1));
      });

      test('a malformed row does not prevent parsing of valid rows', () {
        final result = parser.parse('''
$header
Nubank,Uber,"R\$ 24,93",1/1,14/07/2026,Transporte
Nubank,Bad Row,"R\$ 24,93",1/1,32/13/2026,Transporte
Santander,Netflix,"R\$ 39,90",1/1,05/07/2026,Lazer
''');

        expect(result.rows, hasLength(2));
        expect(result.errors, hasLength(1));
      });
    });
  });
}
