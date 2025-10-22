import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// Welcome step of the onboarding flow
class WelcomeStep extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const WelcomeStep({
    required this.onContinue,
    required this.onSkip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: AppSpacing.xl),
          // Icon/Illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.savings,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          // Title
          Text(
            'Bem-vindo ao\nPrevisor Financeiro',
            textAlign: TextAlign.center,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'Um aplicativo simples e prático para responder:\n"Quanto ainda posso gastar este mês?"',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          // Features list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                _FeatureItem(
                  icon: Icons.flash_on,
                  title: 'Resposta Instantânea',
                  description: 'Veja quanto você pode gastar em tempo real',
                ),
                SizedBox(height: AppSpacing.md),
                _FeatureItem(
                  icon: Icons.trending_down,
                  title: 'Controle Total',
                  description: 'Gerencie suas contas, categorias e gastos',
                ),
                SizedBox(height: AppSpacing.md),
                _FeatureItem(
                  icon: Icons.savings,
                  title: 'Planejamento',
                  description: 'Controle sua reserva e gastos recorrentes',
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          // Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                PrimaryButton(
                  label: 'Começar',
                  onPressed: onContinue,
                ),
                SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Pular por enquanto',
                  onPressed: onSkip,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha((0.15 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
