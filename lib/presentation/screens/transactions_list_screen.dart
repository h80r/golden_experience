import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/usecases/providers/usecase_providers.dart';
import '../state/dashboard_view_notifier.dart';
import '../state/expense_form_notifier.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/common/standard_app_bar.dart';
import '../widgets/expense/expense_details_bottom_sheet.dart';
import '../widgets/transactions/transaction_card.dart';
import '../widgets/transactions/transaction_filters_sheet.dart';

/// Provider for watching all accounts
final accountsStreamProvider = StreamProvider.autoDispose(
  (ref) => ref.read(accountRepositoryProvider).watchAll(),
);

/// Provider for watching all categories
final categoriesStreamProvider = StreamProvider.autoDispose(
  (ref) => ref.read(categoryRepositoryProvider).watchAll(),
);

/// Provider for watching all transactions
final transactionsStreamProvider = StreamProvider.autoDispose(
  (ref) => ref.read(transactionRepositoryProvider).watchAll(),
);

/// TransactionsListScreen - Complete transaction list with CRUD operations
///
/// Features:
/// - Display all transactions in a scrollable list
/// - Filter by period (today, week, month, custom)
/// - Filter by account and category
/// - Edit transactions (swipe or menu)
/// - Delete transactions (swipe or menu)
/// - Empty state when no transactions
class TransactionsListScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBackPressed;

  const TransactionsListScreen({
    super.key,
    this.onBackPressed,
  });

  @override
  ConsumerState<TransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends ConsumerState<TransactionsListScreen> {
  FilterPeriod _filterPeriod = FilterPeriod.thisMonth;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  Set<int> _selectedAccountIds = {};
  Set<int> _selectedCategoryIds = {};

  /// Scroll controller to detect scrolling and dismiss pending toast
  final ScrollController _scrollController = ScrollController();

  /// Completer to control confirmDismiss resolution
  Completer<bool>? _pendingDismissCompleter;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Transações',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use the provider to go back to dashboard
            ref.read(dashboardViewProvider.notifier).showDashboard();
          },
        ),
        showSettings: false,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              accountsAsync.whenData((accounts) {
                categoriesAsync.whenData((categories) {
                  _showFiltersSheet(
                    accounts.map((a) => (id: a.id, name: a.name)).toList(),
                    categories.map((c) => (id: c.id, name: c.name)).toList(),
                  );
                });
              });
            },
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: transactionsAsync.when(
        data: (transactions) {
          // Get date range
          final dateRange = _getDateRange();

          // Filter transactions by date
          final filteredByDate = transactions.where((t) {
            return t.date.isAfter(dateRange.start) &&
                t.date.isBefore(dateRange.end);
          }).toList();

          // Filter by accounts
          List filteredByAccount = filteredByDate;
          if (_selectedAccountIds.isNotEmpty) {
            filteredByAccount = filteredByDate
                .where((t) => _selectedAccountIds.contains(t.accountId))
                .toList();
          }

          // Filter by categories
          List filteredByCategory = filteredByAccount;
          if (_selectedCategoryIds.isNotEmpty) {
            filteredByCategory = filteredByAccount
                .where((t) => _selectedCategoryIds.contains(t.categoryId))
                .toList();
          }

          // Sort by date (newest first)
          filteredByCategory.sort((a, b) => b.date.compareTo(a.date));

          // Get accounts and categories for mapping
          return accountsAsync.when(
            data: (accounts) {
              return categoriesAsync.when(
                data: (categories) {
                  final accountsMap = {
                    for (var account in accounts) account.id: account.name
                  };
                  final categoriesMap = {
                    for (var category in categories) category.id: category.name
                  };

                  if (filteredByCategory.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Nenhuma transação encontrada',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Tente ajustar os filtros',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      // Tapping anywhere on the list closes the undo snackbar and executes deletion
                      _dismissPendingToast();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: filteredByCategory.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredByCategory[index];
                        final cardData = TransactionCardData(
                          id: transaction.id,
                          value: transaction.value,
                          description: transaction.description,
                          date: transaction.date,
                          accountId: transaction.accountId,
                          accountName: accountsMap[transaction.accountId] ??
                              'Desconhecida',
                          categoryId: transaction.categoryId,
                          categoryName: categoriesMap[transaction.categoryId] ??
                              'Sem categoria',
                          notes: transaction.notes,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Dismissible(
                            key: Key(transaction.id.toString()),
                            // Only allow swipe from right to left (delete)
                            direction: DismissDirection.endToStart,
                            background: Container(),
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.only(right: AppSpacing.lg),
                              child: const Icon(
                                Icons.delete,
                                color: AppColors.background,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await _handleDismissConfirmation(
                                  cardData, index);
                            },
                            child: TransactionCard(
                              transaction: cardData,
                              onTap: () {
                                // Dismiss any pending toast before opening edit sheet
                                _dismissPendingToast();
                                _handleEditTransaction(
                                  cardData,
                                  accountsMap,
                                  categoriesMap,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Erro ao carregar categorias: $error'),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Erro ao carregar contas: $error'),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 48.0,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Erro ao carregar transações: $error'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Complete any pending dismiss with true (proceed with deletion)
    _pendingDismissCompleter?.complete(true);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Listen to scroll events to dismiss pending toast
    _scrollController.addListener(_onScroll);
  }

  /// Dismiss pending toast and trigger deletion
  void _dismissPendingToast() {
    if (_pendingDismissCompleter != null &&
        !_pendingDismissCompleter!.isCompleted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _pendingDismissCompleter!.complete(true);
    }
  }

  /// Execute the actual deletion from database
  Future<void> _executeDelete(TransactionCardData transaction) async {
    final deleteTransactionUseCase = ref.read(deleteTransactionUseCaseProvider);

    final result = await deleteTransactionUseCase.execute(
      id: transaction.id,
    );

    if (!mounted) return;

    if (!result.success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Erro ao deletar transação'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Get date range based on selected filter period
  ({DateTime start, DateTime end}) _getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_filterPeriod) {
      case FilterPeriod.today:
        return (start: today, end: today.add(const Duration(days: 1)));
      case FilterPeriod.thisWeek:
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        final daysToEndOfWeek = 8 - today.weekday;
        return (
          start: weekStart,
          end: today.add(Duration(days: daysToEndOfWeek))
        );
      case FilterPeriod.thisMonth:
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1);
        return (start: monthStart, end: monthEnd);
      case FilterPeriod.custom:
        return (
          start: _customStartDate ?? today,
          end: _customEndDate?.add(const Duration(days: 1)) ?? today
        );
    }
  }

  /// Handle dismiss confirmation - called by Dismissible.confirmDismiss
  /// Returns a Future that resolves to bool based on user action
  Future<bool> _handleDismissConfirmation(
      TransactionCardData transaction, int index) async {
    // Dismiss any existing toast first
    _dismissPendingToast();

    // Create new completer for this dismissal
    _pendingDismissCompleter = Completer<bool>();

    // Show undo toast
    _showUndoToast(transaction);

    // Wait for user decision (undo or confirm)
    final shouldDelete = await _pendingDismissCompleter!.future;

    // If confirmed, execute deletion
    if (shouldDelete) {
      await _executeDelete(transaction);
    }

    // Reset state
    _pendingDismissCompleter = null;

    return shouldDelete;
  }

  void _handleEditTransaction(
    TransactionCardData transaction,
    Map<int, String> accountsMap,
    Map<int, String> categoriesMap,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ExpenseDetailsBottomSheet(
        accounts: accountsMap,
        categories: categoriesMap,
        initialValue: transaction.value,
        initialDescription: transaction.description,
        initialNotes: transaction.notes,
        initialAccountId: transaction.accountId,
        initialCategoryId: transaction.categoryId,
        initialDate: transaction.date,
        isEditMode: true,
        onSave: ({
          required value,
          required description,
          required notes,
          required accountId,
          required transactionType,
          required categoryId,
          required date,
        }) async {
          final updateTransactionUseCase =
              ref.read(updateTransactionUseCaseProvider);

          final result = await updateTransactionUseCase.execute(
            id: transaction.id,
            value: value,
            description: description,
            date: date,
            accountId: accountId,
            categoryId: categoryId,
            notes: notes,
          );

          if (!context.mounted) return;

          ref.read(expenseFormProvider.notifier).reset();
          Navigator.of(context).pop();

          if (result.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transação atualizada com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(result.errorMessage ?? 'Erro ao atualizar transação'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        onCancel: () {
          Navigator.of(context).pop();
          ref.read(expenseFormProvider.notifier).reset();
        },
      ),
    );
  }

  /// Called when user scrolls the list
  void _onScroll() {
    if (_pendingDismissCompleter != null &&
        !_pendingDismissCompleter!.isCompleted) {
      _dismissPendingToast();
    }
  }

  void _showFiltersSheet(
    List<({int id, String name})> accounts,
    List<({int id, String name})> categories,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TransactionFiltersSheet(
        accounts: accounts,
        categories: categories,
        initialPeriod: _filterPeriod,
        initialCustomStartDate: _customStartDate,
        initialCustomEndDate: _customEndDate,
        initialSelectedAccountIds: _selectedAccountIds,
        initialSelectedCategoryIds: _selectedCategoryIds,
        onFiltersChanged: ({
          required period,
          required customStartDate,
          required customEndDate,
          required selectedAccountIds,
          required selectedCategoryIds,
        }) {
          setState(() {
            _filterPeriod = period;
            _customStartDate = customStartDate;
            _customEndDate = customEndDate;
            _selectedAccountIds = selectedAccountIds;
            _selectedCategoryIds = selectedCategoryIds;
          });
        },
      ),
    );
  }

  /// Show undo toast with action button
  void _showUndoToast(TransactionCardData transaction) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger
        .showSnackBar(
          SnackBar(
            content: const Text('Transação excluída'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                // Complete with false to keep item in list
                if (_pendingDismissCompleter != null &&
                    !_pendingDismissCompleter!.isCompleted) {
                  _pendingDismissCompleter!.complete(false);
                }
              },
            ),
            // Duration indefinite - only closes when user interacts elsewhere or clicks action
            duration: const Duration(days: 365),
            behavior: SnackBarBehavior.floating,
            dismissDirection:
                DismissDirection.none, // Don't allow swipe to close
          ),
        )
        .closed
        .then((reason) {
      // Execute deletion only if SnackBar closed NOT by action (undo)
      if (reason != SnackBarClosedReason.action) {
        if (_pendingDismissCompleter != null &&
            !_pendingDismissCompleter!.isCompleted) {
          _pendingDismissCompleter!.complete(true);
        }
      }
    });
  }
}
