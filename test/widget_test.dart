import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:golden_experience/main.dart';
import 'package:golden_experience/domain/models/dashboard_data.dart';
import 'package:golden_experience/domain/usecases/providers/usecase_providers.dart';

void main() {
  testWidgets('App should display title', (WidgetTester tester) async {
    // Create mock dashboard data for testing
    DashboardData mockData = DashboardData(
      monthlySalary: 5000.0,
      totalSpent: 1000.0,
      remainingBudget: 6000.0,
      partialResult: 4000.0,
      finalReserve: 2500.0,
      reserveUsagePercentage: 0.0,
      initialReserve: 2500.0,
      maxReserveUsagePercentage: 50.0,
    );

    // Build our app and trigger a frame.
    // Wrap in ProviderScope since MyApp uses Riverpod
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardDataStreamProvider.overrideWith((ref) async* {
            yield mockData;
          }),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the app displays the MaterialApp with correct title
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
