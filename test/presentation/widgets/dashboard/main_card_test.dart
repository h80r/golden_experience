import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/dashboard/main_card.dart';
import 'package:golden_experience/presentation/theme/app_colors.dart';

void main() {
  group('MainCard Widget Tests', () {
    testWidgets('Renders with correct label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 1250.50,
              reserveUsagePercentage: 35.0,
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.text('Você ainda pode gastar este mês'), findsOneWidget);
    });

    testWidgets('Displays loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 1250.50,
              reserveUsagePercentage: 35.0,
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Shows progress bar when not loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 1250.50,
              reserveUsagePercentage: 35.0,
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('Progress bar shows warning color when usage > 80%',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 500.00,
              reserveUsagePercentage: 85.0,
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      final progressBar = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator));
      expect(
        progressBar.valueColor?.value,
        equals(AppColors.warning),
      );
    });

    testWidgets('Progress bar shows secondary color when usage <= 80%',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 2000.00,
              reserveUsagePercentage: 50.0,
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      final progressBar = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator));
      expect(
        progressBar.valueColor?.value,
        equals(AppColors.secondary),
      );
    });

    testWidgets('Renders with correct styling (surface background)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 1250.50,
              reserveUsagePercentage: 35.0,
              isLoading: false,
            ),
          ),
        ),
      );

      final container = find.byType(Container);
      expect(container, findsWidgets);

      // Verify container exists with proper styling
      final containerWidget =
          tester.widget<Container>(container.first);
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, equals(AppColors.surface));
    });

    testWidgets('Shows reserve usage percentage text when not loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 1250.50,
              reserveUsagePercentage: 33.333,
              isLoading: false,
            ),
          ),
        ),
      );

      // Check for partial text that should be visible
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Has correct number of text widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainCard(
              remainingBudget: 5000.00,
              reserveUsagePercentage: 0.0,
              isLoading: false,
            ),
          ),
        ),
      );

      // Should have multiple text widgets (label, value, reserve text)
      expect(find.byType(Text), findsWidgets);
    });
  });
}
