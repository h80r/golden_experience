import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/accounts_table.dart';
import '../../data/datasources/local_database.dart';
import '../../data/providers/repository_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/accounts/account_form_bottom_sheet.dart';

/// AccountsScreen - Screen for managing accounts
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: StreamBuilder<List<AccountModel>>(
        stream: accountRepository.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar contas',
                style: AppTypography.bodyMedium,
              ),
            );
          }

          final accounts = snapshot.data ?? [];

          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Nenhuma conta cadastrada',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Crie uma nova conta para começar',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return _buildAccountCard(context, ref, account);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAccountFormBottomSheet(context, null);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    WidgetRef ref,
    AccountModel account,
  ) {
    final isDebit = account.type == AccountType.debit;
    final displayValue =
        isDebit ? account.initialBalance : account.creditLimit;
    final label = isDebit ? 'Saldo' : 'Limite Disponível';

    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        side: const BorderSide(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: AppTypography.headlineSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isDebit
                              ? AppColors.successWithOpacity
                              : AppColors.warningWithOpacity,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSmall),
                        ),
                        child: Text(
                          isDebit ? 'Débito' : 'Crédito',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDebit ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCurrency(displayValue),
                      style: AppTypography.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      label,
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(
              color: AppColors.divider,
              height: 1,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _showAccountFormBottomSheet(context, account);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(context, ref, account);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Remover'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountFormBottomSheet(BuildContext context, AccountModel? account) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      builder: (context) => AccountFormBottomSheet(account: account),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    AccountModel account,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Remover Conta',
          style: AppTypography.headlineSmall,
        ),
        content: Text(
          'Tem certeza que deseja remover "${account.name}"?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleDeleteAccount(context, ref, account);
            },
            child: Text(
              'Remover',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteAccount(
    BuildContext context,
    WidgetRef ref,
    AccountModel account,
  ) async {
    final accountRepository = ref.read(accountRepositoryProvider);

    // Check if account has transactions
    final hasTransactions = await accountRepository.hasTransactions(account.id);

    if (context.mounted) {
      if (hasTransactions) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não é possível remover uma conta com transações',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.background,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      } else {
        final success = await accountRepository.delete(account.id);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Conta removida com sucesso',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao remover conta',
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
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',').replaceAll(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), r'$1.')}';
  }
}
