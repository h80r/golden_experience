import 'package:flutter/material.dart';

/// RecurringExpensesScreen - Screen for managing recurring expenses
class RecurringExpensesScreen extends StatelessWidget {
  const RecurringExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorrências'),
      ),
      body: const Center(
        child: Text('Recurring Expenses Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new recurring expense
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
