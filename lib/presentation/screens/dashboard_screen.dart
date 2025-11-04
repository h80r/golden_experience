import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/expense/expense_details_bottom_sheet.dart';
import '../widgets/dashboard/main_card.dart';
import '../widgets/dashboard/secondary_card.dart';
import '../widgets/common/standard_app_bar.dart';
import '../widgets/dashboard/invoice_payment_button.dart';
import 'invoice_history_screen.dart';
import '../state/expense_form_notifier.dart';
import '../../domain/usecases/providers/usecase_providers.dart';
import '../../domain/usecases/providers/invoice_providers.dart';
import '../../data/providers/repository_providers.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_spacing.dart';
import '../../presentation/theme/app_typography.dart';
import '../../core/utils/billing_cycle_utils.dart';
import 'package:intl/intl.dart';

/// DashboardScreen - The main dashboard showing financial overview
class DashboardScreen extends ConsumerStatefulWidget {
  final VoidCallback? onViewTransactionsPressed;

  const DashboardScreen({
    super.key,
    this.onViewTransactionsPressed,
  });

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the current invoice period on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final periodNotifier = ref.read(currentInvoicePeriodProvider.notifier);
      final currentPeriod = ref.read(currentInvoicePeriodProvider);
      if (currentPeriod == null) {
        periodNotifier.resetToDefault();
      }
    });
  }

  void _handleOpenExpenseSheet(BuildContext context, WidgetRef ref) {
    // Fetch accounts and categories repositories
    final accountRepository = ref.read(accountRepositoryProvider);
    final categoryRepository = ref.read(categoryRepositoryProvider);

    // Load data before showing bottom sheet to prevent rebuilds
    Future.wait([
      accountRepository.getAll(),
      categoryRepository.getAll(),
      accountRepository.getDefaultAccount(),
      categoryRepository.getDefaultCategory(),
    ]).then((results) {
      if (!context.mounted) return;

      final accounts = results[0] as List;
      final categories = results[1] as List;
      final defaultAccount = results[2] as dynamic;
      final defaultCategory = results[3] as dynamic;

      // Convert lists to maps for the bottom sheet
      final accountsMap = {
        for (var account in accounts) account.id as int: account.name as String
      };
      final categoriesMap = {
        for (var category in categories)
          category.id as int: category.name as String
      };

      // Get default account ID if available
      int? initialAccountId;
      if (defaultAccount != null) {
        initialAccountId = defaultAccount.id as int;
      }

      // Get default category ID if available
      int? initialCategoryId;
      if (defaultCategory != null) {
        initialCategoryId = defaultCategory.id as int;
      }

      // Show expense details bottom sheet with pre-selected defaults
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ExpenseDetailsBottomSheet(
          accounts: accountsMap,
          categories: categoriesMap,
          initialAccountId: initialAccountId,
          initialCategoryId: initialCategoryId,
          onSave: ({
            required value,
            required description,
            required notes,
            required accountId,
            required transactionType,
            required categoryId,
            required date,
          }) async {
            // Get the add transaction use case
            final addTransactionUseCase =
                ref.read(addTransactionUseCaseProvider);

            // Create and save the transaction
            final result = await addTransactionUseCase.execute(
              value: value,
              description: description,
              notes: notes,
              accountId: accountId,
              categoryId: categoryId,
              transactionType: transactionType,
              date: date,
            );

            // Handle result
            if (!context.mounted) return;

            // Reset form state for next transaction
            ref.read(expenseFormProvider.notifier).reset();

            // Close the modal first
            Navigator.of(context).pop();

            // Show feedback after modal is closed
            if (result.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transação salva com sucesso!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(result.errorMessage ?? 'Erro ao salvar transação'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
            // Reset form state
            ref.read(expenseFormProvider.notifier).reset();
          },
        ),
      );
    }).catchError((error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  Future<dynamic> _getOrCreateInvoice(
      BillingCyclePeriod? period, WidgetRef ref) async {
    debugPrint('[DASHBOARD_INVOICE] ========== Get or Create Invoice ==========');
    debugPrint('[DASHBOARD_INVOICE] Period: ${period?.start} to ${period?.end}');

    if (period == null) {
      debugPrint('[DASHBOARD_INVOICE] ❌ Period is null');
      return null;
    }

    final invoiceRepo = ref.read(invoiceRepositoryProvider);

    // Try to get existing invoice
    var invoice = await invoiceRepo.getByPeriod(
      startDate: period.start,
      endDate: period.end,
    );

    debugPrint('[DASHBOARD_INVOICE] Existing invoice: ${invoice != null ? "ID ${invoice.id}, isPaid=${invoice.isPaid}" : "not found"}');

    // If invoice doesn't exist, check if there are transactions in this period
    if (invoice == null) {
      debugPrint('[DASHBOARD_INVOICE] Invoice doesn\'t exist, checking for transactions...');

      final calculatedData = await ref.read(
        invoiceCalculatedDataProvider(
          startDate: period.start,
          endDate: period.end,
        ).future,
      );

      debugPrint('[DASHBOARD_INVOICE] Found ${calculatedData.transactionCount} transactions');

      // If there are transactions, create the invoice automatically
      if (calculatedData.transactionCount > 0) {
        debugPrint('[DASHBOARD_INVOICE] ✅ Creating new invoice');
        await invoiceRepo.create(
          startDate: period.start,
          endDate: period.end,
        );
        // Fetch the newly created invoice
        invoice = await invoiceRepo.getByPeriod(
          startDate: period.start,
          endDate: period.end,
        );
        debugPrint('[DASHBOARD_INVOICE] New invoice created: ID ${invoice?.id}');
      } else {
        debugPrint('[DASHBOARD_INVOICE] ℹ️ No transactions, not creating invoice');
      }
    }

    return invoice;
  }

  Widget _buildPeriodHeader(BillingCyclePeriod? period) {
    if (period == null) return const SizedBox.shrink();

    final dateFormat = DateFormat('MMM yyyy', 'pt_BR');
    final monthYear = dateFormat.format(period.start).toUpperCase();

    final detailFormat = DateFormat('dd/MM');
    final dateRange =
        '${detailFormat.format(period.start)} - ${detailFormat.format(period.end)}';

    final periodNotifier = ref.read(currentInvoicePeriodProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: () async {
              await periodNotifier.goToPreviousPeriod();
            },
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            children: [
              Text(
                monthYear,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Período: $dateRange',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 28),
            onPressed: () async {
              await periodNotifier.goToNextPeriod();
            },
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the reactive dashboard data stream
    final dashboardDataAsync = ref.watch(dashboardDataStreamProvider);
    final currentPeriod = ref.watch(currentInvoicePeriodProvider);

    return Scaffold(
      appBar: const StandardAppBar(title: 'Início'),
      backgroundColor: AppColors.background,
      body: dashboardDataAsync.when(
        data: (dashboardData) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period navigation header (minimal/discrete)
              _buildPeriodHeader(currentPeriod),

              // Main card - Remaining budget
              MainCard(
                remainingBudget: dashboardData.remainingBudget,
                reserveUsagePercentage: dashboardData.reserveUsagePercentage,
                isLoading: false,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Secondary card - Financial details
              SecondaryCard(
                monthlySalary: dashboardData.monthlySalary,
                totalSpent: dashboardData.totalSpent,
                partialResult: dashboardData.partialResult,
                finalReserve: dashboardData.finalReserve,
                isLoading: false,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Transactions button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Ver todas as transações'),
                  onPressed: widget.onViewTransactionsPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Invoice management buttons row
              FutureBuilder(
                future: _getOrCreateInvoice(currentPeriod, ref),
                builder: (context, snapshot) {
                  // Show loading indicator while fetching/creating invoice
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.receipt),
                            label: const Text('Ver todas as faturas'),
                            onPressed: null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Expanded(
                          child: Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final invoice = snapshot.data;

                  return Row(
                    children: [
                      // "Ver todas as faturas" button
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.receipt),
                          label: const Text('Ver todas as faturas'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const InvoiceHistoryScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.md,
                            ),
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // "Pagar Fatura" button
                      Expanded(
                        child: InvoicePaymentButton(
                          invoiceId: invoice?.id,
                          isPaid: invoice?.isPaid ?? false,
                          onPaymentStatusChanged: () {
                            setState(() {
                              // Trigger rebuild to refresh invoice status
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main card - Loading state
              MainCard(
                remainingBudget: 0.0,
                reserveUsagePercentage: 0.0,
                isLoading: true,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Secondary card - Loading state
              SecondaryCard(
                monthlySalary: 0.0,
                totalSpent: 0.0,
                partialResult: 0.0,
                finalReserve: 0.0,
                isLoading: true,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Transactions button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Ver todas as transações'),
                  onPressed: widget.onViewTransactionsPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48.0,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Erro ao carregar dados',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        heroTag: 'dashboard_fab',
        onPressed: () {
          // Open expense details bottom sheet directly
          _handleOpenExpenseSheet(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
