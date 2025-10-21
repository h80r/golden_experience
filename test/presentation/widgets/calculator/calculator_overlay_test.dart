import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/calculator/calculator_overlay.dart';

void main() {
  group('CalculatorOverlay', () {
    testWidgets('renders calculator with display', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalculatorOverlay(
              onConfirm: (_) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Valor da Transação'), findsOneWidget);
      // The display shows "0" - there may be multiple "0"s (display + button grid)
      expect(find.text('0'), findsWidgets);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('onCancel called when close icon is pressed',
        (WidgetTester tester) async {
      bool cancelled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalculatorOverlay(
              onConfirm: (_) {},
              onCancel: () {
                cancelled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(cancelled, isTrue);
    });
  });
}
