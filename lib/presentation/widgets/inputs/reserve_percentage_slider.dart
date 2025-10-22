import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// ReservePercentageSlider - A slider widget for selecting percentage value
/// with visual feedback and descriptive text
class ReservePercentageSlider extends StatelessWidget {
  /// Current percentage value (0-100)
  final double value;

  /// Callback when slider value changes
  final ValueChanged<double> onChanged;

  /// Optional label text
  final String label;

  /// Optional descriptive text below slider
  final String? description;

  const ReservePercentageSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Percentual Máximo da Reserva',
    this.description =
        'Quanto da sua reserva você pode usar no mês, se necessário.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Value Display
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            '${value.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),

        // Slider
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6.0,
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceVariant,
            thumbColor: AppColors.primary,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 14.0,
              elevation: 4.0,
            ),
            overlayColor: AppColors.primary.withOpacity(0.3),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 20.0,
            ),
            valueIndicatorColor: AppColors.primary,
            valueIndicatorTextStyle:
                Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ) as TextStyle,
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0.0,
            max: 100.0,
            divisions: 100,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Min and Max labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            Text(
              '100%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),

        // Description text
        if (description != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ],
    );
  }
}
