import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/expense/expense_details_bottom_sheet.dart';

void main() {
  group('ExpenseDetailsBottomSheet', () {
    testWidgets('shows title and header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Detalhes da Transação'), findsOneWidget);
    });

    testWidgets('renders description field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Descrição'), findsOneWidget);
    });

    testWidgets('renders notes field on page 2', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      // Fill description and go to page 2
      final textFields = find.byType(TextField);
      await tester.enterText(
        textFields.at(1),
        'Almoço',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_note));
      await tester.pumpAndSettle();

      expect(find.text('Notas (Opcional)'), findsOneWidget);
    });

    testWidgets('renders account dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1', 2: 'Conta 2'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Conta'), findsOneWidget);
    });

    testWidgets('renders category dropdown on page 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação', 2: 'Transporte'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      // Category is now on page 1
      expect(find.text('Categoria'), findsOneWidget);
    });

    testWidgets('renders transaction type selector',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Débito'), findsOneWidget);
      expect(find.text('Crédito'), findsOneWidget);
    });

    testWidgets('renders date picker on page 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      // Date picker is now on page 1
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('renders page 1 with icon buttons and save',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      // Should have close icon, edit_note icon, and Save button
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.edit_note), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('renders page 2 with icon buttons after clicking edit_note',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      // Find and fill the description field on page 1
      final textFields = find.byType(TextField);
      await tester.enterText(
        textFields
            .at(1), // Description field is the 2nd TextField (after value)
        'Almoço',
      );
      await tester.pumpAndSettle();

      // Click edit_note icon to go to page 2
      await tester.tap(find.byIcon(Icons.edit_note));
      await tester.pumpAndSettle();

      // Page 2 should have close, arrow_back icons and Salvar button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('calls onCancel when close icon pressed',
        (WidgetTester tester) async {
      bool cancelled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
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

    testWidgets('allows navigation to page 2 without validation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      // Click edit_note icon without filling description
      // Should navigate to page 2 without validation
      await tester.tap(find.byIcon(Icons.edit_note));
      await tester.pumpAndSettle();

      // Should be on page 2 (arrow_back icon should be visible)
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('calls onSave with correct data when form is valid',
        (WidgetTester tester) async {
      late Map<String, dynamic> savedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {
                savedData = {
                  'value': value,
                  'description': description,
                  'accountId': accountId,
                  'transactionType': transactionType,
                  'categoryId': categoryId,
                };
              },
              onCancel: () {},
            ),
          ),
        ),
      );

      // Fill the description field on page 1
      final textFields = find.byType(TextField);
      await tester.enterText(
        textFields.at(1), // Description field (after value field)
        'Almoço',
      );
      await tester.pumpAndSettle();

      // On page 1, click Salvar button
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      // The value was initialized to 50.0 and should persist
      expect(savedData['value'], 50.0);
      expect(savedData['description'], 'Almoço');
    });

    testWidgets('switches transaction type when clicked',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1'},
              categories: {1: 'Alimentação'},
              onSave: ({
                required value,
                required description,
                required notes,
                required accountId,
                required transactionType,
                required categoryId,
                required date,
              }) {},
              onCancel: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Crédito'));
      await tester.pumpAndSettle();

      expect(find.text('Crédito'), findsOneWidget);
    });
  });
}
