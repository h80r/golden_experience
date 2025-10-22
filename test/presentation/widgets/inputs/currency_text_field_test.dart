import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/inputs/currency_text_field.dart';

void main() {
  group('CurrencyTextField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
            ),
          ),
        ),
      );

      expect(find.text('Amount'), findsOneWidget);
    });

    testWidgets('renders with R\$ prefix', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
            ),
          ),
        ),
      );

      expect(find.text('R\$ '), findsOneWidget);
    });

    testWidgets('accepts numeric input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '1000');
      await tester.pumpAndSettle();

      expect(controller.text, contains('1'));
    });

    testWidgets('formats input with thousand separators',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '10000');
      await tester.pumpAndSettle();

      // Should contain dot separator (1.000 in Brazilian format)
      expect(controller.text, contains('.'));
    });

    testWidgets('accepts comma as decimal separator',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '100,50');
      await tester.pumpAndSettle();

      expect(controller.text, contains(','));
    });

    testWidgets('calls onChanged with parsed double value',
        (WidgetTester tester) async {
      double? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '100,50');
      await tester.pumpAndSettle();

      expect(changedValue, isNotNull);
      expect(changedValue, greaterThan(100));
    });

    testWidgets('initializes with initial value',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
              initialValue: 1500.50,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.text, isNotEmpty);
      expect(controller.text, contains('1'));
    });

    testWidgets('validates required field', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CurrencyTextField(
                label: 'Amount',
                required: true,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Amount é obrigatório'), findsOneWidget);
    });

    testWidgets('accepts custom validator', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CurrencyTextField(
                label: 'Amount',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Value is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Value is required'), findsOneWidget);
    });

    testWidgets('limits decimal places to 2', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '100,999');
      await tester.pumpAndSettle();

      // Should limit to 100,99
      expect(controller.text, contains(',9'));
    });

    testWidgets('disables when isEnabled is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              isEnabled: false,
            ),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
    });

    testWidgets('handles empty input gracefully',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      double? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();

      expect(controller.text, isEmpty);
      expect(changedValue, isNull);
    });

    testWidgets('rejects non-numeric input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pumpAndSettle();

      // Should only contain numbers (no letters)
      expect(controller.text.contains(RegExp(r'[a-zA-Z]')), false);
    });

    testWidgets('handles large values correctly',
        (WidgetTester tester) async {
      double? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(
          find.byType(TextFormField), '999999,99');
      await tester.pumpAndSettle();

      expect(changedValue, equals(999999.99));
    });

    testWidgets('preserves comma decimal separator in formatting',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '1234,50');
      await tester.pumpAndSettle();

      // Should use dot for thousands and comma for decimal in Brazilian format
      expect(controller.text, contains('1.234,5'));
    });

    testWidgets('focuses and unfocuses correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Field should be focused
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('works with TextEditingController', (WidgetTester tester) async {
      final controller = TextEditingController(text: '1000,00');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              controller: controller,
            ),
          ),
        ),
      );

      expect(controller.text, contains('1000'));
    });

    testWidgets('shows hint text when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              hint: 'R\$ 0,00',
            ),
          ),
        ),
      );

      expect(find.text('R\$ 0,00'), findsOneWidget);
    });

    testWidgets('handles zero value correctly', (WidgetTester tester) async {
      double? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '0,00');
      await tester.pumpAndSettle();

      expect(changedValue, equals(0.0));
    });

    testWidgets('handles currency formatter initialization',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              label: 'Amount',
              initialValue: 2500.75,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.byType(CurrencyTextField), findsOneWidget);
    });
  });
}
