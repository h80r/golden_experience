import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/calculator/calculator_overlay.dart';
import '../widgets/expense/expense_details_bottom_sheet.dart';
import '../state/expense_form_notifier.dart';
import '../../domain/usecases/providers/usecase_providers.dart';
import '../../data/providers/repository_providers.dart';

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

    // Show expense details bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FutureBuilder(
        future: Future.wait([
          accountRepository.getAll(),
          categoryRepository.getAll(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Erro ao carregar dados'),
            );
          }

          final accounts = snapshot.data![0] as List;
          final categories = snapshot.data![1] as List;

          // Convert lists to maps for the bottom sheet
          final accountsMap = {
            for (var account in accounts)
              account.id as int: account.name as String
          };
          final categoriesMap = {
            for (var category in categories)
              category.id as int: category.name as String
          };

          return ExpenseDetailsBottomSheet(
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

              if (result.success) {
                // Reset form state for next transaction
                ref.read(expenseFormProvider.notifier).reset();
                Navigator.of(context).pop();

                // Show success feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transação salva com sucesso!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // Show error feedback
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
          );
        },
      ),
    );
  }

  void _handleCalculatorCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Dashboard Screen'),
      ),
      floatingActionButton: FloatingActionButton(
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
