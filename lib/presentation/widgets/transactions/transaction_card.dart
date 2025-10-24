import 'package:flutter/material.dart';

import '../../../core/utils/text_formatters.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Widget to display a single transaction card in a list
///
/// Shows transaction details in a compact card format with:
/// - Value (color-coded: green for positive, red for negative)
/// - Description and account name
/// - Date
/// - Category badge
class TransactionCard extends StatelessWidget {
  final TransactionCardData transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.value >= 0;
    final valueColor = isPositive ? AppColors.success : AppColors.error;
    final formattedValue = formatCurrency(transaction.value.abs(), 'R\$');
    final formattedDate = formatDate(transaction.date, includeYear: true);

    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Value and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Text(
                          transaction.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Account name
                        Text(
                          transaction.accountName,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Value (right-aligned)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isPositive ? '+$formattedValue' : '-$formattedValue',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: valueColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Footer: Category badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction.categoryName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Represents a single transaction in the list
class TransactionCardData {
  final int id;
  final double value;
  final String description;
  final DateTime date;
  final int accountId;
  final String accountName;
  final int categoryId;
  final String categoryName;
  final String? notes;

  const TransactionCardData({
    required this.id,
    required this.value,
    required this.description,
    required this.date,
    required this.accountId,
    required this.accountName,
    required this.categoryId,
    required this.categoryName,
    this.notes,
  });
}
