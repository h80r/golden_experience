import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../../../data/repositories/category_repository_impl.dart';

/// Categories review step of the onboarding flow
class CategoriesStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const CategoriesStep({
    required this.onContinue,
    required this.onBack,
    super.key,
  });

  @override
  State<CategoriesStep> createState() => _CategoriesStepState();
}

class _CategoriesStepState extends State<CategoriesStep> {
  late Future<List> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategories();
  }

  Future<List> _loadCategories() async {
    try {
      final repository = CategoryRepositoryImpl();
      final categories = await repository.getAll();
      return categories;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.xl),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suas categorias',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Categorize seus gastos para melhor organização',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          // Categories list
          FutureBuilder<List>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final categories = snapshot.data ?? [];

              if (categories.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: Text(
                      'Nenhuma categoria disponível',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: categories
                      .map(
                        (category) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withAlpha((0.2 * 255).toInt()),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              SizedBox(width: AppSpacing.sm / 2),
                              Text(
                                category.name,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          SizedBox(height: AppSpacing.xxl),
          // Info box
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Você pode adicionar mais categorias nas configurações quando necessário.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          // Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                PrimaryButton(
                  label: 'Finalizar',
                  onPressed: widget.onContinue,
                ),
                SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Voltar',
                  onPressed: widget.onBack,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
