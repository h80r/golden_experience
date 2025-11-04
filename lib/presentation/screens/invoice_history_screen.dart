import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/text_formatters.dart';
import '../../core/utils/billing_cycle_utils.dart';
import '../../data/providers/repository_providers.dart';
import '../../domain/usecases/providers/invoice_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/common/standard_app_bar.dart';

/// Invoice History Screen - Shows all paid invoices with breakdown
///
/// **F17-T1 Implementation**: Invoice Manager with Time Navigation
///
/// This screen displays a list of all invoices that have been marked as paid.
/// For each invoice, it shows:
/// - The billing period (month/year)
/// - Payment status (always "Pago" since we filter to paid invoices only)
/// - Total amount (calculated dynamically from transactions)
/// - Account breakdown (expandable, calculated dynamically)
class InvoiceHistoryScreen extends ConsumerWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all invoices and filter to only paid ones
    final allInvoicesAsync = ref.watch(
      invoiceRepositoryProvider.select((repo) => repo.watchAll()),
    );

    // Get all accounts for name lookup
    final accountsAsync = ref.watch(accountRepositoryProvider).getAll();

    return Scaffold(
      appBar: const StandardAppBar(title: 'Histórico de Faturas'),
      backgroundColor: AppColors.background,
      body: StreamBuilder(
        stream: allInvoicesAsync,
        builder: (context, invoicesSnapshot) {
          if (invoicesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (invoicesSnapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Erro ao carregar histórico',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      invoicesSnapshot.error.toString(),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final allInvoices = invoicesSnapshot.data ?? [];

          // Separate unpaid (current) and paid invoices
          final unpaidInvoices =
              allInvoices.where((invoice) => !invoice.isPaid).toList();
          final paidInvoices =
              allInvoices.where((invoice) => invoice.isPaid).toList();

          // Sort paid invoices by date (most recent first)
          paidInvoices.sort((a, b) => b.startDate.compareTo(a.startDate));

          if (allInvoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Nenhuma fatura encontrada',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Faturas com transações aparecerão aqui',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return FutureBuilder(
            future: accountsAsync,
            builder: (context, accountsSnapshot) {
              if (!accountsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (accountsSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar contas: ${accountsSnapshot.error}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              }

              final accounts = accountsSnapshot.data!;

              // Combine lists: unpaid invoices first, then paid
              final combinedInvoices = [...unpaidInvoices, ...paidInvoices];

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: combinedInvoices.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final invoice = combinedInvoices[index];
                  final now = DateTime.now();
                  // Current invoice is determined by date range, not payment status
                  final isCurrentPeriod = !now.isBefore(invoice.startDate) &&
                                          !now.isAfter(invoice.endDate);

                  debugPrint('[INVOICE_HISTORY] Invoice ${invoice.id}:');
                  debugPrint('[INVOICE_HISTORY]   Period: ${invoice.startDate} to ${invoice.endDate}');
                  debugPrint('[INVOICE_HISTORY]   isPaid: ${invoice.isPaid}');
                  debugPrint('[INVOICE_HISTORY]   isCurrentPeriod: $isCurrentPeriod');
                  debugPrint('[INVOICE_HISTORY]   Today: $now');

                  return _InvoiceCard(
                    invoice: invoice,
                    accounts: accounts,
                    isCurrentInvoice: isCurrentPeriod,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Individual invoice card with expandable breakdown
///
/// Displays an invoice with:
/// - Period header (e.g., "Fatura de 11/2024")
/// - Payment status indicator (or "ATUAL" badge for unpaid)
/// - Total amount (calculated dynamically)
/// - Expandable account breakdown
class _InvoiceCard extends ConsumerStatefulWidget {
  final dynamic invoice; // InvoiceModel
  final List<dynamic> accounts;
  final bool isCurrentInvoice;

  const _InvoiceCard({
    required this.invoice,
    required this.accounts,
    this.isCurrentInvoice = false,
  });

  @override
  ConsumerState<_InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends ConsumerState<_InvoiceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final invoice = widget.invoice;

    // Watch calculated data for this invoice period
    final calculatedDataAsync = ref.watch(
      invoiceCalculatedDataProvider(
        startDate: invoice.startDate as DateTime,
        endDate: invoice.endDate as DateTime,
      ),
    );

    // Format the billing period (use end date for month/year display)
    final billingPeriodStr =
        DateFormat('MM/yyyy').format(invoice.endDate as DateTime);

    // Format period range for expanded view
    final periodRangeStr = formatBillingCyclePeriod(
      BillingCyclePeriod(
        start: invoice.startDate as DateTime,
        end: invoice.endDate as DateTime,
      ),
    );

    return Card(
      elevation: widget.isCurrentInvoice ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        side: BorderSide(
          color: widget.isCurrentInvoice ? AppColors.primary : AppColors.border,
          width: widget.isCurrentInvoice ? 2 : 1,
        ),
      ),
      child: calculatedDataAsync.when(
        data: (calculatedData) {
          return Column(
            children: [
              // Main invoice info
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Header row: Period and expand icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fatura de $billingPeriodStr',
                                style: AppTypography.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              if (widget.isCurrentInvoice)
                                // Current invoice badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusSmall),
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'ATUAL',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              else if ((invoice as dynamic).isPaid)
                                // Paid status indicator (only if actually paid)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Pago',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Total amount row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            formatCurrency(calculatedData.totalAmount, 'R\$'),
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Expandable hint
                      if (!_isExpanded &&
                          calculatedData.breakdown.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Toque para ver detalhes',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Expanded breakdown
              if (_isExpanded && calculatedData.breakdown.isNotEmpty) ...[
                const Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalhamento por Conta',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...calculatedData.breakdown.entries.map((entry) {
                        final accountId = entry.key;
                        final amount = entry.value;
                        final account = widget.accounts
                            .where((acc) => (acc as dynamic).id == accountId)
                            .firstOrNull;

                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            children: [
                              // Account icon
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusSmall),
                                ),
                                child: Icon(
                                  Icons.credit_card,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),

                              // Account name
                              Expanded(
                                child: Text(
                                  (account as dynamic)?.name ??
                                      'Conta desconhecida',
                                  style: AppTypography.bodyMedium,
                                ),
                              ),

                              // Amount
                              Text(
                                formatCurrency(amount, 'R\$'),
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: AppSpacing.sm),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: AppSpacing.sm),
                      // Billing cycle dates
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Período do ciclo',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            periodRangeStr,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fatura de $billingPeriodStr',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (widget.isCurrentInvoice)
                        // Current invoice badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSmall),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'ATUAL',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        )
                      else if ((invoice as dynamic).isPaid)
                        // Paid status indicator (only if actually paid)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Pago',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'Erro ao calcular valores',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      ),
    );
  }
}
