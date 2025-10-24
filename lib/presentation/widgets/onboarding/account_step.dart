import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/local_database.dart';
import '../../../data/repositories/account_repository_impl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../inputs/custom_text_field.dart';
import '../inputs/nubank_style_currency_field.dart';

/// Account creation step of the onboarding flow
class AccountStep extends ConsumerStatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final Function(String, bool, bool, double, double) onAccountDataChanged;

  const AccountStep({
    required this.onContinue,
    required this.onBack,
    required this.onAccountDataChanged,
    super.key,
  });

  @override
  ConsumerState<AccountStep> createState() => _AccountStepState();
}

class _AccountStepState extends ConsumerState<AccountStep> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _creditLimitController;

  bool _isDebit = true;
  bool _isCredit = false;
  bool _isLoading = false;
  String? _errorMessage;

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
                  'Sua primeira conta',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Crie sua primeira conta bancária para começar',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          // Error message
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          if (_errorMessage != null) SizedBox(height: AppSpacing.md),
          // Form fields
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                // Account name
                CustomTextField(
                  label: 'Nome da Conta',
                  controller: _nameController,
                  hint: 'Ex: Conta Corrente',
                  isEnabled: !_isLoading,
                ),
                SizedBox(height: AppSpacing.xl),
                // Account type selection
                Text(
                  'Tipo de Conta',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: _isDebit,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _isDebit = value ?? false;
                                });
                              },
                        title: Text(
                          'Débito',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          'Conta com saldo',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        dense: true,
                      ),
                      CheckboxListTile(
                        value: _isCredit,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _isCredit = value ?? false;
                                });
                              },
                        title: Text(
                          'Crédito',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          'Conta com limite',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        dense: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                // Balance (if debit)
                if (_isDebit) ...[
                  NubankStyleCurrencyField(
                    label: 'Saldo Inicial',
                    hint: '0,00',
                    controller: _balanceController,
                    isEnabled: !_isLoading,
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
                // Credit limit (if credit)
                if (_isCredit) ...[
                  NubankStyleCurrencyField(
                    label: 'Limite de Crédito',
                    hint: '0,00',
                    controller: _creditLimitController,
                    isEnabled: !_isLoading,
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          // Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                PrimaryButton(
                  label: _isLoading ? 'Criando...' : 'Próximo',
                  onPressed: _isLoading ? () {} : _createAccount,
                  isEnabled: !_isLoading,
                ),
                SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Voltar',
                  onPressed: _isLoading ? () {} : widget.onBack,
                  isEnabled: !_isLoading,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
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
    _nameController = TextEditingController();
    _balanceController = TextEditingController();
    _creditLimitController = TextEditingController();
  }

  Future<void> _createAccount() async {
    // Validate inputs
    if (_nameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Nome da conta é obrigatório';
      });
      return;
    }

    if (!_isDebit && !_isCredit) {
      setState(() {
        _errorMessage = 'Selecione pelo menos um tipo de conta';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // NubankStyleCurrencyField uses internal representation (cents)
      final balanceCents = int.tryParse(_balanceController.text) ?? 0;
      final creditLimitCents = int.tryParse(_creditLimitController.text) ?? 0;

      final balance = balanceCents / 100.0;
      final creditLimit = creditLimitCents / 100.0;

      if (balance < 0 || creditLimit < 0) {
        throw Exception('Valores não podem ser negativos');
      }

      final repository = AccountRepositoryImpl();
      final newAccount = AccountModelCompanion.insert(
        name: _nameController.text,
        isDebit: Value(_isDebit),
        isCredit: Value(_isCredit),
        balance: Value(balance),
        creditLimit: Value(creditLimit),
        creditUsed: Value(0.0),
      );

      await repository.create(newAccount);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.onAccountDataChanged(
          _nameController.text,
          _isDebit,
          _isCredit,
          balance,
          creditLimit,
        );
        widget.onContinue();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erro ao criar conta: $e';
        });
      }
    }
  }
}
