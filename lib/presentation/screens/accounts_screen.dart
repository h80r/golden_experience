import 'package:flutter/material.dart';

/// AccountsScreen - Screen for managing accounts
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
      ),
      body: const Center(
        child: Text('Accounts Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new account
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
