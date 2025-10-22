import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/inputs/custom_text_field.dart';
import '../state/app_settings_form_notifier.dart';
import '../../data/providers/repository_providers.dart';

/// SettingsScreen - Configuration screen for app-wide financial settings
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _monthlySalaryController;
  late TextEditingController _reserveBalanceController;
  late TextEditingController _maxReservePercentageController;

  @override
  void initState() {
    super.initState();
    _monthlySalaryController = TextEditingController();
    _reserveBalanceController = TextEditingController();
    _maxReservePercentageController = TextEditingController();

    // Load existing settings
    _loadSettings();
  }

  @override
  void dispose() {
    _monthlySalaryController.dispose();
    _reserveBalanceController.dispose();
    _maxReservePercentageController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
    final settings = await appSettingsRepository.get();

    if (settings != null && mounted) {
      _monthlySalaryController.text = settings.monthlySalary.toString();
      _reserveBalanceController.text = settings.reserveBalance.toString();
      _maxReservePercentageController.text =
          settings.maxReserveUsagePercentage.toString();

      ref.read(appSettingsFormProvider.notifier).setFromExisting(
            monthlySalary: settings.monthlySalary,
            reserveBalance: settings.reserveBalance,
            maxReserveUsagePercentage: settings.maxReserveUsagePercentage,
          );
    }
  }

  void _onMonthlySalaryChanged(String value) {
    final salary = double.tryParse(value) ?? 0.0;
    ref.read(appSettingsFormProvider.notifier).updateMonthlySalary(
          salary.isNaN ? 0.0 : salary,
        );
  }

  void _onReserveBalanceChanged(String value) {
    final balance = double.tryParse(value) ?? 0.0;
    ref.read(appSettingsFormProvider.notifier).updateReserveBalance(
          balance.isNaN ? 0.0 : balance,
        );
  }

  void _onMaxReservePercentageChanged(String value) {
    final percentage = double.tryParse(value) ?? 0.0;
    ref.read(appSettingsFormProvider.notifier)
        .updateMaxReserveUsagePercentage(
          percentage.isNaN ? 0.0 : percentage,
        );
  }

  Future<void> _saveSettings() async {
    final formState = ref.read(appSettingsFormProvider);

    if (!formState.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            formState.errorMessage ?? 'Erro ao salvar configurações',
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);

      // Update each setting individually
      await Future.wait([
        appSettingsRepository.updateMonthlySalary(formState.monthlySalary),
        appSettingsRepository.updateReserveBalance(formState.reserveBalance),
        appSettingsRepository.updateMaxReserveUsagePercentage(
          formState.maxReserveUsagePercentage,
        ),
      ]);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurações salvas com sucesso!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // Return to dashboard
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(appSettingsFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salário Mensal
            CustomTextField(
              label: 'Salário Mensal',
              hint: 'Digite seu salário mensal',
              controller: _monthlySalaryController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: _onMonthlySalaryChanged,
              prefixIcon: Icons.attach_money,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Saldo da Reserva
            CustomTextField(
              label: 'Saldo Inicial da Reserva',
              hint: 'Digite o saldo inicial da reserva',
              controller: _reserveBalanceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: _onReserveBalanceChanged,
              prefixIcon: Icons.savings,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Percentual Máximo de Gasto da Reserva
            CustomTextField(
              label: 'Percentual Máximo de Gasto da Reserva (%)',
              hint: 'Digite o percentual (0-100)',
              controller: _maxReservePercentageController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: _onMaxReservePercentageChanged,
              prefixIcon: Icons.percent,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Error message if validation fails
            if (formState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorWithOpacity,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Text(
                    formState.errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                ),
              ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Cancelar',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: 'Salvar',
                    onPressed: _saveSettings,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
