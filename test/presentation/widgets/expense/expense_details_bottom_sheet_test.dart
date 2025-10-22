import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/expense/expense_details_bottom_sheet.dart';

void main() {
  group('ExpenseDetailsBottomSheet', () {
    testWidgets('renders with initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseDetailsBottomSheet(
              initialValue: 50.0,
              accounts: {1: 'Conta 1', 2: 'Conta 2'},
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

      expect(find.text('R\$ 50.00'), findsOneWidget);
    });

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

    testWidgets('renders notes field', (WidgetTester tester) async {
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

    testWidgets('renders category dropdown', (WidgetTester tester) async {
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

      expect(find.text('Categoria'), findsOneWidget);
    });

    testWidgets('renders transaction type selector', (WidgetTester tester) async {
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

    testWidgets('renders date picker', (WidgetTester tester) async {
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

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('renders cancel and save buttons', (WidgetTester tester) async {
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

      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('calls onCancel when cancel button pressed',
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

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(cancelled, isTrue);
    });

    testWidgets('shows snackbar when save without description',
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

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(
        find.text('Por favor, preencha todos os campos obrigatórios'),
        findsOneWidget,
      );
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

      await tester.enterText(
        find.byType(TextField).first,
        'Almoço',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

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
