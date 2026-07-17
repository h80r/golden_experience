import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/providers/repository_providers.dart';
import 'package:golden_experience/domain/models/parsed_invoice_row.dart';
import 'package:golden_experience/domain/repositories/i_account_repository.dart';
import 'package:golden_experience/domain/repositories/i_category_repository.dart';
import 'package:golden_experience/presentation/screens/invoice_import_screen.dart';
import 'package:golden_experience/presentation/state/invoice_import_notifier.dart';
import 'package:golden_experience/presentation/state/invoice_import_state.dart';

class FakeAccountRepository implements IAccountRepository {
  final List<AccountModel> accounts;

  FakeAccountRepository(this.accounts);

  @override
  Future<List<AccountModel>> getAll() async => accounts;

  @override
  Future<int> create(Insertable<AccountModel> account) =>
      throw UnimplementedError();
  @override
  Future<AccountModel?> getById(int id) => throw UnimplementedError();
  @override
  Future<bool> update(Insertable<AccountModel> account) =>
      throw UnimplementedError();
  @override
  Future<bool> updateBalance(int accountId, double newBalance) =>
      throw UnimplementedError();
  @override
  Future<bool> updateCreditLimit(int accountId, double newLimit) =>
      throw UnimplementedError();
  @override
  Future<bool> updateCreditUsed(int accountId, double newCreditUsed) =>
      throw UnimplementedError();
  @override
  Future<bool> delete(int id) => throw UnimplementedError();
  @override
  Future<bool> hasTransactions(int accountId) => throw UnimplementedError();
  @override
  Stream<List<AccountModel>> watchAll() => throw UnimplementedError();
  @override
  Future<AccountModel?> getDefaultAccount() => throw UnimplementedError();
  @override
  Future<bool> setDefaultAccount(int accountId) => throw UnimplementedError();
  @override
  Future<bool> clearDefaultAccount() => throw UnimplementedError();
}

class FakeCategoryRepository implements ICategoryRepository {
  final List<CategoryModel> categories;

  FakeCategoryRepository(this.categories);

  @override
  Future<List<CategoryModel>> getAll() async => categories;

  @override
  Future<int> create(Insertable<CategoryModel> category) =>
      throw UnimplementedError();
  @override
  Future<CategoryModel?> getById(int id) => throw UnimplementedError();
  @override
  Future<bool> update(Insertable<CategoryModel> category) =>
      throw UnimplementedError();
  @override
  Future<bool> delete(int id) => throw UnimplementedError();
  @override
  Future<bool> deleteIfUnused(int id) => throw UnimplementedError();
  @override
  Future<bool> setDefaultCategory(int id) => throw UnimplementedError();
  @override
  Future<CategoryModel?> getDefaultCategory() => throw UnimplementedError();
  @override
  Future<void> seedDefaultCategories() => throw UnimplementedError();
  @override
  Stream<List<CategoryModel>> watchAll() => throw UnimplementedError();
}

AccountModel _account(int id, String name, {bool isCredit = true}) {
  return AccountModel(
    id: id,
    name: name,
    isDebit: false,
    isCredit: isCredit,
    balance: 0,
    creditLimit: 1000,
    creditUsed: 0,
    isDefault: false,
    creditPaymentDay: 10,
    excludeFromReserve: false,
  );
}

CategoryModel _category(int id, String name) {
  return CategoryModel(id: id, name: name, isDefault: false);
}

class _FixedInvoiceImportNotifier extends InvoiceImportNotifier {
  final InvoiceImportState initialState;

  _FixedInvoiceImportNotifier(this.initialState);

  @override
  InvoiceImportState build() => initialState;
}

ParsedInvoiceRow _row({
  String cardName = 'Nubank',
  String description = 'Uber',
  double value = 24.93,
  int currentInstallment = 1,
  int totalInstallments = 1,
  String categoryName = 'Transporte',
}) {
  return ParsedInvoiceRow(
    cardName: cardName,
    description: description,
    value: value,
    currentInstallment: currentInstallment,
    totalInstallments: totalInstallments,
    date: DateTime(2026, 7, 14),
    categoryName: categoryName,
  );
}

void main() {
  group('InvoiceImportScreen - mapping step', () {
    testWidgets('Avançar is disabled until all cards and categories are mapped',
        (WidgetTester tester) async {
      final accountRepo = FakeAccountRepository([_account(1, 'Conta Nubank')]);
      final categoryRepo = FakeCategoryRepository([_category(1, 'Transporte')]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountRepositoryProvider.overrideWithValue(accountRepo),
            categoryRepositoryProvider.overrideWithValue(categoryRepo),
            invoiceImportProvider.overrideWith(
              () => _FixedInvoiceImportNotifier(InvoiceImportState(
                step: InvoiceImportStep.mapping,
                rows: [_row(cardName: 'Nubank', categoryName: 'Transporte')],
                cardToAccountId: const {},
                categoryToCategoryId: const {},
                excludedRowIndexes: const {},
                parseErrors: const [],
              )),
            ),
          ],
          child: const MaterialApp(home: InvoiceImportScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Avançar'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Avançar is enabled once every card and category is mapped',
        (WidgetTester tester) async {
      final accountRepo = FakeAccountRepository([_account(1, 'Conta Nubank')]);
      final categoryRepo = FakeCategoryRepository([_category(1, 'Transporte')]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountRepositoryProvider.overrideWithValue(accountRepo),
            categoryRepositoryProvider.overrideWithValue(categoryRepo),
            invoiceImportProvider.overrideWith(
              () => _FixedInvoiceImportNotifier(InvoiceImportState(
                step: InvoiceImportStep.mapping,
                rows: [_row(cardName: 'Nubank', categoryName: 'Transporte')],
                cardToAccountId: const {'Nubank': 1},
                categoryToCategoryId: const {'Transporte': 1},
                excludedRowIndexes: const {},
                parseErrors: const [],
              )),
            ),
          ],
          child: const MaterialApp(home: InvoiceImportScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Avançar'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
  });

  group('InvoiceImportScreen - review step', () {
    testWidgets('excluding a row updates the running total',
        (WidgetTester tester) async {
      final accountRepo = FakeAccountRepository([_account(1, 'Conta Nubank')]);
      final categoryRepo = FakeCategoryRepository([_category(1, 'Transporte')]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountRepositoryProvider.overrideWithValue(accountRepo),
            categoryRepositoryProvider.overrideWithValue(categoryRepo),
            invoiceImportProvider.overrideWith(
              () => _FixedInvoiceImportNotifier(InvoiceImportState(
                step: InvoiceImportStep.review,
                rows: [
                  _row(description: 'Uber', value: 20.0),
                  _row(description: 'Netflix', value: 30.0),
                ],
                cardToAccountId: const {'Nubank': 1},
                categoryToCategoryId: const {'Transporte': 1},
                excludedRowIndexes: const {},
                parseErrors: const [],
              )),
            ),
          ],
          child: const MaterialApp(home: InvoiceImportScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 de 2 transações'), findsOneWidget);
      expect(find.text('R\$ \u00A050,00'), findsOneWidget);

      await tester.tap(find.text('Uber'));
      await tester.pumpAndSettle();

      expect(find.text('1 de 2 transações'), findsOneWidget);
      // R\$ 30,00 now appears both in the header total and Netflix's own
      // row value, since Netflix (30.0) is the only remaining row.
      expect(find.text('R\$ \u00A030,00'), findsNWidgets(2));
    });
  });
}
