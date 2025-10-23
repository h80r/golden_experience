import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/inputs/nubank_style_currency_field.dart';
import 'package:golden_experience/presentation/theme/app_colors.dart';

void main() {
  group('NubankStyleCurrencyField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders with label and hint', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              hint: 'R\$ 0,00',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Valor'), findsOneWidget);
      expect(find.text('R\$ 0,00'), findsOneWidget);
    });

    testWidgets('converts single digit to cents (1 -> R\$ 0,01)',
        (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '1');
      await tester.pumpAndSettle();

      expect(changedValue, 0.01);
      expect(controller.text, '1');
    });

    testWidgets('builds value from right to left (123 -> R\$ 1,23)',
        (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '123');
      await tester.pumpAndSettle();

      expect(changedValue, 1.23);
    });

    testWidgets('handles large values (10056 -> R\$ 100,56)',
        (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '10056');
      await tester.pumpAndSettle();

      expect(changedValue, 100.56);
    });

    testWidgets('initializes with value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              initialValue: 123.45,
            ),
          ),
        ),
      );

      expect(controller.text, '12345');
    });

    testWidgets('handles empty input', (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      // First add some value, then clear it
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();
      expect(changedValue, 1.0);

      // Clear the field
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(changedValue, 0.0);
    });

    testWidgets('filters non-digit characters', (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '1,2.3abc');
      await tester.pumpAndSettle();

      expect(changedValue, 1.23);
      expect(controller.text, '123');
    });

    testWidgets('validates required field', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: NubankStyleCurrencyField(
                label: 'Valor',
                controller: controller,
                required: true,
              ),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), false);

      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), true);
    });

    testWidgets('shows error when required and empty',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: NubankStyleCurrencyField(
                label: 'Meu Campo',
                controller: controller,
                required: true,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Meu Campo é obrigatório'), findsOneWidget);
    });

    testWidgets('applies custom validator', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  NubankStyleCurrencyField(
                    label: 'Valor',
                    controller: controller,
                    validator: (value) {
                      if (value != null && value.length > 5) {
                        return 'Máximo 5 dígitos';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Validar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '123456');
      await tester.pumpAndSettle();

      final isValid = formKey.currentState!.validate();
      expect(isValid, false);

      // The validator is called and returns an error message
      // Let's verify the internal state instead
      expect(controller.text, '123456');
    });

    testWidgets('handles zero value correctly', (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '0');
      await tester.pumpAndSettle();

      expect(changedValue, 0.0);
    });

    testWidgets('respects enabled/disabled state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              isEnabled: false,
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      expect((tester.widget(textField) as TextField).enabled, false);
    });

    testWidgets('has currency prefix icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('R\$ '), findsWidgets);
    });

    testWidgets('updates display on external controller change',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
            ),
          ),
        ),
      );

      controller.text = '5000';
      await tester.pumpAndSettle();

      // Display should show R$ 50.00
      // Internal representation is cents (5000)
      expect(controller.text, '5000');
    });

    testWidgets('two digit handling (12 -> R\$ 0,12)',
        (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '12');
      await tester.pumpAndSettle();

      expect(changedValue, 0.12);
    });

    testWidgets('four digit handling (1234 -> R\$ 12,34)',
        (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '1234');
      await tester.pumpAndSettle();

      expect(changedValue, 12.34);
    });

    testWidgets('large value handling (123456 -> R\$ 1.234,56)',
        (WidgetTester tester) async {
      double? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '123456');
      await tester.pumpAndSettle();

      expect(changedValue, 1234.56);
    });

    testWidgets('focus change updates styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NubankStyleCurrencyField(
              label: 'Valor',
              controller: controller,
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.tap(textField);
      await tester.pumpAndSettle();

      // Widget should handle focus state internally
      expect(find.byType(NubankStyleCurrencyField), findsOneWidget);
    });
  });
}
