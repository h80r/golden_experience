import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_view_notifier.g.dart';

/// Enum representing the different views in the dashboard tab
enum DashboardView { dashboard, transactions }

/// Notifier that manages which view is displayed in the dashboard tab (Início).
///
/// This notifier handles:
/// - Toggling between Dashboard and Transactions list views
/// - Resetting to Dashboard view
/// - Maintaining the current view state
@riverpod
class DashboardViewNotifier extends _$DashboardViewNotifier {
  @override
  DashboardView build() => DashboardView.dashboard;

  /// Toggle between dashboard and transactions views
  void toggle() {
    state = state == DashboardView.dashboard
        ? DashboardView.transactions
        : DashboardView.dashboard;
  }

  /// Reset to dashboard view (used for back button)
  void showDashboard() {
    state = DashboardView.dashboard;
  }

  /// Show transactions view
  void showTransactions() {
    state = DashboardView.transactions;
  }
}
