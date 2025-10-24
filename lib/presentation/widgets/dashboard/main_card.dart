import 'package:flutter/material.dart';

import '../../../core/utils/text_formatters.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Main dashboard card displaying remaining budget
/// Shows "Você ainda pode gastar este mês" with the key metric
class MainCard extends StatelessWidget {
  final double remainingBudget;
  final double reserveUsagePercentage;
  final bool isLoading;

  const MainCard({
    super.key,
    required this.remainingBudget,
    this.reserveUsagePercentage = 0.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Você ainda pode gastar este mês',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Main value
          if (isLoading)
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
            )
          else
            Text(
              formatCurrency(remainingBudget, 'R\$'),
              style: AppTypography.displayLarge.copyWith(
                color:
                    remainingBudget >= 0 ? AppColors.primary : AppColors.error,
              ),
            ),
          const SizedBox(height: AppSpacing.lg),

          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: isLoading
                ? const SizedBox.expand()
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMedium),
                    child: LinearProgressIndicator(
                      value: (reserveUsagePercentage / 100).clamp(0.0, 1.0),
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        reserveUsagePercentage > 80
                            ? AppColors.warning
                            : AppColors.secondary,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Reserve usage text
          if (!isLoading)
            Text(
              '${reserveUsagePercentage.toStringAsFixed(1)}% da reserva utilizada',
              style: AppTypography.bodySmall,
            ),
        ],
      ),
    );
  }
}
