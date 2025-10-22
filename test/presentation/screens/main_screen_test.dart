import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_experience/presentation/screens/main_screen.dart';
import 'package:golden_experience/domain/models/dashboard_data.dart';
import 'package:golden_experience/domain/usecases/providers/usecase_providers.dart';

void main() {
  group('MainScreen Navigation Tests', () {
    /// Creates mock dashboard data for testing
    DashboardData _createMockDashboardData() {
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

    testWidgets('MainScreen displays with 3 tabs in BottomNavigationBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield _createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify BottomNavigationBar exists
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify all 3 tabs exist
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.repeat), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);

      // Verify tab labels (multiple occurrences expected - in AppBar and bottom nav)
      expect(find.text('Início'), findsWidgets);
      expect(find.text('Recorrências'), findsOneWidget);
      expect(find.text('Contas'), findsOneWidget);
    });

    testWidgets('Initial tab is Dashboard (Início)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield _createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Dashboard screen should show initially (check for dashboard-specific UI)
      expect(find.text('Você ainda pode gastar este mês'), findsOneWidget);
    });

    testWidgets('Tap on Recorrências tab navigates to RecurringExpensesScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield _createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the Recorrências tab
      await tester.tap(find.byIcon(Icons.repeat));
      await tester.pumpAndSettle();

      // Verify RecurringExpensesScreen is displayed (check by tab index)
      final bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, equals(1));
    });

    testWidgets('Tap on Contas tab navigates to AccountsScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield _createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the Contas tab
      await tester.tap(find.byIcon(Icons.account_balance_wallet));
      await tester.pumpAndSettle();

      // Verify AccountsScreen is displayed (check by tab index)
      final bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, equals(2));
    });

    testWidgets('Can navigate back and forth between tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield _createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Start at Dashboard
      expect(find.text('Você ainda pode gastar este mês'), findsOneWidget);

      // Go to Recorrências
      await tester.tap(find.byIcon(Icons.repeat));
      await tester.pumpAndSettle();
      var bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, equals(1));

      // Go to Contas
      await tester.tap(find.byIcon(Icons.account_balance_wallet));
      await tester.pumpAndSettle();
      bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, equals(2));

      // Back to Dashboard
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.text('Você ainda pode gastar este mês'), findsOneWidget);
    });

    testWidgets('Dashboard shows Settings icon in AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield _createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Settings button should be visible in Dashboard
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Dashboard screen has FAB for adding items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardDataStreamProvider.overrideWith((ref) async* {
              yield _createMockDashboardData();
            }),
          ],
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Dashboard should have FAB
      expect(find.byIcon(Icons.add), findsWidgets);

      // Verify FAB is a FloatingActionButton
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
