import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/calculator/calculator_overlay.dart';
import '../widgets/expense/expense_details_bottom_sheet.dart';
import '../widgets/dashboard/main_card.dart';
import '../widgets/dashboard/secondary_card.dart';
import '../state/expense_form_notifier.dart';
import '../../domain/usecases/providers/usecase_providers.dart';
import '../../data/providers/repository_providers.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_spacing.dart';
import 'settings_screen.dart';

/// DashboardScreen - The main dashboard showing financial overview
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _handleCalculatorConfirm(
    BuildContext context,
    WidgetRef ref,
    double value,
  ) {
    // Close calculator overlay
    Navigator.of(context).pop();

    // Fetch accounts and categories repositories
    final accountRepository = ref.read(accountRepositoryProvider);
    final categoryRepository = ref.read(categoryRepositoryProvider);

    // Load data before showing bottom sheet to prevent rebuilds
    Future.wait([
      accountRepository.getAll(),
      categoryRepository.getAll(),
    ]).then((results) {
      if (!context.mounted) return;

      final accounts = results[0] as List;
      final categories = results[1] as List;

      // Convert lists to maps for the bottom sheet
      final accountsMap = {
        for (var account in accounts)
          account.id as int: account.name as String
      };
      final categoriesMap = {
        for (var category in categories)
          category.id as int: category.name as String
      };

      // Show expense details bottom sheet with pre-loaded data
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ExpenseDetailsBottomSheet(
          initialValue: value,
          accounts: accountsMap,
          categories: categoriesMap,
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
                  content: Text(result.errorMessage ?? 'Erro ao salvar transação'),
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

  void _handleCalculatorCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the reactive dashboard data stream
    final dashboardDataAsync = ref.watch(dashboardDataStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: dashboardDataAsync.when(
        data: (dashboardData) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        onPressed: () {
          // Open calculator overlay
          showDialog(
            context: context,
            builder: (context) => CalculatorOverlay(
              onConfirm: (value) =>
                  _handleCalculatorConfirm(context, ref, value),
              onCancel: () => _handleCalculatorCancel(context),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
