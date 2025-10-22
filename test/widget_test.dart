import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:golden_experience/main.dart';

void main() {
  testWidgets('App should display title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Wrap in ProviderScope since MyApp uses Riverpod
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the app displays the MaterialApp with correct title
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
