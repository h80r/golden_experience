import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../inputs/custom_text_field.dart';
import '../inputs/custom_dropdown.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// Expense details bottom sheet for entering transaction information
class ExpenseDetailsBottomSheet extends StatefulWidget {
  final double initialValue;
  final List<String> accounts;
  final List<String> categories;
  final void Function({
    required double value,
    required String description,
    required String? notes,
    required String accountId,
    required String transactionType,
    required String categoryId,
    required DateTime date,
  }) onSave;
  final VoidCallback onCancel;

  const ExpenseDetailsBottomSheet({
    required this.initialValue,
    required this.accounts,
    required this.categories,
    required this.onSave,
    required this.onCancel,
    super.key,
  });

  @override
  State<ExpenseDetailsBottomSheet> createState() =>
      _ExpenseDetailsBottomSheetState();
}

class _ExpenseDetailsBottomSheetState extends State<ExpenseDetailsBottomSheet> {
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  String? _selectedAccount;
  String? _selectedCategory;
  String _transactionType = 'debit';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _notesController = TextEditingController();
    if (widget.accounts.isNotEmpty) {
      _selectedAccount = widget.accounts.first;
    }
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _isFormValid() {
    return _descriptionController.text.isNotEmpty &&
        _selectedAccount != null &&
        _selectedCategory != null;
  }

  void _handleSave() {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios'),
        ),
      );
      return;
    }

    widget.onSave(
      value: widget.initialValue,
      description: _descriptionController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      accountId: _selectedAccount!,
      transactionType: _transactionType,
      categoryId: _selectedCategory!,
      date: _selectedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
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
                        Text(
                          'Detalhes da Transação',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'R\$ ${widget.initialValue.toStringAsFixed(2)}',
                          style: AppTypography.headlineLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      CustomTextField(
                        label: 'Descrição',
                        hint: 'Ex: Almoço, Supermercado...',
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.description,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Notes
                      CustomTextField(
                        label: 'Notas (Opcional)',
                        hint: 'Informações adicionais...',
                        controller: _notesController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 2,
                        prefixIcon: Icons.note,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Account Selector
                      CustomDropdown<String>(
                        label: 'Conta',
                        value: _selectedAccount,
                        prefixIcon: Icons.account_balance_wallet,
                        items: widget.accounts
                            .map(
                              (account) => DropdownMenuItem(
                                value: account,
                                child: Text(account),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAccount = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Transaction Type
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _transactionType = 'debit';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: _transactionType == 'debit'
                                      ? AppColors.primary
                                      : AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMedium,
                                  ),
                                  border: Border.all(
                                    color: _transactionType == 'debit'
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  'Débito',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.titleMedium.copyWith(
                                    color: _transactionType == 'debit'
                                        ? AppColors.background
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _transactionType = 'credit';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: _transactionType == 'credit'
                                      ? AppColors.primary
                                      : AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMedium,
                                  ),
                                  border: Border.all(
                                    color: _transactionType == 'credit'
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  'Crédito',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.titleMedium.copyWith(
                                    color: _transactionType == 'credit'
                                        ? AppColors.background
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Category Selector
                      CustomDropdown<String>(
                        label: 'Categoria',
                        value: _selectedCategory,
                        prefixIcon: Icons.category,
                        items: widget.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Date Picker
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMedium,
                            ),
                            color: AppColors.surfaceVariant,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text(
                                _selectedDate.toString().split(' ')[0],
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: 'Cancelar',
                              onPressed: widget.onCancel,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Salvar',
                              onPressed: _handleSave,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
