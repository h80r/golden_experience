import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/billing_cycle_utils.dart';
import '../../data/datasources/local_database.dart';
import '../../data/parsers/invoice_csv_parser.dart';
import '../../data/providers/repository_providers.dart';
import 'invoice_import_state.dart';

part 'invoice_import_notifier.g.dart';

/// Notifier driving the invoice CSV import wizard:
/// pick file -> map card/category names -> review rows -> commit.
@riverpod
class InvoiceImportNotifier extends _$InvoiceImportNotifier {
  @override
  InvoiceImportState build() => InvoiceImportState.initial();

  /// Parses [csvContent] and moves to the mapping step, pre-filling
  /// category mappings for exact name matches against existing categories.
  Future<void> loadCsv(String csvContent) async {
    final result = InvoiceCsvParser().parse(csvContent);

    final categoryToCategoryId = <String, int>{};
    if (result.rows.isNotEmpty) {
      final categories = await ref.read(categoryRepositoryProvider).getAll();
      final categoryIdByName = {
        for (final category in categories) category.name: category.id,
      };
      for (final categoryName
          in result.rows.map((r) => r.categoryName).toSet()) {
        final matchId = categoryIdByName[categoryName];
        if (matchId != null) {
          categoryToCategoryId[categoryName] = matchId;
        }
      }
    }

    state = state.copyWith(
      step: InvoiceImportStep.mapping,
      rows: result.rows,
      parseErrors: result.errors,
      categoryToCategoryId: categoryToCategoryId,
    );
  }

  /// Maps a distinct `Cartão` value to an existing credit-capable account.
  void mapCardToAccount(String cardName, int accountId) {
    state = state.copyWith(
      cardToAccountId: {...state.cardToAccountId, cardName: accountId},
    );
  }

  /// Maps a distinct `Categoria` value to an existing category.
  void mapCategoryToCategory(String categoryName, int categoryId) {
    state = state.copyWith(
      categoryToCategoryId: {
        ...state.categoryToCategoryId,
        categoryName: categoryId,
      },
    );
  }

  /// Advances from `mapping` to `review`. No-ops if mapping is incomplete.
  void confirmMapping() {
    if (!state.isFullyMapped) return;
    state = state.copyWith(step: InvoiceImportStep.review);
  }

  /// Toggles whether the row at [index] is excluded from the commit.
  void toggleRowExcluded(int index) {
    final excluded = {...state.excludedRowIndexes};
    if (!excluded.remove(index)) {
      excluded.add(index);
    }
    state = state.copyWith(excludedRowIndexes: excluded);
  }

  /// Commits every non-excluded row: single-installment rows use the plain
  /// create path, multi-installment rows reuse `createInstallmentTransactions`,
  /// and only the current installment's value is applied to the account's
  /// `creditUsed` in both cases. The whole batch commits atomically.
  Future<void> commit() async {
    state = InvoiceImportState(
      step: InvoiceImportStep.importing,
      rows: state.rows,
      cardToAccountId: state.cardToAccountId,
      categoryToCategoryId: state.categoryToCategoryId,
      excludedRowIndexes: state.excludedRowIndexes,
      parseErrors: state.parseErrors,
      commitError: null,
    );

    final transactionRepository = ref.read(transactionRepositoryProvider);
    final accountRepository = ref.read(accountRepositoryProvider);

    try {
      await LocalDatabase.instance.transaction(() async {
        for (var i = 0; i < state.rows.length; i++) {
          if (state.excludedRowIndexes.contains(i)) continue;

          final row = state.rows[i];
          final accountId = state.cardToAccountId[row.cardName]!;
          final categoryId = state.categoryToCategoryId[row.categoryName]!;

          final accountBeforeInsert =
              await accountRepository.getById(accountId);

          // Invoice CSV exports carry the date the bill-aggregator generated
          // the export, not the current installment's actual billing date —
          // it's the same value across unrelated rows and installment
          // numbers. Every imported row is always for the current invoice
          // (never historical), so the current installment always belongs
          // in the account's billing cycle as of today.
          final adjustedDate = calculateCurrentBillingCycleFromPaymentDay(
            accountBeforeInsert!.creditPaymentDay!,
          ).start;

          if (row.totalInstallments > 1) {
            await transactionRepository.createInstallmentTransactions(
              transaction: TransactionModelCompanion.insert(
                value: row.value,
                description: row.description,
                date: adjustedDate,
                accountId: accountId,
                categoryId: categoryId,
                transactionType: const Value('credit'),
              ),
              currentInstallment: row.currentInstallment,
              totalInstallments: row.totalInstallments,
              accountId: accountId,
            );
          } else {
            await transactionRepository.create(
              TransactionModelCompanion.insert(
                value: row.value,
                description: row.description,
                date: adjustedDate,
                accountId: accountId,
                categoryId: categoryId,
                transactionType: const Value('credit'),
              ),
            );
          }

          final accountAfterInsert = await accountRepository.getById(accountId);
          await accountRepository.updateCreditUsed(
            accountId,
            accountAfterInsert!.creditUsed + row.value,
          );
        }
      });

      state = InvoiceImportState(
        step: InvoiceImportStep.done,
        rows: state.rows,
        cardToAccountId: state.cardToAccountId,
        categoryToCategoryId: state.categoryToCategoryId,
        excludedRowIndexes: state.excludedRowIndexes,
        parseErrors: state.parseErrors,
        commitError: null,
      );
    } catch (e) {
      state = InvoiceImportState(
        step: InvoiceImportStep.review,
        rows: state.rows,
        cardToAccountId: state.cardToAccountId,
        categoryToCategoryId: state.categoryToCategoryId,
        excludedRowIndexes: state.excludedRowIndexes,
        parseErrors: state.parseErrors,
        commitError: 'Nenhuma alteração foi salva. Erro: $e',
      );
    }
  }
}
