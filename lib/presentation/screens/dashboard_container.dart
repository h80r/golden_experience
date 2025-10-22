import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'transactions_list_screen.dart';

/// DashboardContainer - Manages switching between Dashboard and Transactions List
/// while keeping the MainScreen navbar visible
class DashboardContainer extends StatefulWidget {
  const DashboardContainer({super.key});

  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {
  bool _showTransactions = false;

  void _switchToTransactions() {
    setState(() {
      _showTransactions = true;
    });
  }

  void _switchToDashboard() {
    setState(() {
      _showTransactions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showTransactions) {
      return TransactionsListScreenWithBack(
        onBackPressed: _switchToDashboard,
      );
    }

    return DashboardScreenWithTransactions(
      onViewTransactionsPressed: _switchToTransactions,
    );
  }
}

/// Wraps DashboardScreen with the transactions button callback
class DashboardScreenWithTransactions extends StatelessWidget {
  final VoidCallback onViewTransactionsPressed;

  const DashboardScreenWithTransactions({
    super.key,
    required this.onViewTransactionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    // We'll inject the callback through a custom DashboardScreen
    // For now, we pass it through InheritedWidget or modify DashboardScreen
    return DashboardScreen(
      onViewTransactionsPressed: onViewTransactionsPressed,
    );
  }
}

/// Wraps TransactionsListScreen with a back button callback
class TransactionsListScreenWithBack extends StatelessWidget {
  final VoidCallback onBackPressed;

  const TransactionsListScreenWithBack({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TransactionsListScreen(
      onBackPressed: onBackPressed,
    );
  }
}
