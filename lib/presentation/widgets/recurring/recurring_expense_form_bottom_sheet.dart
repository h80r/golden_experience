import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database/recurring_expenses_table.dart';
import '../../../data/database/categories_table.dart';
import '../../../data/database/accounts_table.dart';
import '../../../data/datasources/local_database.dart';
import '../../../data/providers/repository_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../inputs/custom_text_field.dart';
import '../inputs/currency_text_field.dart';
import '../inputs/custom_dropdown.dart';

/// RecurringExpenseFormBottomSheet - Form for creating/editing recurring expenses
class RecurringExpenseFormBottomSheet extends ConsumerStatefulWidget {
  final RecurringExpenseModel? expense;

  const RecurringExpenseFormBottomSheet({
    this.expense,
    super.key,
  });

  @override
  ConsumerState<RecurringExpenseFormBottomSheet> createState() =>
      _RecurringExpenseFormBottomSheetState();
}

class _RecurringExpenseFormBottomSheetState
    extends ConsumerState<RecurringExpenseFormBottomSheet> {
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late TextEditingController _chargeDayController;
  late GlobalKey<FormState> _formKey;
  late int? _selectedAccountId;
  late int? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _descriptionController =
        TextEditingController(text: widget.expense?.description ?? '');
    _valueController = TextEditingController(
      text: widget.expense?.value.toString() ?? '',
    );
    _chargeDayController = TextEditingController(
      text: widget.expense?.chargeDay.toString() ?? '',
    );
    _selectedAccountId = widget.expense?.accountId;
    _selectedCategoryId = widget.expense?.categoryId;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    _chargeDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;
    final accountRepository = ref.watch(accountRepositoryProvider);
    final categoryRepository = ref.watch(categoryRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          isEditing ? 'Editar Recorrência' : 'Nova Recorrência',
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
              // Description Field
              CustomTextField(
                label: 'Descrição',
                hint: 'Ex: Aluguel, Seguro, Assinatura',
                controller: _descriptionController,
                prefixIcon: Icons.description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Value Field
              CurrencyTextField(
                label: 'Valor',
                hint: 'R\$ 0,00',
                controller: _valueController,
                initialValue: widget.expense?.value ?? 0.0,
                onChanged: (value) {
                  // Update state with parsed value
                },
                required: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Charge Day Field
              CustomTextField(
                label: 'Dia de Cobrança',
                hint: '1-31',
                controller: _chargeDayController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.calendar_today,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o dia de cobrança';
                  }
                  final day = int.tryParse(value);
                  if (day == null) {
                    return 'Por favor, insira um número válido';
                  }
                  if (day < 1 || day > 31) {
                    return 'O dia deve estar entre 1 e 31';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Account Dropdown
              StreamBuilder<List<AccountModel>>(
                stream: accountRepository.watchAll(),
                builder: (context, snapshot) {
                  final accounts = snapshot.data ?? [];
                  if (accounts.isEmpty) {
                    return Text(
                      'Nenhuma conta disponível',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    );
                  }

                  return CustomDropdown<int>(
                    label: 'Conta',
                    value: _selectedAccountId,
                    items: accounts
                        .map((account) => DropdownMenuItem(
                              value: account.id,
                              child: Text(
                                account.name,
                                style: AppTypography.bodyMedium,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAccountId = value;
                      });
                    },
                    prefixIcon: Icons.account_balance,
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione uma conta';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category Dropdown
              StreamBuilder<List<CategoryModel>>(
                stream: categoryRepository.watchAll(),
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];
                  if (categories.isEmpty) {
                    return Text(
                      'Nenhuma categoria disponível',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    );
                  }

                  return CustomDropdown<int>(
                    label: 'Categoria',
                    value: _selectedCategoryId,
                    items: categories
                        .map((category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(
                                category.name,
                                style: AppTypography.bodyMedium,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    prefixIcon: Icons.category,
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione uma categoria';
                      }
                      return null;
                    },
                  );
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final recurringExpenseRepository =
          ref.read(recurringExpenseRepositoryProvider);
      final description = _descriptionController.text;
      final value = double.parse(_valueController.text);
      final chargeDay = int.parse(_chargeDayController.text);
      final accountId = _selectedAccountId;
      final categoryId = _selectedCategoryId;

      if (accountId == null || categoryId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Por favor, selecione uma conta e categoria',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      if (widget.expense != null) {
        // Update existing recurring expense
        final updated = widget.expense!.copyWith(
          description: description,
          value: value,
          chargeDay: chargeDay,
          accountId: accountId,
          categoryId: categoryId,
        );

        final success = await recurringExpenseRepository.update(updated);

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Recorrência atualizada com sucesso',
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
                  'Erro ao atualizar recorrência',
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
        // Create new recurring expense
        final newExpense = RecurringExpenseModelCompanion(
          description: drift.Value(description),
          value: drift.Value(value),
          chargeDay: drift.Value(chargeDay),
          accountId: drift.Value(accountId),
          categoryId: drift.Value(categoryId),
        );

        final id = await recurringExpenseRepository.create(newExpense);

        if (mounted) {
          if (id > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Recorrência criada com sucesso',
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
                  'Erro ao criar recorrência',
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
