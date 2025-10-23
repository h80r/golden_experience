import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Segmented toggle widget with switch/tab style for mutually exclusive options
class SegmentedToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isLeftSelected;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const SegmentedToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.isLeftSelected,
    required this.onLeftTap,
    required this.onRightTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          // Sliding indicator - outlined blue style
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment:
                isLeftSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
              ),
            ),
          ),
          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onLeftTap,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      leftLabel,
                      style: AppTypography.titleMedium.copyWith(
                        color: isLeftSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onRightTap,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      rightLabel,
                      style: AppTypography.titleMedium.copyWith(
                        color: !isLeftSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
