import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_experience/presentation/screens/main_screen.dart';

void main() {
  group('MainScreen Navigation Tests', () {
    testWidgets('MainScreen displays with 3 tabs in BottomNavigationBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

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
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      // Dashboard screen should show initially
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });

    testWidgets('Tap on Recorrências tab navigates to RecurringExpensesScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      // Tap on the Recorrências tab
      await tester.tap(find.byIcon(Icons.repeat));
      await tester.pumpAndSettle();

      // Verify RecurringExpensesScreen is displayed
      expect(find.text('Recurring Expenses Screen'), findsOneWidget);
    });

    testWidgets('Tap on Contas tab navigates to AccountsScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      // Tap on the Contas tab
      await tester.tap(find.byIcon(Icons.account_balance_wallet));
      await tester.pumpAndSettle();

      // Verify AccountsScreen is displayed
      expect(find.text('Accounts Screen'), findsOneWidget);
    });

    testWidgets('Can navigate back and forth between tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      // Start at Dashboard
      expect(find.text('Dashboard Screen'), findsOneWidget);

      // Go to Recorrências
      await tester.tap(find.byIcon(Icons.repeat));
      await tester.pumpAndSettle();
      expect(find.text('Recurring Expenses Screen'), findsOneWidget);

      // Go to Contas
      await tester.tap(find.byIcon(Icons.account_balance_wallet));
      await tester.pumpAndSettle();
      expect(find.text('Accounts Screen'), findsOneWidget);

      // Back to Dashboard
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });

    testWidgets('Dashboard shows Settings icon in AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      // Settings button should be visible in Dashboard
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('All screens have FAB for adding items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      // Dashboard should have FAB
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Recorrências should have FAB
      await tester.tap(find.byIcon(Icons.repeat));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Contas should have FAB
      await tester.tap(find.byIcon(Icons.account_balance_wallet));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
