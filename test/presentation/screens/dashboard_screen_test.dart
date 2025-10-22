import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/screens/dashboard_screen.dart';
import 'package:golden_experience/presentation/widgets/dashboard/main_card.dart';
import 'package:golden_experience/presentation/widgets/dashboard/secondary_card.dart';
import 'package:golden_experience/presentation/widgets/calculator/calculator_overlay.dart';
import 'package:golden_experience/presentation/theme/app_colors.dart';

void main() {
  group('DashboardScreen Widget Tests', () {
    testWidgets('Renders dashboard with header and cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

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
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
          find.byType(FloatingActionButton));

      expect(fab.backgroundColor, equals(AppColors.primary));
      expect(fab.foregroundColor, equals(AppColors.background));
    });

    testWidgets('FAB has add icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Settings button is present in AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Body is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Background is correct color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(AppColors.background));
    });

    testWidgets('FAB opens calculator overlay when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify calculator overlay is shown
      expect(find.byType(CalculatorOverlay), findsOneWidget);
    });

    testWidgets('AppBar background color matches app background',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Get the app bar
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(AppColors.background));
    });

    testWidgets('Has main financial header text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Verify main card displays key label
      expect(find.text('Você ainda pode gastar este mês'), findsOneWidget);
    });

    testWidgets('Has secondary card with financial details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Verify secondary card displays expected labels
      expect(find.text('Salário mensal'), findsOneWidget);
      expect(find.text('Gasto total'), findsOneWidget);
      expect(find.text('Resultado parcial'), findsOneWidget);
      expect(find.text('Reserva final prevista'), findsOneWidget);
    });

    testWidgets('Layout renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Render and measure that layout completes without errors
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(tester.binding.window.viewInsets.bottom, equals(0.0));
    });
  });
}
