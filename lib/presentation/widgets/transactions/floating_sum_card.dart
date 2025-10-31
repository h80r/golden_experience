import 'package:flutter/material.dart';

import '../../../core/utils/text_formatters.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// A floating card that displays the sum total of filtered transactions
/// and can transition to a FAB for adding new transactions.
///
/// This widget uses AnimatedSwitcher to transition between two states:
/// 1. Sum Card: Shows the total sum of transactions
/// 2. FAB: Floating action button to add new transactions
class FloatingSumCard extends StatelessWidget {
  final double totalSum;

  const FloatingSumCard({
    super.key,
    required this.totalSum,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = totalSum < 0;
    final formattedSum = formatCurrency(totalSum.abs(), 'R\$');

    return Container(
      key: const ValueKey('sum_card'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        isNegative ? '-$formattedSum' : formattedSum,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isNegative ? AppColors.error : AppColors.success,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
