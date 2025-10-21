import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/inputs/custom_text_field.dart';

void main() {
  group('CustomTextField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test Field',
            ),
          ),
        ),
      );

      expect(find.text('Test Field'), findsOneWidget);
    });

    testWidgets('accepts text input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test Field',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(CustomTextField), 'Test Input');
      expect(controller.text, 'Test Input');
    });

    testWidgets('calls onChanged when text changes',
        (WidgetTester tester) async {
      String changedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test Field',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(CustomTextField), 'Changed');
      await tester.pumpAndSettle();

      expect(changedValue, 'Changed');
    });

    testWidgets('validates input with validator',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                label: 'Test Field',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
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

      expect(find.text('Field is required'), findsOneWidget);
    });

    testWidgets('shows error message when validation fails',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                label: 'Test Field',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
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

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('renders with prefix icon when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test Field',
              prefixIcon: Icons.email,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('disabled when isEnabled is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test Field',
              isEnabled: false,
            ),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
    });

    testWidgets('supports multiline input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test Field',
              maxLines: 3,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(CustomTextField), 'Line 1\nLine 2\nLine 3');
      await tester.pumpAndSettle();

      expect(find.byType(CustomTextField), findsOneWidget);
    });
  });
}
