import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/text_formatters.dart';
import '../../../core/utils/billing_cycle_utils.dart';
import '../../../data/providers/repository_providers.dart';
import '../../../domain/usecases/providers/invoice_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Invoice manager card for dashboard with time navigation
///
/// **F17-T1 Implementation**: Invoice Manager with Time Navigation
///
/// This widget displays the current billing cycle invoice with:
/// - Month/Year header instead of "Início"
/// - Swipe gestures for time navigation
/// - Arrow buttons for navigation
/// - Dynamic calculation of amounts
/// - Mark as paid functionality
/// - Only shows periods with transactions
class InvoiceManagerCard extends ConsumerStatefulWidget {
  final VoidCallback? onViewHistory;

  const InvoiceManagerCard({
    super.key,
    this.onViewHistory,
  });

  @override
  ConsumerState<InvoiceManagerCard> createState() =>
      _InvoiceManagerCardState();
}

class _InvoiceManagerCardState extends ConsumerState<InvoiceManagerCard> {
  @override
  void initState() {
    super.initState();
    // Initialize the current period to default on first load
    Future.microtask(() {
      final currentPeriod = ref.read(currentInvoicePeriodProvider);
      if (currentPeriod == null) {
        ref.read(currentInvoicePeriodProvider.notifier).resetToDefault();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current period being viewed
    final currentPeriod = ref.watch(currentInvoicePeriodProvider);

    if (currentPeriod == null) {
      // Still loading default period
      return _buildLoadingCard();
    }

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              // Swipe right - go to previous period
              ref.read(currentInvoicePeriodProvider.notifier).goToPreviousPeriod();
            } else if (details.primaryVelocity! < 0) {
              // Swipe left - go to next period
              ref.read(currentInvoicePeriodProvider.notifier).goToNextPeriod();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with navigation
                _buildHeader(currentPeriod),
                const SizedBox(height: AppSpacing.md),

                // Period display
                _buildPeriodDisplay(currentPeriod),
                const SizedBox(height: AppSpacing.lg),

                // Invoice content (dynamic calculated data)
                _buildInvoiceContent(currentPeriod),
              ],
            ),
          ),
        );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildHeader(BillingCyclePeriod period) {
    // Format month/year from the period end date
    final monthYear = DateFormat('MMM/yyyy', 'pt_BR').format(period.end);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left arrow
        IconButton(
          onPressed: () {
            ref.read(currentInvoicePeriodProvider.notifier).goToPreviousPeriod();
          },
          icon: const Icon(Icons.chevron_left),
          color: AppColors.primary,
          iconSize: 28,
        ),

        // Center: Month/Year with icon
        Expanded(
          child: Column(
            children: [
              const Icon(
                Icons.credit_card,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Fatura',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                monthYear.toUpperCase(),
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Right arrow
        IconButton(
          onPressed: () {
            ref.read(currentInvoicePeriodProvider.notifier).goToNextPeriod();
          },
          icon: const Icon(Icons.chevron_right),
          color: AppColors.primary,
          iconSize: 28,
        ),
      ],
    );
  }

  Widget _buildPeriodDisplay(BillingCyclePeriod period) {
    final periodText = formatBillingCyclePeriod(period);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Período: $periodText',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (widget.onViewHistory != null)
          TextButton.icon(
            onPressed: widget.onViewHistory,
            icon: const Icon(Icons.history, size: 16),
            label: const Text('Histórico'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInvoiceContent(
    BillingCyclePeriod period,
  ) {
    final invoiceRepo = ref.watch(invoiceRepositoryProvider);

    return FutureBuilder(
      future: invoiceRepo.getByPeriod(
        startDate: period.start,
        endDate: period.end,
      ),
      builder: (context, invoiceSnapshot) {
        final invoice = invoiceSnapshot.data;

        // Watch calculated data for this period
        final calculatedDataAsync = ref.watch(
          invoiceCalculatedDataProvider(
            startDate: period.start,
            endDate: period.end,
          ),
        );

        return calculatedDataAsync.when(
          data: (calculatedData) {
            // If there are no transactions, show empty state
            if (calculatedData.transactionCount == 0) {
              return _buildEmptyState();
            }

            // Auto-create invoice if it doesn't exist and has transactions
            if (invoice == null) {
              Future.microtask(() => _createInvoiceForPeriod(period));
            }

            return _buildInvoiceDetails(
              invoice,
              calculatedData,
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Text(
            'Erro ao calcular fatura',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nenhuma transação neste período',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails(
    dynamic invoice,
    InvoiceCalculatedData calculatedData,
  ) {
    final isPaid = invoice?.isPaid ?? false;
    final accountsAsync = ref.watch(accountRepositoryProvider).getAll();

    return FutureBuilder(
      future: accountsAsync,
      builder: (context, accountsSnapshot) {
        // Default to empty list if accounts not loaded yet
        final accounts = accountsSnapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total da Fatura',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  formatCurrency(calculatedData.totalAmount, 'R\$'),
                  style: AppTypography.titleLarge.copyWith(
                    color: isPaid ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isPaid
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPaid ? Icons.check_circle : Icons.pending,
                    size: 16,
                    color: isPaid ? AppColors.success : AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    isPaid ? 'Fatura Paga' : 'Aguardando Pagamento',
                    style: AppTypography.bodySmall.copyWith(
                      color: isPaid ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Account breakdown
            if (calculatedData.breakdown.isNotEmpty) ...[
              Text(
                'Detalhamento por Conta',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...calculatedData.breakdown.entries.map((entry) {
                final accountId = entry.key;
                final amount = entry.value;
                final account = accounts
                    .where((acc) => (acc as dynamic).id == accountId)
                    .firstOrNull;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (account as dynamic)?.name ?? 'Conta desconhecida',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        formatCurrency(amount, 'R\$'),
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Action buttons
            if (invoice != null)
              SizedBox(
                width: double.infinity,
                child: isPaid
                    ? OutlinedButton.icon(
                        onPressed: () => _unmarkInvoiceAsPaid(invoice),
                        icon: const Icon(Icons.undo),
                        label: const Text('Desmarcar como Pago'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          side: const BorderSide(color: AppColors.warning),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => _markInvoiceAsPaid(invoice),
                        icon: const Icon(Icons.check),
                        label: const Text('Marcar como Pago'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                      ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _createInvoiceForPeriod(BillingCyclePeriod period) async {
    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      await invoiceRepo.create(
        startDate: period.start,
        endDate: period.end,
        isPaid: false,
      );
    } catch (e) {
      // Silently fail - invoice might already exist from concurrent creation
      debugPrint('Error creating invoice: $e');
    }
  }

  Future<void> _markInvoiceAsPaid(dynamic invoice) async {
    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      final success = await invoiceRepo.markAsPaid((invoice as dynamic).id);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fatura marcada como paga!'),
            backgroundColor: AppColors.success,
          ),
        );
        // Refresh the UI by invalidating the calculated data provider
        ref.invalidate(invoiceCalculatedDataProvider);
      } else {
        throw Exception('Failed to mark as paid');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao marcar fatura como paga: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _unmarkInvoiceAsPaid(dynamic invoice) async {
    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      final success = await invoiceRepo.unmarkPaid((invoice as dynamic).id);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fatura desmarcada como paga!'),
            backgroundColor: AppColors.warning,
          ),
        );
        // Refresh the UI by invalidating the calculated data provider
        ref.invalidate(invoiceCalculatedDataProvider);
      } else {
        throw Exception('Failed to unmark paid');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao desmarcar fatura: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
