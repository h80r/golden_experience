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
  late GlobalKey<FormState> _formKey;
  late bool _isDebit;
  late bool _isCredit;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.account != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          isEditing ? 'Editar Conta' : 'Nova Conta',
          style: AppTypography.headlineLarge,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Account Name Field
              CustomTextField(
                label: 'Nome da Conta',
                hint: 'Ex: Conta Corrente, Cartão de Crédito',
                controller: _nameController,
                prefixIcon: Icons.account_balance,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da conta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Account Type Selection (Checkboxes)
              Text(
                'Tipo de Conta',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Debit Checkbox
              CheckboxListTile(
                title: Text(
                  'Débito (Conta Corrente)',
                  style: AppTypography.bodyMedium,
                ),
                subtitle: Text(
                  'Conta com saldo e limite de débito',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                value: _isDebit,
                onChanged: (value) {
                  setState(() {
                    _isDebit = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              // Credit Checkbox
              CheckboxListTile(
                title: Text(
                  'Crédito (Cartão de Crédito)',
                  style: AppTypography.bodyMedium,
                ),
                subtitle: Text(
                  'Conta com limite de crédito',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                value: _isCredit,
                onChanged: (value) {
                  setState(() {
                    _isCredit = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: AppSpacing.lg),

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

              // Debit Balance Field
              if (_isDebit)
                Column(
                  children: [
                    NubankStyleCurrencyField(
                      label: 'Saldo Inicial (Débito)',
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

              // Credit Limit Field
              if (_isCredit)
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
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController(text: widget.account?.name ?? '');

    if (widget.account != null) {
      _isDebit = widget.account!.isDebit;
      _isCredit = widget.account!.isCredit;
      // Initialize empty controllers - NubankStyleCurrencyField handles initialValue internally
      _balanceController = TextEditingController();
      _creditLimitController = TextEditingController();
    } else {
      // Default: debit account
      _isDebit = true;
      _isCredit = false;
      _balanceController = TextEditingController();
      _creditLimitController = TextEditingController();
    }
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

    if (!_formKey.currentState!.validate()) {
      return;
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
