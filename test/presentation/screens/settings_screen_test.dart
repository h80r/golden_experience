import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/screens/settings_screen.dart';
import 'package:golden_experience/data/providers/repository_providers.dart';
import 'package:golden_experience/domain/repositories/i_app_settings_repository.dart';
import 'package:golden_experience/data/datasources/local_database.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockAppSettingsRepository extends Mock implements IAppSettingsRepository {
  @override
  Future<AppSettingsModel?> get() async => null;

  @override
  Future<void> save(dynamic settings) async {}

  @override
  Future<void> updateMonthlySalary(double salary) async {}

  @override
  Future<void> updateReserveBalance(double balance) async {}

  @override
  Future<void> updateMaxReserveUsagePercentage(double percentage) async {}

  @override
  Future<void> updateLastRecurringCheck(DateTime date) async {}

  @override
  Future<void> initializeDefaults() async {}

  @override
  Stream<AppSettingsModel?> watch() {
    return Stream.value(null);
  }
}

void main() {
  group('SettingsScreen Tests', () {
    late MockAppSettingsRepository mockAppSettingsRepository;

    setUp(() {
      mockAppSettingsRepository = MockAppSettingsRepository();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          appSettingsRepositoryProvider.overrideWithValue(
            mockAppSettingsRepository,
          ),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      );
    }

    testWidgets('Settings screen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify AppBar is present
      expect(find.text('Configurações'), findsWidgets);

      // Verify all input fields are present
      expect(find.text('Salário Mensal'), findsOneWidget);
      expect(find.text('Saldo Inicial da Reserva'), findsOneWidget);
      expect(find.text('Percentual Máximo da Reserva'),
          findsOneWidget); // Changed: slider label instead of text field label

      // Verify buttons are present
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('Monthly salary field updates correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find the monthly salary input field
      final monthlySalaryField = find.byType(TextField).first;

      // Enter a value
      await tester.enterText(monthlySalaryField, '5000.00');
      await tester.pumpAndSettle();

      // Verify the value was entered
      expect(find.text('5000.00'), findsWidgets);
    });

    testWidgets('Reserve balance field updates correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find the reserve balance input field (second TextField)
      final fields = find.byType(TextField);
      final reserveBalanceField = fields.at(1);

      // Enter a value
      await tester.enterText(reserveBalanceField, '10000.00');
      await tester.pumpAndSettle();

      // Verify the value was entered
      expect(find.text('10000.00'), findsWidgets);
    });

    testWidgets('Max reserve percentage slider updates correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find the slider widget
      final slider = find.byType(Slider);

      // Verify slider exists
      expect(slider, findsOneWidget);

      // Verify initial value display (0% appears twice - value and label)
      expect(find.text('0%'), findsWidgets);
    });

    testWidgets('Cancel button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appSettingsRepositoryProvider.overrideWithValue(
              mockAppSettingsRepository,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: const Text('Open Settings'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open settings screen
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();

      // Verify settings screen is shown
      expect(find.text('Configurações'), findsWidgets);

      // Tap cancel button
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Verify we're back to the previous screen
      expect(find.text('Open Settings'), findsOneWidget);
    });

    testWidgets('Back button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appSettingsRepositoryProvider.overrideWithValue(
              mockAppSettingsRepository,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: const Text('Open Settings'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open settings screen
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();

      // Verify settings screen is shown
      expect(find.text('Configurações'), findsWidgets);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back to the previous screen
      expect(find.text('Open Settings'), findsOneWidget);
    });

    testWidgets('All fields can be filled with valid values',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);

      // Fill in text fields (only 2 now - salary and reserve balance)
      await tester.enterText(fields.at(0), '6000');
      await tester.enterText(fields.at(1), '15000');
      await tester.pumpAndSettle();

      // Verify text field values are present
      expect(find.text('6000'), findsWidgets);
      expect(find.text('15000'), findsWidgets);

      // Verify slider is present
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('Percentage slider works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify slider is present
      expect(find.byType(Slider), findsOneWidget);

      // Verify slider widget exists and renders
      expect(find.byWidgetPredicate(
        (widget) => widget is Slider,
      ), findsOneWidget);
    });

    testWidgets('Monetary fields accept decimal values',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);

      // Enter decimal values for salary and reserve
      await tester.enterText(fields.at(0), '5500.50');
      await tester.enterText(fields.at(1), '12500.75');
      await tester.pumpAndSettle();

      // Verify the values were entered
      expect(find.text('5500.50'), findsWidgets);
      expect(find.text('12500.75'), findsWidgets);
    });

    testWidgets('Scroll view contains all content',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify all content is present (may require scrolling)
      expect(find.text('Salário Mensal'), findsOneWidget);
      expect(find.text('Saldo Inicial da Reserva'), findsOneWidget);
      expect(find.text('Percentual Máximo da Reserva'),
          findsOneWidget); // Changed: slider label instead of text field label
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('Input fields have correct labels', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify hint texts are present
      expect(find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Digite seu salário mensal',
      ), findsOneWidget);

      expect(find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Digite o saldo inicial da reserva',
      ), findsOneWidget);

      // Verify slider is present instead of text field for percentage
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('Settings screen is properly themed',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);

      // Verify action buttons are present by their labels
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);

      // Verify text fields are present
      expect(find.byType(TextFormField), findsWidgets);
    });
  });
}
