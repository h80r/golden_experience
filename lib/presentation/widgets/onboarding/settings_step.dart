import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../inputs/custom_text_field.dart';
import '../inputs/reserve_percentage_slider.dart';
import '../../../data/repositories/app_settings_repository_impl.dart';

/// Settings step - Configure salary, reserve, and percentage
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
  late TextEditingController _reserveController;
  double _reservePercentage = 50.0;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _salaryController = TextEditingController();
    _reserveController = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final repository = AppSettingsRepositoryImpl();
      final settings = await repository.get();
      if (settings != null && mounted) {
        setState(() {
          _salaryController.text =
              settings.monthlySalary > 0 ? settings.monthlySalary.toString() : '';
          _reserveController.text =
              settings.reserveBalance > 0 ? settings.reserveBalance.toString() : '';
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
    if (_salaryController.text.isEmpty || _reserveController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha todos os campos';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final salary = double.tryParse(_salaryController.text) ?? 0.0;
      final reserve = double.tryParse(_reserveController.text) ?? 0.0;

      if (salary <= 0 || reserve < 0) {
        throw Exception('Salário deve ser maior que 0 e reserva não pode ser negativa');
      }

      final repository = AppSettingsRepositoryImpl();

      // Update each field
      await repository.updateMonthlySalary(salary);
      await repository.updateReserveBalance(reserve);
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

  @override
  void dispose() {
    _salaryController.dispose();
    _reserveController.dispose();
    super.dispose();
  }

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
                CustomTextField(
                  label: 'Salário Mensal (R\$)',
                  controller: _salaryController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  hint: '0.00',
                  isEnabled: !_isLoading,
                ),
                SizedBox(height: AppSpacing.xl),
                // Reserve balance field
                CustomTextField(
                  label: 'Saldo da Reserva (R\$)',
                  controller: _reserveController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  hint: '0.00',
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
}
