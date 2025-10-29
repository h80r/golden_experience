import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/app_settings_repository_impl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../inputs/nubank_style_currency_field.dart';
import '../inputs/reserve_percentage_slider.dart';

/// Settings step - Configure salary and reserve percentage
class SettingsStep extends ConsumerStatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const SettingsStep({
    required this.onContinue,
    required this.onBack,
    super.key,
  });

  @override
  ConsumerState<SettingsStep> createState() => _SettingsStepState();
}

class _SettingsStepState extends ConsumerState<SettingsStep> {
  late TextEditingController _salaryController;
  double _reservePercentage = 50.0;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.xl),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configure suas finanças',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Esses valores são usados para calcular quanto você pode gastar',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          // Error message
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          if (_errorMessage != null) SizedBox(height: AppSpacing.md),
          // Form fields
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                // Salary field
                NubankStyleCurrencyField(
                  label: 'Salário Mensal',
                  hint: '0,00',
                  controller: _salaryController,
                  isEnabled: !_isLoading,
                ),
                SizedBox(height: AppSpacing.xl),
                // Reserve percentage slider
                ReservePercentageSlider(
                  value: _reservePercentage,
                  onChanged: (newValue) {
                    setState(() {
                      _reservePercentage = newValue;
                    });
                  },
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
                  label: _isLoading ? 'Salvando...' : 'Próximo',
                  onPressed: _isLoading ? () {} : _saveSettings,
                  isEnabled: !_isLoading,
                ),
                SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Voltar',
                  onPressed: _isLoading ? () {} : widget.onBack,
                  isEnabled: !_isLoading,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _salaryController = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final repository = AppSettingsRepositoryImpl();
      final settings = await repository.get();
      if (settings != null && mounted) {
        setState(() {
          // NubankStyleCurrencyField uses internal representation (cents)
          if (settings.monthlySalary > 0) {
            final cents = (settings.monthlySalary * 100).toInt();
            _salaryController.text = cents.toString();
          }
          _reservePercentage = settings.maxReserveUsagePercentage;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar configurações';
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    // Validate inputs
    if (_salaryController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha o salário mensal';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // NubankStyleCurrencyField uses internal representation (cents)
      final salaryCents = int.tryParse(_salaryController.text) ?? 0;

      final salary = salaryCents / 100.0;

      if (salary <= 0) {
        throw Exception('Salário deve ser maior que 0');
      }

      final repository = AppSettingsRepositoryImpl();

      // Update each field
      await repository.updateMonthlySalary(salary);
      await repository.updateMaxReserveUsagePercentage(_reservePercentage);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.onContinue();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erro ao salvar: $e';
        });
      }
    }
  }
}
