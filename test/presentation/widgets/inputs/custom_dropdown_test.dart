import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/inputs/custom_dropdown.dart';

void main() {
  group('CustomDropdown', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdown<String>(
              label: 'Test Dropdown',
              items: [
                const DropdownMenuItem(
                    value: 'option1', child: Text('Option 1')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Dropdown'), findsOneWidget);
    });

    testWidgets('shows label when rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdown<String>(
              label: 'Test Dropdown',
              items: [
                const DropdownMenuItem(
                    value: 'option1', child: Text('Option 1')),
                const DropdownMenuItem(
                    value: 'option2', child: Text('Option 2')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Dropdown'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('calls onChanged when item selected',
        (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdown<String>(
              label: 'Test Dropdown',
              items: [
                const DropdownMenuItem(
                    value: 'option1', child: Text('Option 1')),
                const DropdownMenuItem(
                    value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (value) {
                selectedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(selectedValue, 'option2');
    });

    testWidgets('shows initial value when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdown<String>(
              label: 'Test Dropdown',
              value: 'option1',
              items: [
                const DropdownMenuItem(
                    value: 'option1', child: Text('Option 1')),
                const DropdownMenuItem(
                    value: 'option2', child: Text('Option 2')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('disabled when isEnabled is false',
        (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdown<String>(
              label: 'Test Dropdown',
              items: [
                const DropdownMenuItem(
                    value: 'option1', child: Text('Option 1')),
                const DropdownMenuItem(
                    value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (value) {
                changedValue = value;
              },
              isEnabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // The dropdown should not open when disabled
      expect(changedValue, isNull);
    });

    testWidgets('renders with prefix icon when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdown<String>(
              label: 'Test Dropdown',
              prefixIcon: Icons.category,
              items: [
                const DropdownMenuItem(
                    value: 'option1', child: Text('Option 1')),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.category), findsOneWidget);
    });

    testWidgets('validates input with validator', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomDropdown<String>(
                label: 'Test Dropdown',
                items: [
                  const DropdownMenuItem(
                      value: 'option1', child: Text('Option 1')),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
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

      expect(find.text('Please select an option'), findsOneWidget);
    });
  });
}
