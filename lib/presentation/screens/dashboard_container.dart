import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/dashboard_view_notifier.dart';
import 'dashboard_screen.dart';
import 'transactions_list_screen.dart';

/// DashboardContainer - Manages switching between Dashboard and Transactions List
/// while keeping the MainScreen navbar visible
///
/// This widget watches the DashboardViewNotifier to determine which view to display.
/// The toggle can be triggered by:
/// - Tapping the Início tab in the BottomNavigationBar
/// - Android back button when on the Transactions view
class DashboardContainer extends ConsumerWidget {
  const DashboardContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardView = ref.watch(dashboardViewProvider);

    return dashboardView == DashboardView.dashboard
        ? DashboardScreen(
            onViewTransactionsPressed: () {
              // Switch to transactions view when button is pressed
              ref.read(dashboardViewProvider.notifier).showTransactions();
            },
          )
        : const TransactionsListScreen();
  }
}
