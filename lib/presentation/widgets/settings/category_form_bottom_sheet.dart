import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/local_database.dart';
import '../../../data/providers/repository_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../inputs/custom_text_field.dart';

/// CategoryFormBottomSheet - Form for creating/editing categories
class CategoryFormBottomSheet extends ConsumerStatefulWidget {
  final CategoryModel? category;

  const CategoryFormBottomSheet({
    this.category,
    super.key,
  });

  @override
  ConsumerState<CategoryFormBottomSheet> createState() =>
      _CategoryFormBottomSheetState();
}

class _CategoryFormBottomSheetState
    extends ConsumerState<CategoryFormBottomSheet> {
  late TextEditingController _nameController;
  late DraggableScrollableController _sheetController;
  late GlobalKey<FormState> _formKey;
  late FocusNode _nameFocusNode;
  bool _isLoading = false;
  double _lastKeyboardHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    // Detect keyboard height to auto-expand sheet
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Auto-expand when keyboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (keyboardHeight > 0 && _lastKeyboardHeight == 0) {
        // Keyboard just opened - expand to 85%
        if (_sheetController.isAttached && mounted) {
          _sheetController.animateTo(
            0.68,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } else if (keyboardHeight == 0 && _lastKeyboardHeight > 0) {
        // Keyboard just closed - return to 45%
        if (_sheetController.isAttached && mounted) {
          _sheetController.animateTo(
            0.33,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
      _lastKeyboardHeight = keyboardHeight;
    });

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.33,
      minChildSize: 0.3,
      maxChildSize: 0.75,
      controller: _sheetController,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusLarge),
              topRight: Radius.circular(AppSpacing.radiusLarge),
            ),
          ),
          child: Column(
            children: [
              // Handle and Header
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusLarge),
                    topRight: Radius.circular(AppSpacing.radiusLarge),
                  ),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isEditing ? 'Editar Categoria' : 'Nova Categoria',
                            style: AppTypography.headlineLarge,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Form Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Category Name Field
                        CustomTextField(
                          label: 'Nome da Categoria',
                          hint: 'Ex: Alimentação, Transporte',
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          prefixIcon: Icons.category,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o nome da categoria';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                label: 'Cancelar',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: PrimaryButton(
                                label: isEditing ? 'Atualizar' : 'Criar',
                                isLoading: _isLoading,
                                onPressed: _handleSubmit,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sheetController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _sheetController = DraggableScrollableController();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _nameFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nameFocusNode.requestFocus();
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      final name = _nameController.text.trim();

      if (widget.category != null) {
        // Update existing category
        final updated = widget.category!.copyWith(
          name: name,
        );

        final success = await categoryRepository.update(updated);

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Categoria atualizada com sucesso',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.background,
                  ),
                ),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erro ao atualizar categoria',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.background,
                  ),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      } else {
        // Create new category
        final newCategory = CategoryModelCompanion(
          name: drift.Value(name),
          isDefault: drift.Value(false),
        );

        final id = await categoryRepository.create(newCategory);

        if (mounted) {
          if (id > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Categoria criada com sucesso',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.background,
                  ),
                ),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erro ao criar categoria',
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
    } catch (e) {
      if (mounted) {
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
