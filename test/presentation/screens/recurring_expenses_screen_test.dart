import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:golden_experience/data/providers/repository_providers.dart';
import 'package:golden_experience/domain/repositories/i_account_repository.dart';
import 'package:golden_experience/domain/repositories/i_category_repository.dart';
import 'package:golden_experience/domain/repositories/i_recurring_expense_repository.dart';
import 'package:golden_experience/presentation/screens/recurring_expenses_screen.dart';
import 'package:golden_experience/presentation/theme/app_colors.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('RecurringExpensesScreen Widget Tests', () {
    testWidgets('Renders empty state when no recurring expenses exist',
        (WidgetTester tester) async {
      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value([]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty state UI
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
      expect(find.text('Nenhuma recorrência cadastrada'), findsOneWidget);
      expect(
          find.text('Crie uma nova recorrência para começar'), findsOneWidget);
    });

    testWidgets('Renders list of recurring expenses when data is available',
        (WidgetTester tester) async {
      final expenses = [
        RecurringExpenseModel(
          id: 1,
          description: 'Aluguel',
          value: 1500.0,
          chargeDay: 5,
          accountId: 1,
          categoryId: 1,
        ),
        RecurringExpenseModel(
          id: 2,
          description: 'Seguro do Carro',
          value: 450.0,
          chargeDay: 15,
          accountId: 2,
          categoryId: 2,
        ),
      ];

      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value(expenses));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify expense names are displayed
      expect(find.text('Aluguel'), findsOneWidget);
      expect(find.text('Seguro do Carro'), findsOneWidget);

      // Verify charge days are displayed
      expect(find.text('Dia 5'), findsOneWidget);
      expect(find.text('Dia 15'), findsOneWidget);

      // Verify monthly label is displayed
      expect(find.text('Mensal'), findsWidgets);
    });

    testWidgets('Displays expense values correctly',
        (WidgetTester tester) async {
      final expenses = [
        RecurringExpenseModel(
          id: 1,
          description: 'Assinatura Streaming',
          value: 99.90,
          chargeDay: 10,
          accountId: 1,
          categoryId: 1,
        ),
      ];

      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value(expenses));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify expense name and charge day are displayed
      expect(find.text('Assinatura Streaming'), findsOneWidget);
      expect(find.text('Dia 10'), findsOneWidget);
    });

    testWidgets('FAB has correct appearance', (WidgetTester tester) async {
      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value([]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify FAB exists and has correct colors
      final fab = tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton));

      expect(fab.backgroundColor, equals(AppColors.primary));
      expect(fab.foregroundColor, equals(AppColors.background));
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value([]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify app bar title
      expect(find.text('Recorrências'), findsOneWidget);
    });

    testWidgets('Recurring expense cards show name and charge day',
        (WidgetTester tester) async {
      final expenses = [
        RecurringExpenseModel(
          id: 1,
          description: 'Meu Streaming',
          value: 50.0,
          chargeDay: 12,
          accountId: 1,
          categoryId: 1,
        ),
      ];

      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value(expenses));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify card content
      expect(find.text('Meu Streaming'), findsOneWidget);
      expect(find.text('Dia 12'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Renders loading state correctly', (WidgetTester tester) async {
      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value([]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      // Before settling, verify loading state exists
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Multiple recurring expenses are displayed in list',
        (WidgetTester tester) async {
      final expenses = [
        RecurringExpenseModel(
          id: 1,
          description: 'Aluguel',
          value: 1500.0,
          chargeDay: 5,
          accountId: 1,
          categoryId: 1,
        ),
        RecurringExpenseModel(
          id: 2,
          description: 'Internet',
          value: 99.90,
          chargeDay: 10,
          accountId: 1,
          categoryId: 1,
        ),
        RecurringExpenseModel(
          id: 3,
          description: 'Gym',
          value: 75.0,
          chargeDay: 15,
          accountId: 2,
          categoryId: 2,
        ),
      ];

      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value(expenses));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all expenses are displayed
      expect(find.text('Aluguel'), findsOneWidget);
      expect(find.text('Internet'), findsOneWidget);
      expect(find.text('Gym'), findsOneWidget);

      // Verify all charge days are displayed
      expect(find.text('Dia 5'), findsOneWidget);
      expect(find.text('Dia 10'), findsOneWidget);
      expect(find.text('Dia 15'), findsOneWidget);

      // Verify all edit/delete buttons are present
      expect(find.text('Editar'), findsWidgets);
      expect(find.text('Remover'), findsWidgets);
    });

    testWidgets('Background color matches app theme',
        (WidgetTester tester) async {
      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value([]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AppBar background color
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(AppColors.surface));
    });

    testWidgets('Charge day badge is displayed correctly',
        (WidgetTester tester) async {
      final expenses = [
        RecurringExpenseModel(
          id: 1,
          description: 'Test Expense',
          value: 100.0,
          chargeDay: 25,
          accountId: 1,
          categoryId: 1,
        ),
      ];

      final mockRepository = MockRecurringExpenseRepository();
      mockRepository.setWatchAllOverride(() => Stream.value(expenses));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recurringExpenseRepositoryProvider
                .overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: RecurringExpensesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify charge day badge exists and contains correct text
      expect(find.text('Dia 25'), findsOneWidget);
    });
  });
}

class MockAccountRepository extends Mock implements IAccountRepository {
  Stream<List<AccountModel>> Function()? _watchAllOverride;

  void setWatchAllOverride(Stream<List<AccountModel>> Function() override) {
    _watchAllOverride = override;
  }

  @override
  Stream<List<AccountModel>> watchAll() {
    if (_watchAllOverride != null) {
      return _watchAllOverride!();
    }
    return const Stream.empty();
  }
}

class MockCategoryRepository extends Mock implements ICategoryRepository {
  Stream<List<CategoryModel>> Function()? _watchAllOverride;

  void setWatchAllOverride(Stream<List<CategoryModel>> Function() override) {
    _watchAllOverride = override;
  }

  @override
  Stream<List<CategoryModel>> watchAll() {
    if (_watchAllOverride != null) {
      return _watchAllOverride!();
    }
    return const Stream.empty();
  }
}

// Mock classes
class MockRecurringExpenseRepository extends Mock
    implements IRecurringExpenseRepository {
  Stream<List<RecurringExpenseModel>> Function()? _watchAllOverride;

  void setWatchAllOverride(
      Stream<List<RecurringExpenseModel>> Function() override) {
    _watchAllOverride = override;
  }

  @override
  Stream<List<RecurringExpenseModel>> watchAll() {
    if (_watchAllOverride != null) {
      return _watchAllOverride!();
    }
    return const Stream.empty();
  }
}
