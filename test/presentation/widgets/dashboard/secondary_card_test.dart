import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/dashboard/secondary_card.dart';
import 'package:golden_experience/presentation/theme/app_colors.dart';

void main() {
  group('SecondaryCard Widget Tests', () {
    testWidgets('Renders with all financial field labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5000.00,
              totalSpent: 1234.50,
              partialResult: 3765.50,
              finalReserve: 2500.00,
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.text('Salário mensal'), findsOneWidget);
      expect(find.text('Gasto total'), findsOneWidget);
      expect(find.text('Resultado parcial'), findsOneWidget);
      expect(find.text('Reserva final prevista'), findsOneWidget);
    });

    testWidgets('Displays loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5000.00,
              totalSpent: 1234.50,
              partialResult: 3765.50,
              finalReserve: 2500.00,
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Shows all text values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5000.00,
              totalSpent: 1234.50,
              partialResult: 3765.50,
              finalReserve: 2500.00,
              isLoading: false,
            ),
          ),
        ),
      );

      // Should have multiple text widgets for all fields
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Has Row widgets for financial rows',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5000.00,
              totalSpent: 1234.50,
              partialResult: 3765.50,
              finalReserve: 2500.00,
              isLoading: false,
            ),
          ),
        ),
      );

      // Should have multiple Row widgets for financial data display
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('Renders dividers between rows', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5000.00,
              totalSpent: 1234.50,
              partialResult: 3765.50,
              finalReserve: 2500.00,
              isLoading: false,
            ),
          ),
        ),
      );

      // Should have multiple dividers separating rows
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('Renders with correct styling (surface background)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5000.00,
              totalSpent: 1234.50,
              partialResult: 3765.50,
              finalReserve: 2500.00,
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

    testWidgets('Renders all four financial metric labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5250.75,
              totalSpent: 1500.25,
              partialResult: 3750.50,
              finalReserve: 1000.99,
              isLoading: false,
            ),
          ),
        ),
      );

      // Verify all labels are present
      expect(find.text('Salário mensal'), findsOneWidget);
      expect(find.text('Gasto total'), findsOneWidget);
      expect(find.text('Resultado parcial'), findsOneWidget);
      expect(find.text('Reserva final prevista'), findsOneWidget);
    });

    testWidgets('Card body structure is correct when not loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryCard(
              monthlySalary: 5000.00,
              totalSpent: 1234.50,
              partialResult: 3765.50,
              finalReserve: 2500.00,
              isLoading: false,
            ),
          ),
        ),
      );

      // Verify Column structure for content
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Divider), findsWidgets);
    });
  });
}
