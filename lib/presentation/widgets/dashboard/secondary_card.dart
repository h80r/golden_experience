import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Secondary dashboard card displaying financial details
/// Shows: monthly salary, total spent, partial result, and final reserve
class SecondaryCard extends StatelessWidget {
  final double monthlySalary;
  final double totalSpent;
  final double partialResult; // Salary - Spent
  final double finalReserve;
  final bool isLoading;

  const SecondaryCard({
    super.key,
    required this.monthlySalary,
    required this.totalSpent,
    required this.partialResult,
    required this.finalReserve,
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
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            )
          : Column(
              children: [
                _FinancialRow(
                  label: 'Salário mensal',
                  value: monthlySalary,
                  isHighlight: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.lg),
                _FinancialRow(
                  label: 'Gasto total',
                  value: totalSpent,
                  isHighlight: true,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.lg),
                _FinancialRow(
                  label: 'Resultado parcial',
                  value: partialResult,
                  isHighlight: true,
                  color:
                      partialResult >= 0 ? AppColors.success : AppColors.error,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.lg),
                _FinancialRow(
                  label: 'Reserva final prevista',
                  value: finalReserve,
                  isHighlight: true,
                  color:
                      finalReserve >= 0 ? AppColors.success : AppColors.warning,
                ),
              ],
            ),
    );
  }
}

/// Helper widget for displaying a financial metric row
class _FinancialRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isHighlight;
  final Color? color;

  const _FinancialRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.textPrimary;
    final textStyle = isHighlight
        ? AppTypography.titleLarge.copyWith(color: textColor)
        : AppTypography.bodyLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium,
        ),
        Text(
          'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
          style: textStyle,
        ),
      ],
    );
  }
}
