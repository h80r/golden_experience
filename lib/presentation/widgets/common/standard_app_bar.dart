import 'package:flutter/material.dart';

import '../../screens/settings_screen.dart';
import '../../theme/app_colors.dart';

/// StandardAppBar - A reusable app bar widget for all main screens
/// Provides consistent styling across the application with:
/// - Consistent background color matching original dashboard design
/// - Settings button in the top right corner
/// - Support for additional custom actions
/// - Automatic back button on pushed screens (when canPop is true)
/// - Simple, clean design matching the original visual style
class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;
  final Widget? leading;
  final bool showSettings;

  const StandardAppBar({
    super.key,
    required this.title,
    this.additionalActions,
    this.leading,
    this.showSettings = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.background,
      leading: leading,
      actions: [
        ...?additionalActions,
        if (showSettings)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            ),
          ),
      ],
    );
  }
}
