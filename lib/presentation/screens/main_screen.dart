import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/dashboard_view_notifier.dart';
import 'dashboard_container.dart';
import 'recurring_expenses_screen.dart';
import 'accounts_screen.dart';

/// MainScreen - The main shell of the application with BottomNavigationBar
///
/// Features:
/// - Toggle between Dashboard and Transactions list by tapping the Início tab
/// - Support for Android back button navigation
/// - Standard tab navigation for other sections
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardContainer(),
    const RecurringExpensesScreen(),
    const AccountsScreen(),
  ];

  void _onTabSelected(int index) {
    // Handle Início tab (index 0) toggle
    if (index == 0 && _selectedIndex == 0) {
      // Tapping the already-selected Início tab - toggle between dashboard and transactions
      final notifier = ref.read(dashboardViewProvider.notifier);
      notifier.toggle();
    } else {
      // Switching to a different tab - preserve the dashboard/transactions state
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardView = ref.watch(dashboardViewProvider);

    return PopScope(
      canPop:
          !(_selectedIndex == 0 && dashboardView == DashboardView.transactions),
      onPopInvokedWithResult: (didPop, result) {
        // If we're on the Início tab and viewing transactions, go back to dashboard
        if (!didPop &&
            _selectedIndex == 0 &&
            dashboardView == DashboardView.transactions) {
          final notifier = ref.read(dashboardViewProvider.notifier);
          notifier.showDashboard();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          items: [
            // Dynamic first tab - changes based on dashboard view
            BottomNavigationBarItem(
              icon: Icon(
                dashboardView == DashboardView.dashboard
                    ? Icons.home
                    : Icons.history,
              ),
              label: dashboardView == DashboardView.dashboard
                  ? 'Início'
                  : 'Histórico',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Recorrências',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Contas',
            ),
          ],
        ),
      ),
    );
  }
}
