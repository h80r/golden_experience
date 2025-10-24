import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/local_database.dart';
import '../../data/providers/repository_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/common/standard_app_bar.dart';
import '../widgets/recurring/recurring_expense_form_bottom_sheet.dart';

/// RecurringExpensesScreen - Screen for managing recurring expenses
class RecurringExpensesScreen extends ConsumerWidget {
  const RecurringExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringExpenseRepository =
        ref.watch(recurringExpenseRepositoryProvider);

    return Scaffold(
      appBar: const StandardAppBar(title: 'Recorrências'),
      body: StreamBuilder<List<RecurringExpenseModel>>(
        stream: recurringExpenseRepository.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar recorrências',
                style: AppTypography.bodyMedium,
              ),
            );
          }

          final recurringExpenses = snapshot.data ?? [];

          if (recurringExpenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Nenhuma recorrência cadastrada',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Crie uma nova recorrência para começar',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: recurringExpenses.length,
            itemBuilder: (context, index) {
              final expense = recurringExpenses[index];
              return _buildRecurringExpenseCard(context, ref, expense);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRecurringExpenseFormBottomSheet(context, null);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        heroTag: 'recurring_fab',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecurringExpenseCard(
    BuildContext context,
    WidgetRef ref,
    RecurringExpenseModel expense,
  ) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        side: const BorderSide(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.description,
                        style: AppTypography.headlineSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.infoWithOpacity,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSmall),
                        ),
                        child: Text(
                          'Dia ${expense.chargeDay}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCurrency(expense.value),
                      style: AppTypography.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Mensal',
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(
              color: AppColors.divider,
              height: 1,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _showRecurringExpenseFormBottomSheet(context, expense);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(context, ref, expense);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Remover'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  Future<void> _handleDeleteRecurringExpense(
    BuildContext context,
    WidgetRef ref,
    RecurringExpenseModel expense,
  ) async {
    final recurringExpenseRepository =
        ref.read(recurringExpenseRepositoryProvider);

    try {
      final success = await recurringExpenseRepository.delete(expense.id);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Recorrência removida com sucesso',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao remover recorrência',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: $e',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.background,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    RecurringExpenseModel expense,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Remover Recorrência',
          style: AppTypography.headlineSmall,
        ),
        content: Text(
          'Tem certeza que deseja remover "${expense.description}"?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleDeleteRecurringExpense(context, ref, expense);
            },
            child: Text(
              'Remover',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecurringExpenseFormBottomSheet(
    BuildContext context,
    RecurringExpenseModel? expense,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      builder: (context) => RecurringExpenseFormBottomSheet(expense: expense),
    );
  }
}
