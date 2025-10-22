import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database/accounts_table.dart';
import '../../../data/datasources/local_database.dart';
import '../../../data/providers/repository_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../inputs/custom_text_field.dart';
import '../inputs/custom_dropdown.dart';

/// AccountFormBottomSheet - Form for creating/editing accounts
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
  late GlobalKey<FormState> _formKey;
  late AccountType? _selectedType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController(text: widget.account?.name ?? '');

    // Set balance based on type
    if (widget.account != null) {
      _selectedType = widget.account!.type;
      final value = _selectedType == AccountType.debit
          ? widget.account!.initialBalance
          : widget.account!.creditLimit;
      _balanceController = TextEditingController(
        text: value.toString(),
      );
    } else {
      _selectedType = AccountType.debit;
      _balanceController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

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

              // Account Type Dropdown
              _buildAccountTypeDropdown(),
              const SizedBox(height: AppSpacing.lg),

              // Balance/Limit Field
              CustomTextField(
                label: _selectedType == AccountType.debit
                    ? 'Saldo Inicial'
                    : 'Limite de Crédito',
                hint: '0.00',
                controller: _balanceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.attach_money,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um valor numérico válido';
                  }
                  if (double.parse(value) < 0) {
                    return 'O valor não pode ser negativo';
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
    );
  }

  Widget _buildAccountTypeDropdown() {
    return CustomDropdown<AccountType>(
      label: 'Tipo de Conta',
      value: _selectedType,
      items: [
        DropdownMenuItem(
          value: AccountType.debit,
          child: Text(
            'Débito',
            style: AppTypography.bodyMedium,
          ),
        ),
        DropdownMenuItem(
          value: AccountType.credit,
          child: Text(
            'Crédito',
            style: AppTypography.bodyMedium,
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedType = value;
          _balanceController.clear();
        });
      },
      prefixIcon: Icons.category,
      validator: (value) {
        if (value == null) {
          return 'Por favor, selecione um tipo de conta';
        }
        return null;
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final accountRepository = ref.read(accountRepositoryProvider);
      final name = _nameController.text;
      final balance = double.parse(_balanceController.text);

      if (widget.account != null) {
        // Update existing account
        final updated = widget.account!.copyWith(
          name: name,
          initialBalance: _selectedType == AccountType.debit ? balance : 0,
          creditLimit: _selectedType == AccountType.credit ? balance : 0,
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
          type: drift.Value(_selectedType ?? AccountType.debit),
          initialBalance: drift.Value(_selectedType == AccountType.debit ? balance : 0),
          creditLimit: drift.Value(_selectedType == AccountType.credit ? balance : 0),
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
}
