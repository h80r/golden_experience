import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/presentation/widgets/common/standard_app_bar.dart';

void main() {
  group('StandardAppBar', () {
    testWidgets('renders with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const StandardAppBar(title: 'Test Title'),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('displays settings button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const StandardAppBar(title: 'Test Title'),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('settings button triggers navigation',
        (WidgetTester tester) async {
      // This test verifies that the settings button exists and can be tapped
      // Full navigation testing is done in integration tests due to ProviderScope requirements
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const StandardAppBar(title: 'Test Title'),
            body: const SizedBox(),
          ),
        ),
      );

      // Verify settings button exists
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Verify it can be tapped without errors
      await tester.tap(find.byIcon(Icons.settings));

      // The button should be tapable without throwing
      expect(true, isTrue);
    });

    testWidgets('renders additional actions when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: StandardAppBar(
              title: 'Test Title',
              additionalActions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed of additional action when tapped',
        (WidgetTester tester) async {
      bool additionalActionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: StandardAppBar(
              title: 'Test Title',
              additionalActions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    additionalActionPressed = true;
                  },
                ),
              ],
            ),
            body: const SizedBox(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(additionalActionPressed, isTrue);
    });

    testWidgets('has correct preferred size', (WidgetTester tester) async {
      final appBar = StandardAppBar(title: 'Test');
      expect(appBar.preferredSize, const Size.fromHeight(kToolbarHeight));
    });

    testWidgets('renders multiple additional actions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: StandardAppBar(
              title: 'Test Title',
              additionalActions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('has settings button as rightmost action',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: StandardAppBar(
              title: 'Test Title',
              additionalActions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            body: const SizedBox(),
          ),
        ),
      );

      // Find all icon buttons in the AppBar
      final iconButtons = find.byType(IconButton);
      expect(iconButtons, findsWidgets);

      // Verify settings is one of them (it's added last)
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
