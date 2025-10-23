import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/repository_providers.dart';
import '../state/app_settings_form_notifier.dart';
import '../state/backup_notifier.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/common/standard_app_bar.dart';
import '../widgets/inputs/nubank_style_currency_field.dart';
import '../widgets/inputs/reserve_percentage_slider.dart';
import '../widgets/settings/notification_settings_section.dart';

/// SettingsScreen - Configuration screen for app-wide financial settings
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _monthlySalaryController;
  late TextEditingController _reserveBalanceController;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(appSettingsFormProvider);
    final backupState = ref.watch(backupProvider);

    return Scaffold(
      appBar: StandardAppBar(
        title: 'Configurações',
        showSettings: false,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salário Mensal
            NubankStyleCurrencyField(
              label: 'Salário Mensal',
              hint: 'Digite seu salário mensal',
              controller: _monthlySalaryController,
              onChanged: _onMonthlySalaryChanged,
              initialValue: formState.monthlySalary,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Saldo da Reserva
            NubankStyleCurrencyField(
              label: 'Saldo Inicial da Reserva',
              hint: 'Digite o saldo inicial da reserva',
              controller: _reserveBalanceController,
              onChanged: _onReserveBalanceChanged,
              initialValue: formState.reserveBalance,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Percentual Máximo de Gasto da Reserva (Slider)
            ReservePercentageSlider(
              value: formState.maxReserveUsagePercentage,
              onChanged: _onMaxReservePercentageChanged,
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
            const SizedBox(height: AppSpacing.xl),

            // Divider
            Divider(
              color: AppColors.border,
              thickness: 1,
              height: AppSpacing.xl,
            ),
            const SizedBox(height: AppSpacing.md),

            // Backup Section Header
            Text(
              'Backup e Restauração',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text(
              'Exporte seus dados para um arquivo ou importe dados de um backup anterior.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Backup buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: backupState.isLoading ? null : _exportBackup,
                    icon: const Icon(Icons.cloud_download),
                    label: backupState.isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Exportar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: backupState.isLoading ? null : _importBackup,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Importar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Backup status messages
            if (backupState.successMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.successWithOpacity,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: Text(
                    backupState.successMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                        ),
                  ),
                ),
              ),
            if (backupState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorWithOpacity,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Text(
                    backupState.errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),

            // Divider
            Divider(
              color: AppColors.border,
              thickness: 1,
              height: AppSpacing.xl,
            ),
            const SizedBox(height: AppSpacing.md),

            // Notifications Section
            const NotificationSettingsSection(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _monthlySalaryController.dispose();
    _reserveBalanceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _monthlySalaryController = TextEditingController();
    _reserveBalanceController = TextEditingController();

    // Load existing settings after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Future<void> _exportBackup() async {
    final backupNotifier = ref.read(backupProvider.notifier);
    backupNotifier.setLoading(true);

    try {
      // Generate backup JSON
      final backupRepository = ref.read(backupRepositoryProvider);
      final jsonData = await backupRepository.exportToJson();

      // Convert JSON string to bytes for mobile platforms
      final bytes = utf8.encode(jsonData);

      // Show file picker dialog for user to select save location
      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Salvar Backup',
        fileName:
            'golden_experience_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );

      if (outputPath == null) {
        // User cancelled the dialog
        backupNotifier.setLoading(false);
        return;
      }

      if (!mounted) return;

      backupNotifier.setSuccess('Backup salvo com sucesso!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup exportado com sucesso!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      backupNotifier.setError('Erro ao exportar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao exportar: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      backupNotifier.setLoading(false);
    }
  }

  Future<void> _importBackup() async {
    final backupNotifier = ref.read(backupProvider.notifier);

    try {
      // Pick a file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception('Caminho do arquivo não encontrado');
      }

      backupNotifier.setLoading(true);

      // Read file content
      final file = File(filePath);
      final jsonData = await file.readAsString();

      // Show confirmation dialog
      if (!mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Importação'),
          content: const Text(
            'Isso substituirá todos os dados atuais pelo backup. Deseja continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Importar'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        backupNotifier.setLoading(false);
        return;
      }

      // Import data
      final backupRepository = ref.read(backupRepositoryProvider);
      await backupRepository.importFromJson(jsonData);

      if (!mounted) return;

      backupNotifier.setSuccess('Backup importado com sucesso!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup importado com sucesso!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      backupNotifier.setError('Erro ao importar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao importar: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      backupNotifier.setLoading(false);
    }
  }

  Future<void> _loadSettings() async {
    final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
    final settings = await appSettingsRepository.get();

    if (settings != null && mounted) {
      // Update the form provider first, which will trigger a rebuild
      ref.read(appSettingsFormProvider.notifier).setFromExisting(
            monthlySalary: settings.monthlySalary,
            reserveBalance: settings.reserveBalance,
            maxReserveUsagePercentage: settings.maxReserveUsagePercentage,
          );

      // Convert values to cents for the controllers
      // This ensures the controllers are in sync with what the NubankStyleCurrencyField expects
      final monthlySalaryCents = (settings.monthlySalary * 100).toInt();
      final reserveBalanceCents = (settings.reserveBalance * 100).toInt();

      // Update controllers with the internal representation (cents)
      _monthlySalaryController.text = monthlySalaryCents.toString();
      _reserveBalanceController.text = reserveBalanceCents.toString();
    }
  }

  void _onMaxReservePercentageChanged(double value) {
    ref
        .read(appSettingsFormProvider.notifier)
        .updateMaxReserveUsagePercentage(value);
  }

  void _onMonthlySalaryChanged(double value) {
    ref.read(appSettingsFormProvider.notifier).updateMonthlySalary(value);
  }

  void _onReserveBalanceChanged(double value) {
    ref.read(appSettingsFormProvider.notifier).updateReserveBalance(value);
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
}
