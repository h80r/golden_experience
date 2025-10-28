import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/text_formatters.dart';
import '../../data/datasources/local_database.dart';
import '../../data/providers/repository_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/accounts/account_form_bottom_sheet.dart';
import '../widgets/common/standard_app_bar.dart';

/// AccountsScreen - Screen for managing accounts
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);

    return Scaffold(
      appBar: const StandardAppBar(title: 'Contas'),
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
        heroTag: 'accounts_fab',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    WidgetRef ref,
    AccountModel account,
  ) {
    return _AccountCardStateful(
      account: account,
      ref: ref,
      onEdit: () => _showAccountFormBottomSheet(context, account),
      onDelete: () => _showDeleteConfirmation(context, ref, account),
    );
  }

  Future<void> _handleDeleteAccount(
    BuildContext context,
    WidgetRef ref,
    AccountModel account,
  ) async {
    final accountRepository = ref.read(accountRepositoryProvider);

    // Check if account is default
    if (account.isDefault) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Defina outra conta como padrão antes de excluir',
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

        if (!context.mounted) return;

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

  void _showAccountFormBottomSheet(
      BuildContext context, AccountModel? account) {
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
}

/// Stateful widget to track expansion state of account card
class _AccountCardStateful extends StatefulWidget {
  final AccountModel account;
  final WidgetRef ref;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AccountCardStateful({
    required this.account,
    required this.ref,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AccountCardStateful> createState() => _AccountCardStatefulState();
}

class _AccountCardStatefulState extends State<_AccountCardStateful> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Build balance display (only primary balance for collapsed state)
    final balanceDisplay = widget.account.isDebit
        ? formatCurrency(widget.account.balance)
        : formatCurrency(
            widget.account.creditLimit - widget.account.creditUsed);

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
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.account.name,
                  style: AppTypography.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Only show badges when collapsed
              if (!_isExpanded) ...[
                const SizedBox(width: AppSpacing.sm),
                // Type badges (small)
                if (widget.account.isDebit)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successWithOpacity,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusSmall,
                      ),
                    ),
                    child: Text(
                      'Débito',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.success,
                        fontSize: 10,
                      ),
                    ),
                  ),
                if (widget.account.isDebit && widget.account.isCredit)
                  const SizedBox(width: AppSpacing.xs),
                if (widget.account.isCredit)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warningWithOpacity,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusSmall,
                      ),
                    ),
                    child: Text(
                      'Crédito',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.warning,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          // Only show subtitle (balance) when collapsed
          subtitle: !_isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    balanceDisplay,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
          trailing: Icon(
            Icons.expand_more,
            color: AppColors.textSecondary,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Account Details (Debit and/or Credit)
                if (widget.account.isDebit)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo em Conta',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formatCurrency(widget.account.balance),
                        style: AppTypography.displaySmall,
                      ),
                      if (widget.account.isCredit)
                        const SizedBox(height: AppSpacing.lg),
                    ],
                  ),

                if (widget.account.isCredit)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Limite de Crédito',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formatCurrency(widget.account.creditLimit),
                        style: AppTypography.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Utilizado: ${formatCurrency(widget.account.creditUsed)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Disponível: ${formatCurrency(widget.account.creditLimit - widget.account.creditUsed)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: AppSpacing.md),

                // Default Account Switch
                SwitchListTile(
                  value: widget.account.isDefault,
                  onChanged: (_) => _handleToggleDefault(),
                  title: const Text('Conta Padrão'),
                  subtitle: const Text(
                      'Selecionada automaticamente ao criar transações'),
                  contentPadding: const EdgeInsets.symmetric(),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.md),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    TextButton.icon(
                      onPressed: widget.onDelete,
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
          ],
        ),
      ),
    );
  }

  Future<void> _handleToggleDefault() async {
    final accountRepository = widget.ref.read(accountRepositoryProvider);
    final account = widget.account;

    if (account.isDefault) {
      // Clear default flag
      final success = await accountRepository.clearDefaultAccount();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Padrão removido' : 'Erro ao remover padrão',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.background,
              ),
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    } else {
      // Set as default
      final success = await accountRepository.setDefaultAccount(account.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? '"${account.name}" definida como padrão'
                  : 'Erro ao definir padrão',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.background,
              ),
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }
}
