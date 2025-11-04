import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/billing_cycle_utils.dart';
import '../../core/utils/text_formatters.dart';
import '../../data/providers/repository_providers.dart';
import '../../domain/usecases/providers/invoice_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/common/standard_app_bar.dart';
import '../widgets/dashboard/invoice_payment_button.dart';
import 'invoice_history_screen.dart';

/// Invoice Details Screen showing full breakdown of a specific invoice period
///
/// **F17-T2 Implementation**: Invoice Details View
///
/// Displays comprehensive invoice information including:
/// - Period and total amount
/// - Payment status
/// - Account-by-account breakdown
/// - Full transaction list for the period
/// - Payment toggle button
class InvoiceDetailsScreen extends ConsumerStatefulWidget {
  final BillingCyclePeriod period;

  const InvoiceDetailsScreen({
    super.key,
    required this.period,
  });

  @override
  ConsumerState<InvoiceDetailsScreen> createState() =>
      _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends ConsumerState<InvoiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch calculated invoice data
    final calculatedDataAsync = ref.watch(
      invoiceCalculatedDataProvider(
        startDate: widget.period.start,
        endDate: widget.period.end,
      ),
    );

    final dateFormat = DateFormat('dd/MM/yyyy');
    final periodText =
        '${dateFormat.format(widget.period.start)} - ${dateFormat.format(widget.period.end)}';

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Detalhes da Fatura',
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const InvoiceHistoryScreen(),
                ),
              );
            },
            tooltip: 'Ver Histórico Completo',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: calculatedDataAsync.when(
        data: (calculatedData) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period header
                Text(
                  'Período da Fatura',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  periodText,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Total amount card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total da Fatura',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        formatCurrency(calculatedData.totalAmount, 'R\$'),
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${calculatedData.transactionCount} transações',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Account breakdown
                if (calculatedData.breakdown.isNotEmpty) ...[
                  Text(
                    'Detalhamento por Conta',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FutureBuilder(
                    future: ref.read(accountRepositoryProvider).getAll(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final accounts = snapshot.data!;
                      return Column(
                        children:
                            calculatedData.breakdown.entries.map((entry) {
                          final account = accounts
                              .where((a) => a.id == entry.key)
                              .firstOrNull;
                          final accountName =
                              account?.name ?? 'Conta desconhecida';

                          return Container(
                            margin: const EdgeInsets.only(
                                bottom: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMedium),
                              border: Border.all(color: AppColors.border),
                            ),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    accountName,
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  formatCurrency(entry.value, 'R\$'),
                                  style: AppTypography.headlineSmall.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // Payment button
                FutureBuilder(
                  future: ref.read(invoiceRepositoryProvider).getByPeriod(
                        startDate: widget.period.start,
                        endDate: widget.period.end,
                      ),
                  builder: (context, snapshot) {
                    final invoice = snapshot.data;
                    return InvoicePaymentButton(
                      invoiceId: invoice?.id,
                      isPaid: invoice?.isPaid ?? false,
                      onPaymentStatusChanged: () {
                        setState(() {
                          // Trigger rebuild to refresh data
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Erro ao carregar detalhes',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error.toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
