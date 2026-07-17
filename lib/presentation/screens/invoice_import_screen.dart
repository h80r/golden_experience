import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/text_formatters.dart';
import '../../data/datasources/local_database.dart';
import '../../data/providers/repository_providers.dart';
import '../state/invoice_import_notifier.dart';
import '../state/invoice_import_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/common/standard_app_bar.dart';
import '../widgets/inputs/custom_dropdown.dart';

/// Guided wizard to import a credit-card invoice CSV export into
/// Golden Experience, resolving each row's card/category to existing
/// Accounts/Categories and batch-creating the transactions.
class InvoiceImportScreen extends ConsumerWidget {
  const InvoiceImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceImportProvider);

    ref.listen(invoiceImportProvider, (previous, next) {
      if (next.step == InvoiceImportStep.done &&
          previous?.step != InvoiceImportStep.done) {
        final count = next.rows.length - next.excludedRowIndexes.length;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$count transações importadas com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (next.commitError != null &&
          next.commitError != previous?.commitError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.commitError!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: const StandardAppBar(
        title: 'Importar Fatura CSV',
        showSettings: false,
      ),
      body: SafeArea(
        child: switch (state.step) {
          InvoiceImportStep.pickFile => _PickFileStep(),
          InvoiceImportStep.mapping => const _MappingStep(),
          InvoiceImportStep.review => const _ReviewStep(),
          InvoiceImportStep.importing => const Center(
              child: CircularProgressIndicator(),
            ),
          InvoiceImportStep.done => const _DoneStep(),
        },
      ),
    );
  }
}

class _PickFileStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceImportProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload_file_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Selecione o arquivo CSV da fatura',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'O arquivo deve conter as colunas Cartão, Título, Valor, '
            'Parcelas, Data e Categoria',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (state.parseErrors.isNotEmpty) ...[
            _ParseErrorsCard(errors: state.parseErrors),
            const SizedBox(height: AppSpacing.lg),
          ],
          PrimaryButton(
            label: 'Escolher Arquivo',
            icon: Icons.folder_open,
            onPressed: () => _pickFile(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final filePath = result.files.first.path;
    if (filePath == null) {
      return;
    }

    final csvContent = await File(filePath).readAsString();
    if (!context.mounted) return;
    await ref.read(invoiceImportProvider.notifier).loadCsv(csvContent);
  }
}

class _ParseErrorsCard extends StatelessWidget {
  final List<String> errors;

  const _ParseErrorsCard({required this.errors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorWithOpacity,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${errors.length} linha(s) com erro foram ignoradas',
            style: AppTypography.labelLarge.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...errors.take(5).map(
                (e) => Text(
                  e,
                  style: AppTypography.bodySmall,
                ),
              ),
          if (errors.length > 5)
            Text(
              '... e mais ${errors.length - 5}',
              style: AppTypography.bodySmall,
            ),
        ],
      ),
    );
  }
}

class _MappingStep extends ConsumerWidget {
  const _MappingStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceImportProvider);
    final notifier = ref.read(invoiceImportProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Contas', style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Associe cada cartão a uma conta de crédito existente',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              _CardAccountMapping(
                cardNames: state.distinctCardNames,
                mapping: state.cardToAccountId,
                onChanged: notifier.mapCardToAccount,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Categorias', style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Associe cada categoria da fatura a uma categoria existente',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              _CategoryMapping(
                categoryNames: state.distinctCategoryNames,
                mapping: state.categoryToCategoryId,
                onChanged: notifier.mapCategoryToCategory,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PrimaryButton(
            label: 'Avançar',
            isEnabled: state.isFullyMapped,
            onPressed: notifier.confirmMapping,
          ),
        ),
      ],
    );
  }
}

class _CardAccountMapping extends ConsumerWidget {
  final List<String> cardNames;
  final Map<String, int> mapping;
  final void Function(String cardName, int accountId) onChanged;

  const _CardAccountMapping({
    required this.cardNames,
    required this.mapping,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountRepositoryProvider).getAll();

    return FutureBuilder<List<AccountModel>>(
      future: accountsAsync,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final eligibleAccounts = snapshot.data!
            .where((a) => a.isCredit && a.creditPaymentDay != null)
            .toList();

        if (eligibleAccounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warningWithOpacity,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Text(
              'Nenhuma conta de crédito encontrada. Crie ou configure uma '
              'conta de crédito nas Contas antes de importar.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.warning,
              ),
            ),
          );
        }

        return Column(
          children: [
            for (final cardName in cardNames)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: CustomDropdown<int>(
                  label: cardName,
                  value: mapping[cardName],
                  items: [
                    for (final account in eligibleAccounts)
                      DropdownMenuItem(
                        value: account.id,
                        child: Text(account.name),
                      ),
                  ],
                  onChanged: (accountId) {
                    if (accountId != null) onChanged(cardName, accountId);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryMapping extends ConsumerWidget {
  final List<String> categoryNames;
  final Map<String, int> mapping;
  final void Function(String categoryName, int categoryId) onChanged;

  const _CategoryMapping({
    required this.categoryNames,
    required this.mapping,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryRepositoryProvider).getAll();

    return FutureBuilder<List<CategoryModel>>(
      future: categoriesAsync,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data!;

        return Column(
          children: [
            for (final categoryName in categoryNames)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: CustomDropdown<int>(
                  label: categoryName,
                  value: mapping[categoryName],
                  items: [
                    for (final category in categories)
                      DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                  ],
                  onChanged: (categoryId) {
                    if (categoryId != null) onChanged(categoryName, categoryId);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ReviewStep extends ConsumerWidget {
  const _ReviewStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceImportProvider);
    final notifier = ref.read(invoiceImportProvider.notifier);

    final includedTotal = <double>[
      for (var i = 0; i < state.rows.length; i++)
        if (!state.excludedRowIndexes.contains(i)) state.rows[i].value,
    ].fold<double>(0, (sum, v) => sum + v);

    final includedCount = state.rows.length - state.excludedRowIndexes.length;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$includedCount de ${state.rows.length} transações',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                formatCurrency(includedTotal),
                style: AppTypography.displaySmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: state.rows.length,
            itemBuilder: (context, index) {
              final row = state.rows[index];
              final excluded = state.excludedRowIndexes.contains(index);

              return CheckboxListTile(
                value: !excluded,
                onChanged: (_) => notifier.toggleRowExcluded(index),
                title: Text(
                  row.description,
                  style: AppTypography.bodyLarge.copyWith(
                    color: excluded
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                    decoration: excluded ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  '${row.cardName} • ${row.categoryName} • '
                  '${formatDate(row.date)}'
                  '${row.totalInstallments > 1 ? ' • ${row.currentInstallment}/${row.totalInstallments}' : ''}',
                  style: AppTypography.bodySmall,
                ),
                secondary: Text(
                  formatCurrency(row.value),
                  style: AppTypography.titleMedium,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PrimaryButton(
            label: 'Confirmar Importação',
            isEnabled: includedCount > 0,
            onPressed: notifier.commit,
          ),
        ),
      ],
    );
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
          const SizedBox(height: AppSpacing.lg),
          Text('Importação concluída', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Fechar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
