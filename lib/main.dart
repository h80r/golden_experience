import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local_database.dart';
import 'data/repositories/app_settings_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'domain/usecases/providers/usecase_providers.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database before running the app
  await LocalDatabase.initialize();

  // Initialize default settings if they don't exist
  final appSettingsRepository = AppSettingsRepositoryImpl();
  await appSettingsRepository.initializeDefaults();

  // Seed default categories if they don't exist
  final categoryRepository = CategoryRepositoryImpl();
  await categoryRepository.seedDefaultCategories();

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
    // Watch the app settings to check if onboarding has been completed
    final appSettingsAsync = ref.watch(appSettingsStreamProvider);

    return MaterialApp(
      title: 'Previsor Financeiro',
      theme: AppTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      home: appSettingsAsync.when(
        data: (settings) {
          if (settings != null && settings.hasCompletedOnboarding) {
            return const MainScreen();
          } else {
            return const OnboardingScreen();
          }
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => const MainScreen(), // Fallback to main screen on error
      ),
    );
  }
}
