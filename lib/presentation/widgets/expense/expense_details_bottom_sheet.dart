import 'dart:async';
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
  final double? initialValue;
  final Map<int, String>? accounts;
  final Map<int, String>? categories;
  final FutureOr<void> Function({
    required double value,
    required String description,
    required String? notes,
    required int accountId,
    required String transactionType,
    required int categoryId,
    required DateTime date,
  })? onSave;
  final VoidCallback onCancel;

  const ExpenseDetailsBottomSheet({
    this.initialValue,
    this.accounts,
    this.categories,
    this.onSave,
    required this.onCancel,
    super.key,
  });

  @override
  State<ExpenseDetailsBottomSheet> createState() =>
      _ExpenseDetailsBottomSheetState();
}

class _ExpenseDetailsBottomSheetState extends State<ExpenseDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  late FocusNode _valueFocusNode;
  int? _selectedAccountId;
  int? _selectedCategoryId;
  String _transactionType = 'debit';
  DateTime _selectedDate = DateTime.now();
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController();
    _descriptionController = TextEditingController();
    _notesController = TextEditingController();
    _valueFocusNode = FocusNode();

    // Initialize with pre-filled value if provided
    if (widget.initialValue != null && widget.initialValue! > 0) {
      _currentValue = widget.initialValue!;
      _valueController.text = _formatCurrency(widget.initialValue!);
    }

    if (widget.accounts != null && widget.accounts!.isNotEmpty) {
      _selectedAccountId = widget.accounts!.keys.first;
    }
    if (widget.categories != null && widget.categories!.isNotEmpty) {
      _selectedCategoryId = widget.categories!.keys.first;
    }

    // Request focus on the value field after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _valueFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  /// Formats a double value as Brazilian currency (R$ X.XXX,XX)
  String _formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Add thousand separators to integer part
    String formatted = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formatted += '.';
      }
      formatted += integerPart[i];
    }

    return 'R\$ $formatted,$decimalPart';
  }

  /// Parses currency input and returns the numeric value
  /// Handles both formats: "1000,50" and "1.000,50"
  double _parseCurrencyInput(String input) {
    // Remove currency symbol
    String cleaned = input.replaceAll('R\$ ', '').trim();

    // Remove thousand separators (dots)
    cleaned = cleaned.replaceAll('.', '');

    // Replace comma with dot for decimal point
    cleaned = cleaned.replaceAll(',', '.');

    return double.tryParse(cleaned) ?? 0.0;
  }

  void _handleValueChange(String input) {
    setState(() {
      _currentValue = _parseCurrencyInput(input);
    });
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

  void _handleSave() {
    // Trigger validation and show error states on all fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate that value is provided and greater than 0
    if (_currentValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O valor deve ser maior que zero'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    widget.onSave?.call(
      value: _currentValue,
      description: _descriptionController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      accountId: _selectedAccountId!,
      transactionType: _transactionType,
      categoryId: _selectedCategoryId!,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes da Transação',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textPrimary,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Value Input
                        CustomTextField(
                          label: 'Valor',
                          hint: 'R\$ 0,00',
                          controller: _valueController,
                          focusNode: _valueFocusNode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.attach_money,
                          onChanged: _handleValueChange,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'O valor é obrigatório';
                            }
                            final parsed = _parseCurrencyInput(value);
                            if (parsed <= 0) {
                              return 'O valor deve ser maior que zero';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Description
                        CustomTextField(
                          label: 'Descrição',
                          hint: 'Ex: Almoço, Supermercado...',
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.description,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'A descrição é obrigatória';
                            }
                            return null;
                          },
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
                      CustomDropdown<int>(
                        label: 'Conta',
                        value: _selectedAccountId,
                        prefixIcon: Icons.account_balance_wallet,
                        items: (widget.accounts ?? {})
                            .entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAccountId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione uma conta';
                          }
                          return null;
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
                      CustomDropdown<int>(
                        label: 'Categoria',
                        value: _selectedCategoryId,
                        prefixIcon: Icons.category,
                        items: (widget.categories ?? {})
                            .entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione uma categoria';
                          }
                          return null;
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
              ),
            ],
          ),
        );
      },
    );
  }
}
