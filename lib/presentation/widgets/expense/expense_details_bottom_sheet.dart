import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../inputs/custom_dropdown.dart';
import '../inputs/custom_text_field.dart';
import '../inputs/date_time_button.dart';
import '../inputs/nubank_style_currency_field.dart';
import '../inputs/segmented_toggle.dart';

/// Expense details bottom sheet for entering transaction information
/// Page 1: Value, Date, Description, Account, Category, Debit/Credit toggle
/// Page 2: Notes (large text area)
class ExpenseDetailsBottomSheet extends StatefulWidget {
  final double? initialValue;
  final String? initialDescription;
  final String? initialNotes;
  final int? initialAccountId;
  final int? initialCategoryId;
  final DateTime? initialDate;
  final Map<int, String>? accounts;
  final Map<int, String>? categories;
  final bool isEditMode;
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
    this.initialDescription,
    this.initialNotes,
    this.initialAccountId,
    this.initialCategoryId,
    this.initialDate,
    this.accounts,
    this.categories,
    this.isEditMode = false,
    this.onSave,
    required this.onCancel,
    super.key,
  });

  @override
  State<ExpenseDetailsBottomSheet> createState() =>
      _ExpenseDetailsBottomSheetState();
}

class _ExpenseDetailsBottomSheetState extends State<ExpenseDetailsBottomSheet> {
  late PageController _pageController;
  late DraggableScrollableController _sheetController;
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  late TextEditingController _valueController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  late FocusNode _valueFocusNode;
  int? _selectedAccountId;
  int? _selectedCategoryId;
  String _transactionType = 'credit';
  DateTime _selectedDate = DateTime.now();
  double _currentValue = 0.0;
  int _currentPage = 0;
  double _lastKeyboardHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    // Detect keyboard height to auto-expand sheet
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Auto-expand when keyboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (keyboardHeight > 0 && _lastKeyboardHeight == 0) {
        // Keyboard just opened - expand to 90%
        if (_sheetController.isAttached && mounted) {
          _sheetController.animateTo(
            0.85,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } else if (keyboardHeight == 0 && _lastKeyboardHeight > 0) {
        // Keyboard just closed - return to 65%
        if (_sheetController.isAttached && mounted) {
          _sheetController.animateTo(
            0.55,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
      _lastKeyboardHeight = keyboardHeight;
    });

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                            widget.isEditMode
                                ? 'Editar Transação'
                                : 'Detalhes da Transação',
                            style: AppTypography.headlineSmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Page indicator (dots)
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == 0
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == 1
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // PageView with 2 pages (swipeable)
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // Page 1: Main Fields (Value, Description, Account, Debit/Credit)
                    _buildPage1(scrollController),
                    // Page 2: Complementary Fields (Notes, Category, Date)
                    _buildPage2(scrollController),
                  ],
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
    _pageController.dispose();
    _sheetController.dispose();
    _valueController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _sheetController = DraggableScrollableController();
    _valueController = TextEditingController();
    _descriptionController = TextEditingController();
    _notesController = TextEditingController();
    _valueFocusNode = FocusNode();

    // Initialize with pre-filled value if provided
    // NubankStyleCurrencyField expects cents as string internally
    if (widget.initialValue != null && widget.initialValue! > 0) {
      _currentValue = widget.initialValue!;
      final cents = (widget.initialValue! * 100).toInt();
      _valueController.text = cents.toString();
    }

    // Initialize description
    if (widget.initialDescription != null) {
      _descriptionController.text = widget.initialDescription!;
    }

    // Initialize notes
    if (widget.initialNotes != null) {
      _notesController.text = widget.initialNotes!;
    }

    // Initialize account
    if (widget.initialAccountId != null) {
      _selectedAccountId = widget.initialAccountId!;
    } else if (widget.accounts != null && widget.accounts!.isNotEmpty) {
      _selectedAccountId = widget.accounts!.keys.first;
    }

    // Initialize category
    if (widget.initialCategoryId != null) {
      _selectedCategoryId = widget.initialCategoryId!;
    } else if (widget.categories != null && widget.categories!.isNotEmpty) {
      _selectedCategoryId = widget.categories!.keys.first;
    }

    // Initialize date
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }

    // Request focus on the value field after the widget is built (only if not in edit mode)
    if (!widget.isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _valueFocusNode.requestFocus();
        }
      });
    }
  }

  /// Build page 1 with main fields
  Widget _buildPage1(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKeyPage1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Value (75%) + Date Button (25%)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: NubankStyleCurrencyField(
                    label: 'Valor',
                    hint: 'R\$ 0,00',
                    controller: _valueController,
                    focusNode: _valueFocusNode,
                    textInputAction: TextInputAction.next,
                    initialValue: widget.initialValue,
                    onChanged: (value) {
                      setState(() {
                        _currentValue = value;
                      });
                    },
                    required: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'O valor é obrigatório';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'O valor deve ser maior que zero';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 1,
                  child: DateTimeButton(
                    selectedDateTime: _selectedDate,
                    onChanged: (dateTime) {
                      setState(() {
                        _selectedDate = dateTime;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Row 2: Description
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

            // Row 3: Account (50%) + Category (50%)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomDropdown<int>(
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
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomDropdown<int>(
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
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Row 4: Debit/Credit Segmented Toggle
            SegmentedToggle(
              leftLabel: 'Débito',
              rightLabel: 'Crédito',
              isLeftSelected: _transactionType == 'debit',
              onLeftTap: () {
                setState(() {
                  _transactionType = 'debit';
                });
              },
              onRightTap: () {
                setState(() {
                  _transactionType = 'credit';
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Bottom row: Cancel (25%) | Details (25%) | Save (50%)
            Row(
              children: [
                // Cancel icon button (25%) - outlined red style
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close),
                    iconSize: 28,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      foregroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Details icon button (25%)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: _goToNextPage,
                    icon: const Icon(Icons.edit_note),
                    iconSize: 28,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      foregroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Save button (50%)
                Expanded(
                  flex: 2,
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
    );
  }

  /// Build page 2 with large notes field
  Widget _buildPage2(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKeyPage2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Notes field (equivalent to ~4 rows of fields from page 1)
            CustomTextField(
              label: 'Notas (Opcional)',
              hint: 'Informações adicionais sobre esta transação...',
              controller: _notesController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: 10, // Large text area
              prefixIcon: Icons.note,
              textAlignVertical: TextAlignVertical.top,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Bottom row: Cancel (25%) | Back (25%) | Save (50%)
            Row(
              children: [
                // Cancel icon button (25%) - outlined red style
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close),
                    iconSize: 28,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      foregroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Back icon button (25%)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: _goToPreviousPage,
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 28,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      foregroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Save button (50%)
                Expanded(
                  flex: 2,
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
    );
  }

  /// Validate page 1 fields and advance if valid
  void _goToNextPage() {
    // Navigate to page 2 without validation
    // Validation will only happen on save
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Go back to page 1
  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Handle save action - validates page 1 fields since save button is on both pages
  void _handleSave() {
    // Always validate page 1 fields (required fields are there)
    if (!_formKeyPage1.currentState!.validate()) {
      // If validation fails and we're on page 2, go back to page 1 to show errors
      if (_currentPage == 1) {
        _goToPreviousPage();
      }
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
      // If we're on page 2, go back to page 1
      if (_currentPage == 1) {
        _goToPreviousPage();
      }
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
}
