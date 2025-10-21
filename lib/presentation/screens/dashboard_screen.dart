import 'package:flutter/material.dart';

/// DashboardScreen - The main dashboard showing financial overview
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          // TODO: Open calculator overlay for adding expense
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
