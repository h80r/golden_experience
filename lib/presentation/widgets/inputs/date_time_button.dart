import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Compact button that displays a date and allows date/time selection
class DateTimeButton extends StatelessWidget {
  final DateTime selectedDateTime;
  final ValueChanged<DateTime> onChanged;
  final String? label;

  const DateTimeButton({
    required this.selectedDateTime,
    required this.onChanged,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Format: "23/10" (day/month)
    final dateFormat = DateFormat('dd/MM');
    final formattedDate = dateFormat.format(selectedDateTime);

    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md + 1.0,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          color: AppColors.surfaceVariant,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  formattedDate,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // First, pick the date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && context.mounted) {
      // Then, pick the time
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        // Combine date and time
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onChanged(newDateTime);
      } else {
        // User cancelled time picker, just use the date with current time
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
        onChanged(newDateTime);
      }
    }
  }
}
