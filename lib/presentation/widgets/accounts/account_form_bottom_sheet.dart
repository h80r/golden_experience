import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/local_database.dart';
import '../../../data/providers/repository_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../inputs/custom_text_field.dart';
import '../inputs/inline_calendar.dart';
import '../inputs/nubank_style_currency_field.dart';

/// AccountFormBottomSheet - Form for creating/editing accounts
/// Supports dual-type accounts (can be both debit and credit)
class AccountFormBottomSheet extends ConsumerStatefulWidget {
  final AccountModel? account;

  const AccountFormBottomSheet({
    this.account,
    super.key,
  });

  @override
  ConsumerState<AccountFormBottomSheet> createState() =>
      _AccountFormBottomSheetState();
}

class _AccountFormBottomSheetState
    extends ConsumerState<AccountFormBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _creditLimitController;
  late PageController _pageController;
  late DraggableScrollableController _sheetController;
  late GlobalKey<FormState> _formKey;
  late bool _isDebit;
  late bool _isCredit;
  late FocusNode _nameFocusNode;
  bool _isLoading = false;
  double _lastKeyboardHeight = 0.0;
  int? _creditPaymentDay;
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.account != null;

    // Detect keyboard height to auto-expand sheet
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Auto-expand when keyboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (keyboardHeight > 0 && _lastKeyboardHeight == 0) {
        // Keyboard just opened - expand to 85%
        if (_sheetController.isAttached && mounted) {
          _sheetController.animateTo(
            0.975,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } else if (keyboardHeight == 0 && _lastKeyboardHeight > 0) {
        // Keyboard just closed - return to 55%
        if (_sheetController.isAttached && mounted) {
          _sheetController.animateTo(
            0.65,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
      _lastKeyboardHeight = keyboardHeight;
    });

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.5,
      maxChildSize: 0.98,
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
                            isEditing ? 'Editar Conta' : 'Nova Conta',
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
              // Form Content with PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  children: [
                    _buildPage1(scrollController, isEditing),
                    if (_isCredit) _buildPage2(),
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
    _nameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
    _pageController.dispose();
    _sheetController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _pageController = PageController();
    _sheetController = DraggableScrollableController();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _nameFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nameFocusNode.requestFocus();
      }
    });

    if (widget.account != null) {
      _isDebit = widget.account!.isDebit;
      _isCredit = widget.account!.isCredit;
      _creditPaymentDay = widget.account!.creditPaymentDay;
      // Initialize empty controllers - NubankStyleCurrencyField handles initialValue internally
      _balanceController = TextEditingController();
      _creditLimitController = TextEditingController();
    } else {
      // Default: debit account
      _isDebit = true;
      _isCredit = false;
      _creditPaymentDay = null;
      _balanceController = TextEditingController();
      _creditLimitController = TextEditingController();
    }
  }

  /// Build page 1 with main account fields
  Widget _buildPage1(ScrollController scrollController, bool isEditing) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Account Name Field
            CustomTextField(
              label: 'Nome da Conta',
              hint: 'Ex: Conta Corrente, Cartão de Crédito',
              controller: _nameController,
              focusNode: _nameFocusNode,
              prefixIcon: Icons.account_balance,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome da conta';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Account Type Selection (Checkboxes in Row)
            Text(
              'Tipo de Conta',
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Checkboxes in horizontal row
            Row(
              children: [
                // Debit Checkbox
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDebit = !_isDebit;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isDebit
                              ? AppColors.primary
                              : AppColors.surfaceVariant,
                          width: 2,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isDebit,
                            onChanged: (value) {
                              setState(() {
                                _isDebit = value ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              'Débito',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Credit Checkbox
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCredit = !_isCredit;
                        // Auto-navigate back to page 1 if credit is unchecked while on page 2
                        if (!_isCredit && _currentPageIndex == 1) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _goToPreviousPage();
                          });
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isCredit
                              ? AppColors.primary
                              : AppColors.surfaceVariant,
                          width: 2,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isCredit,
                            onChanged: (value) {
                              setState(() {
                                _isCredit = value ?? false;
                                // Auto-navigate back to page 1 if credit is unchecked while on page 2
                                if (!_isCredit && _currentPageIndex == 1) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _goToPreviousPage();
                                  });
                                }
                              });
                            },
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              'Crédito',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Validation: at least one type must be selected
            if (!_isDebit && !_isCredit)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  'Selecione pelo menos um tipo de conta',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.lg),

            // Conditional Input Fields Display
            // Case 1: Only Debit checked - show balance field (full width)
            if (_isDebit && !_isCredit)
              Column(
                children: [
                  NubankStyleCurrencyField(
                    label: 'Saldo Inicial',
                    hint: '0,00',
                    controller: _balanceController,
                    initialValue: widget.account?.balance ?? 0.0,
                    onChanged: (value) {
                      // Value is already converted by widget
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um valor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),

            // Case 2: Only Credit checked - show credit limit field (full width)
            if (!_isDebit && _isCredit)
              Column(
                children: [
                  NubankStyleCurrencyField(
                    label: 'Limite de Crédito',
                    hint: '0,00',
                    controller: _creditLimitController,
                    initialValue: widget.account?.creditLimit ?? 0.0,
                    onChanged: (value) {
                      // Value is already converted by widget
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um limite';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),

            // Case 3: Both checked - show both fields in a row
            if (_isDebit && _isCredit)
              Column(
                children: [
                  Row(
                    children: [
                      // Balance field (50% width)
                      Expanded(
                        flex: 1,
                        child: NubankStyleCurrencyField(
                          label: 'Saldo Inicial',
                          hint: '0,00',
                          controller: _balanceController,
                          initialValue: widget.account?.balance ?? 0.0,
                          onChanged: (value) {
                            // Value is already converted by widget
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira um valor';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Credit limit field (50% width)
                      Expanded(
                        flex: 1,
                        child: NubankStyleCurrencyField(
                          label: 'Limite de Crédito',
                          hint: '0,00',
                          controller: _creditLimitController,
                          initialValue: widget.account?.creditLimit ?? 0.0,
                          onChanged: (value) {
                            // Value is already converted by widget
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira um limite';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),

            // Action Buttons
            Row(
              children: [
                // Cancel icon button (25%) - outlined red style
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
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
                // Calendar icon button (25%) - only for credit accounts
                if (_isCredit)
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: _goToNextPage,
                      icon: const Icon(Icons.calendar_today),
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
                if (_isCredit) const SizedBox(width: AppSpacing.sm),
                // Primary action button
                // For credit accounts: "Próximo" (Next)
                // For debit-only accounts: "Salvar" (Save)
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: _isCredit
                        ? 'Próximo'
                        : (isEditing ? 'Atualizar' : 'Criar'),
                    isLoading: _isLoading,
                    onPressed: _isCredit ? _goToNextPage : _handleSubmit,
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

  /// Build page 2 with closing day calendar (for credit accounts)
  Widget _buildPage2() {
    // Calculate the closing day from payment day
    final calculatedClosingDay =
        _creditPaymentDay != null ? _creditPaymentDay! - 7 : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Day Section
          Text(
            'Dia do Pagamento da Fatura',
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Selecione o dia do mês em que a fatura do cartão vence',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          InlineCalendar(
            selectedDay: _creditPaymentDay ?? 1,
            onDaySelected: (day) {
              setState(() {
                _creditPaymentDay = day;
              });
            },
            compactMode: true,
          ),
          const SizedBox(height: AppSpacing.md),

          // Calculated Closing Day Info
          if (_creditPaymentDay != null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Fechamento automático: dia ${calculatedClosingDay! > 0 ? calculatedClosingDay : "calculado no mês anterior"}\n(7 dias antes do pagamento)',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.xl),

          // Bottom row: Cancel (25%) | Back (25%) | Save (50%)
          Row(
            children: [
              // Cancel icon button (25%) - outlined red style
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
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
                  label: widget.account != null ? 'Atualizar' : 'Criar',
                  isLoading: _isLoading,
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  void _goToNextPage() {
    // Dismiss keyboard before navigating
    FocusScope.of(context).unfocus();

    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleSubmit() async {
    // Validate at least one type is selected
    if (!_isDebit && !_isCredit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selecione pelo menos um tipo de conta',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.background,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate credit payment day if credit is enabled
    if (_isCredit && _creditPaymentDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, selecione o dia do pagamento para contas de crédito',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.background,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      // Navigate to page 2 to let user set the payment day
      _goToNextPage();
      return;
    }

    // Validate form if on page 1, otherwise check required fields manually
    if (_formKey.currentState != null) {
      if (!_formKey.currentState!.validate()) {
        // Validation failed - go back to page 1 to show errors
        _goToPreviousPage();
        return;
      }
    } else {
      // Manual validation when form is not accessible (on page 2)
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Por favor, insira o nome da conta',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.background,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
        _goToPreviousPage();
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final accountRepository = ref.read(accountRepositoryProvider);
      final name = _nameController.text;

      // Parse cents from controllers (NubankStyleCurrencyField stores cents as digits)
      final balance =
          _isDebit ? _parseCentsToDouble(_balanceController.text) : 0.0;
      final creditLimit =
          _isCredit ? _parseCentsToDouble(_creditLimitController.text) : 0.0;

      if (widget.account != null) {
        // Update existing account
        final updated = widget.account!.copyWith(
          name: name,
          isDebit: _isDebit,
          isCredit: _isCredit,
          balance: balance,
          creditLimit: creditLimit,
          creditPaymentDay: drift.Value(_creditPaymentDay),
        );

        final success = await accountRepository.update(updated);

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Conta atualizada com sucesso',
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
                  'Erro ao atualizar conta',
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
        // Create new account
        final newAccount = AccountModelCompanion(
          name: drift.Value(name),
          isDebit: drift.Value(_isDebit),
          isCredit: drift.Value(_isCredit),
          balance: drift.Value(balance),
          creditLimit: drift.Value(creditLimit),
          creditPaymentDay: drift.Value(_creditPaymentDay),
        );

        final id = await accountRepository.create(newAccount);

        if (mounted) {
          if (id > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Conta criada com sucesso',
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
                  'Erro ao criar conta',
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

  /// Parse cents value (stored as digits in controller) to double
  double _parseCentsToDouble(String centsText) {
    if (centsText.isEmpty) return 0.0;
    try {
      final cents = int.parse(centsText);
      return cents / 100.0;
    } catch (e) {
      return 0.0;
    }
  }
}
