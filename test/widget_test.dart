import 'package:flutter_test/flutter_test.dart';

import 'package:golden_experience/main.dart';

void main() {
  testWidgets('App should display title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app displays the correct text.
    expect(find.text('Previsor Financeiro - Setup Completo'), findsOneWidget);
  });
}
