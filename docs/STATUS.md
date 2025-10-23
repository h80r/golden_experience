# Project Task Status

This file is auto-managed and contains the minimum state required to track execution against the PLAN.md.

## Current Task Details

- **current_task_id**: F8-T5
- **current_task_title**: Correção - Golden Experience em Permissões de Notificação
- **current_task_status**: PENDING

## Step Tracking (Only for complex tasks)

- **completed_steps**: []
- **next_atomic_step**: |
  (Empty - task is straightforward enough to complete as a single unit)

## Recently Completed

- **F8-T4**: Feature - Alternar Dashboard/Histórico na Aba Início (COMPLETED)
  - Created DashboardViewNotifier provider to manage toggle state between Dashboard and Transactions views
  - Modified MainScreen to use ConsumerStatefulWidget with Riverpod state management
  - Implemented PopScope (modern replacement for WillPopScope) for Android back button handling
  - Updated DashboardContainer to watch the DashboardViewProvider and render the appropriate view
  - Toggle triggers when tapping the already-selected Início tab
  - Back button returns to Dashboard before exiting the app
