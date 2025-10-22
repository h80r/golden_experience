import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local_database.dart';
import 'domain/usecases/providers/usecase_providers.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  // Initialize the database before running the app
  await LocalDatabase.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Schedule the recurring expenses processing after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processRecurringExpenses();
    });
  }

  Future<void> _processRecurringExpenses() async {
    try {
      // Get the use case from Riverpod and execute it
      final useCase = ref.read(processRecurringExpensesUseCaseProvider);
      final result = await useCase.execute();

      if (result.success && result.processedCount > 0) {
        // Optionally log the result
        // print('Processed ${result.processedCount} recurring expenses');
      }
    } catch (e) {
      // Silently handle errors during recurring expenses processing
      // The app will still function normally
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Previsor Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
