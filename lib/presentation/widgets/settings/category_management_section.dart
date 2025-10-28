import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/local_database.dart';
import '../../../data/providers/repository_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'category_form_bottom_sheet.dart';

/// Riverpod provider for watching all categories
final categoriesStreamProvider =
    StreamProvider.autoDispose<List<CategoryModel>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.watchAll();
});

/// CategoryManagementSection - Widget for managing categories in settings
class CategoryManagementSection extends ConsumerWidget {
  const CategoryManagementSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gerenciar Categorias',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              onPressed: () => _showCategoryForm(context, null),
              tooltip: 'Adicionar Categoria',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        Text(
          'Gerencie suas categorias de despesas. Marque uma como padrão para seleção automática.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Categories List
        categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return _buildEmptyState(context);
            }

            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppColors.border,
                  indent: AppSpacing.lg,
                  endIndent: AppSpacing.lg,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryListTile(
                    category: category,
                    onEdit: () => _showCategoryForm(context, category),
                    onDelete: () => _handleDelete(context, ref, category),
                    onToggleDefault: () =>
                        _handleToggleDefault(context, ref, category),
                  );
                },
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Erro ao carregar categorias: $error',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.category_outlined,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nenhuma categoria encontrada',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Adicione uma categoria para começar',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Categoria'),
        content: Text(
          'Deseja realmente excluir a categoria "${category.name}"?\n\n'
          'Esta ação não poderá ser desfeita se a categoria não estiver em uso.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final repository = ref.read(categoryRepositoryProvider);
    final success = await repository.deleteIfUnused(category.id);

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Categoria excluída com sucesso',
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
              'Não é possível excluir esta categoria pois ela possui transações vinculadas',
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

  Future<void> _handleToggleDefault(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category,
  ) async {
    final repository = ref.read(categoryRepositoryProvider);

    if (category.isDefault) {
      // If already default, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${category.name} já é a categoria padrão',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.background,
            ),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    final success = await repository.setDefaultCategory(category.id);

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${category.name} definida como categoria padrão',
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
              'Erro ao definir categoria padrão',
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

  void _showCategoryForm(BuildContext context, CategoryModel? category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFormBottomSheet(category: category),
    );
  }
}

/// Individual category list tile widget
class _CategoryListTile extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleDefault;

  const _CategoryListTile({
    required this.category,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleDefault,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: Icon(
        Icons.category,
        color: category.isDefault ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              category.name,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight:
                    category.isDefault ? FontWeight.bold : FontWeight.normal,
                color: category.isDefault
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Star button to set as default
          IconButton(
            icon: Icon(
              category.isDefault ? Icons.star : Icons.star_outline,
              color: category.isDefault
                  ? AppColors.primary
                  : AppColors.textTertiary,
            ),
            onPressed: category.isDefault ? null : onToggleDefault,
            tooltip: 'Definir como padrão',
          ),
          // Edit button
          IconButton(
            icon: Icon(
              Icons.edit,
              color: AppColors.textSecondary,
            ),
            onPressed: onEdit,
            tooltip: 'Editar',
          ),
          // Delete button
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppColors.error,
            ),
            onPressed: onDelete,
            tooltip: 'Excluir',
          ),
        ],
      ),
    );
  }
}
