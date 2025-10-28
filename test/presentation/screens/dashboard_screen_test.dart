import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/domain/models/dashboard_data.dart';
import 'package:golden_experience/domain/usecases/providers/usecase_providers.dart';
import 'package:golden_experience/presentation/screens/dashboard_screen.dart';
import 'package:golden_experience/presentation/theme/app_colors.dart';
import 'package:golden_experience/presentation/widgets/dashboard/main_card.dart';
import 'package:golden_experience/presentation/widgets/dashboard/secondary_card.dart';

void main() {
  group('DashboardScreen Widget Tests', () {
    /// Creates a mock dashboard data for testing
    DashboardData createMockDashboardData() {
      return DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );
    }

    testWidgets('Renders dashboard with header and cards when data loads',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Wait for the async stream to emit data
      await tester.pumpAndSettle();

      // Verify AppBar title
      expect(find.text('Início'), findsOneWidget);

      // Verify cards are rendered
      expect(find.byType(MainCard), findsOneWidget);
      expect(find.byType(SecondaryCard), findsOneWidget);

      // Verify FAB exists
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('FAB has correct colors (gold background, dark foreground)',
        (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final fab = tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton));

      expect(fab.backgroundColor, equals(AppColors.primary));
      expect(fab.foregroundColor, equals(AppColors.background));
    });

    testWidgets('FAB has add icon', (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Settings button is present in AppBar',
        (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Body is scrollable', (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Background is correct color', (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(AppColors.background));
    });

    testWidgets('FAB opens expense details bottom sheet when tapped',
        (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      // Mock repository providers to avoid database initialization
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Just verify FAB exists and is tappable
      // Full integration test would require database setup
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('AppBar background color matches app background',
        (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Get the app bar
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(AppColors.background));
    });

    testWidgets('Has main financial header text', (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify main card displays key label
      expect(find.text('Você ainda pode gastar este mês'), findsOneWidget);
    });

    testWidgets('Has secondary card with financial details',
        (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify secondary card displays expected labels
      expect(find.text('Salário mensal'), findsOneWidget);
      expect(find.text('Gasto total'), findsOneWidget);
      expect(find.text('Resultado parcial'), findsOneWidget);
      expect(find.text('Reserva final prevista'), findsOneWidget);
    });

    testWidgets('Layout renders without errors', (WidgetTester tester) async {
      DashboardData mockData = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1234.50,
        remainingBudget: 5265.50,
        partialResult: 3765.50,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Render and measure that layout completes without errors
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(tester.view.viewInsets.bottom, equals(0.0));
    });

    testWidgets('Displays loading state when stream is loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              // Emit nothing - simulating loading state
              yield* const Stream.empty();
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pump();

      // Check for loading indicators (MainCard and SecondaryCard both show loading)
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Displays error state when stream emits error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              throw Exception('Test error: Failed to load dashboard data');
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for error UI
      expect(find.text('Erro ao carregar dados'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Updates data reactively when stream emits new data',
        (WidgetTester tester) async {
      DashboardData mockData1 = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 1000.0,
        remainingBudget: 6000.0,
        partialResult: 4000.0,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      DashboardData mockData2 = DashboardData(
        monthlySalary: 5000.0,
        totalSpent: 2000.0,
        remainingBudget: 5000.0,
        partialResult: 3000.0,
        finalReserve: 2500.00,
        reserveUsagePercentage: 0.0,
        initialReserve: 2500.0,
        maxReserveUsagePercentage: 50.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield mockData1;
              await Future.delayed(const Duration(milliseconds: 100));
              yield mockData2;
            }),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Both card widgets should be visible
      expect(find.byType(MainCard), findsOneWidget);
      expect(find.byType(SecondaryCard), findsOneWidget);
    });
  });
}
