import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/inputs/reserve_percentage_slider.dart';

void main() {
  group('ReservePercentageSlider', () {
    testWidgets('displays initial value correctly',
        (WidgetTester tester) async {
      double currentValue = 50.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
              },
            ),
          ),
        ),
      );

      // Find and verify the value display
      expect(find.text('50%'), findsWidgets);
    });

    testWidgets('displays label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 50.0,
              onChanged: (_) {},
              label: 'Percentual Máximo da Reserva',
            ),
          ),
        ),
      );

      expect(find.text('Percentual Máximo da Reserva'), findsOneWidget);
    });

    testWidgets('displays description text when provided',
        (WidgetTester tester) async {
      const String description =
          'Quanto da sua reserva você pode usar no mês, se necessário.';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 50.0,
              onChanged: (_) {},
              description: description,
            ),
          ),
        ),
      );

      expect(find.text(description), findsOneWidget);
    });

    testWidgets('displays min (0%) and max (100%) labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 50.0,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('0%'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('calls onChanged when slider moves',
        (WidgetTester tester) async {
      double capturedValue = 50.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ReservePercentageSlider(
                  value: capturedValue,
                  onChanged: (value) {
                    setState(() {
                      capturedValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Find the slider and move it
      final Slider slider =
          find.byType(Slider).evaluate().first.widget as Slider;
      expect(slider.value, 50.0);

      // Simulate slider drag to 75%
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Value should have changed
      expect(capturedValue, isNot(50.0));
    });

    testWidgets('slider range is 0-100', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 50.0,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final Slider slider =
          find.byType(Slider).evaluate().first.widget as Slider;
      expect(slider.min, 0.0);
      expect(slider.max, 100.0);
    });

    testWidgets('slider has 100 divisions (1% increments)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 50.0,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final Slider slider =
          find.byType(Slider).evaluate().first.widget as Slider;
      expect(slider.divisions, 100);
    });

    testWidgets('updates value display on slider change',
        (WidgetTester tester) async {
      double currentValue = 25.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ReservePercentageSlider(
                  value: currentValue,
                  onChanged: (value) {
                    setState(() {
                      currentValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('25%'), findsWidgets);

      // Simulate moving the slider
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Value display should have updated
      expect(find.text('25%'), findsNothing);
    });

    testWidgets('renders with custom label', (WidgetTester tester) async {
      const String customLabel = 'Limite de Gastos';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 50.0,
              onChanged: (_) {},
              label: customLabel,
            ),
          ),
        ),
      );

      expect(find.text(customLabel), findsOneWidget);
    });

    testWidgets('handles value at 0%', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 0.0,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('0%'), findsWidgets);
    });

    testWidgets('handles value at 100%', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservePercentageSlider(
              value: 100.0,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('100%'), findsWidgets);
    });
  });
}
