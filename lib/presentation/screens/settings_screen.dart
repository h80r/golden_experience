import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/repository_providers.dart';
import '../../utils/brazilian_holidays.dart';
import '../state/app_settings_form_notifier.dart';
import '../state/backup_notifier.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/common/standard_app_bar.dart';
import '../widgets/inputs/custom_dropdown.dart';
import '../widgets/inputs/inline_calendar.dart';
import '../widgets/inputs/nubank_style_currency_field.dart';
import '../widgets/inputs/reserve_percentage_slider.dart';
import '../widgets/inputs/segmented_toggle.dart';
import '../widgets/settings/category_management_section.dart';
import '../widgets/settings/notification_settings_section.dart';
import 'invoice_import_screen.dart';

/// SettingsScreen - Configuration screen for app-wide financial settings
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _monthlySalaryController;
  late PageController _pageController;
  bool _isLoading = true;
  bool _isAutoCaptureEnabled = false;
  int _currentPage = 0;
  Timer? _monthlySalaryDebounce;

  // Salary payment configuration
  String _salaryPaymentMode = 'calendar';
  int _calendarDay = 1;
  String _workdayOption = '1';
  int _customWorkday = 1;
  final Map<String, String> _workdayDates =
      {}; // Formatted dates like "1º dia útil (03/11)"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Configurações',
        showSettings: false,
      ),
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildFinancialPage(context),
                    _buildCategoryPage(context),
                    _buildSystemPage(context),
                  ],
                ),
                _buildPageIndicator(),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _monthlySalaryController.dispose();
    _pageController.dispose();
    _monthlySalaryDebounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _monthlySalaryController = TextEditingController();
    _pageController = PageController();

    // Load existing settings immediately after the first frame
    // This ensures form state is synced with database before UI renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Widget _buildCategoryPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryManagementSection(),
          const SizedBox(
              height: AppSpacing.xxxl + 40), // Extra space for bottom indicator
        ],
      ),
    );
  }

  Widget _buildFinancialPage(BuildContext context) {
    final formState = ref.watch(appSettingsFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auto-save info banner
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Suas configurações são salvas automaticamente',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Monthly Salary
          NubankStyleCurrencyField(
            label: 'Salário Mensal',
            hint: 'Digite seu salário mensal',
            controller: _monthlySalaryController,
            onChanged: _onMonthlySalaryChanged,
            initialValue: formState.monthlySalary,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Reserve Percentage Slider
          ReservePercentageSlider(
            value: formState.maxReserveUsagePercentage,
            onChanged: _onMaxReservePercentageChanged,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Divider
          Divider(
            color: AppColors.border,
            thickness: 1,
            height: AppSpacing.xl,
          ),
          const SizedBox(height: AppSpacing.md),

          // Salary Payment Configuration
          _buildSalaryPaymentSection(),
          const SizedBox(
              height: AppSpacing.xxxl + 40), // Extra space for bottom indicator
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: AppSpacing.xxxl,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: index > 0 ? AppSpacing.sm : 0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSalaryPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data de Recebimento do Salário',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Mode toggle
        SegmentedToggle(
          leftLabel: 'Dia Específico',
          rightLabel: 'Dia Útil',
          isLeftSelected: _salaryPaymentMode == 'calendar',
          onLeftTap: () {
            setState(() {
              _salaryPaymentMode = 'calendar';
            });
            _onSalaryPaymentModeChanged();
          },
          onRightTap: () {
            setState(() {
              _salaryPaymentMode = 'workday';
              // Reset to a valid work-day option when switching modes
              if (!['1', '5', '10', '15', '20', 'last', 'custom']
                  .contains(_workdayOption)) {
                _workdayOption = '1';
              }
            });
            _onSalaryPaymentModeChanged();
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // Calendar or workday selector
        if (_salaryPaymentMode == 'calendar')
          InlineCalendar(
            selectedDay: _calendarDay,
            onDaySelected: _onCalendarDaySelected,
          )
        else
          Column(
            children: [
              CustomDropdown<String>(
                label: 'Dia Útil do Mês',
                value: _workdayDates.containsKey(_workdayOption) ||
                        _workdayOption == 'custom'
                    ? _workdayOption
                    : '1',
                items: [
                  ..._workdayDates.entries.map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  ),
                  const DropdownMenuItem(
                    value: 'custom',
                    child: Text('Outro...'),
                  ),
                ],
                onChanged: _onWorkdayOptionChanged,
              ),
              if (_workdayOption == 'custom') ...[
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  initialValue: _customWorkday.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dia Útil (1-23)',
                    hintText: 'Digite um número entre 1 e 23',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMedium),
                    ),
                  ),
                  onChanged: _onCustomWorkdayChanged,
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildSystemPage(BuildContext context) {
    final backupState = ref.watch(backupProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications Section
          NotificationSettingsSection(
            isAutoCaptureEnabled: _isAutoCaptureEnabled,
            onChanged: _onIsAutoCaptureEnabledChanged,
          ),
          const SizedBox(height: AppSpacing.lg),

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
          const SizedBox(height: AppSpacing.md),

          // Invoice CSV import
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const InvoiceImportScreen(),
                ),
              ),
              icon: const Icon(Icons.receipt_long),
              label: const Text('Importar Fatura CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Delete all transactions
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _deleteAllTransactions,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Excluir Todas as Transações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorWithOpacity,
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
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
          const SizedBox(
              height: AppSpacing.xxxl + 40), // Extra space for bottom indicator
        ],
      ),
    );
  }

  void _calculateWorkdayDates() {
    _workdayDates.clear();

    final options = ['1', '5', '10', '15', '20', 'last'];
    final labels = [
      '1º dia útil',
      '5º dia útil',
      '10º dia útil',
      '15º dia útil',
      '20º dia útil',
      'Último dia útil'
    ];

    for (int i = 0; i < options.length; i++) {
      final date = BrazilianHolidays.calculateSalaryPaymentDate(options[i]);
      if (date != null) {
        _workdayDates[options[i]] =
            '${labels[i]} (${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')})';
      }
    }
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

  Future<void> _deleteAllTransactions() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Todas as Transações'),
        content: const Text(
          'Isso excluirá permanentemente todas as transações e zerará o '
          'valor usado das contas de crédito. Esta ação não pode ser '
          'desfeita. Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final transactionRepository = ref.read(transactionRepositoryProvider);
      final accountRepository = ref.read(accountRepositoryProvider);

      await transactionRepository.deleteAll();

      final accounts = await accountRepository.getAll();
      for (final account in accounts) {
        if (account.isCredit) {
          await accountRepository.updateCreditUsed(account.id, 0);
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as transações foram excluídas'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir transações: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _loadSettings() async {
    final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
    final settings = await appSettingsRepository.get();

    if (settings != null && mounted) {
      // Update the form provider first, which will trigger a rebuild
      ref.read(appSettingsFormProvider.notifier).setFromExisting(
            monthlySalary: settings.monthlySalary,
            maxReserveUsagePercentage: settings.maxReserveUsagePercentage,
          );

      // Convert values to cents for the controllers
      // This ensures the controllers are in sync with what the NubankStyleCurrencyField expects
      final monthlySalaryCents = (settings.monthlySalary * 100).toInt();

      // Update controllers with the internal representation (cents)
      _monthlySalaryController.text = monthlySalaryCents.toString();

      // Load salary payment configuration
      _calculateWorkdayDates();

      // Mark loading as complete and set isAutoCaptureEnabled
      setState(() {
        _isAutoCaptureEnabled = settings.isAutoCaptureEnabled;
        _salaryPaymentMode = settings.salaryPaymentMode;
        _calendarDay = settings.salaryPaymentValue;
        // Only set workday option from saved value if mode is 'workday'
        // Map -1 back to 'last' for UI
        _workdayOption = settings.salaryPaymentMode == 'workday'
            ? (settings.salaryPaymentValue == -1
                ? 'last'
                : settings.salaryPaymentValue.toString())
            : '1';
        _isLoading = false;
      });
    } else if (mounted) {
      // No settings found, just stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onCalendarDaySelected(int day) async {
    setState(() {
      _calendarDay = day;
    });

    // Save immediately
    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      await appSettingsRepository.updateSalaryPaymentConfig(
          _salaryPaymentMode, day);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar dia: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onCustomWorkdayChanged(String value) async {
    final customValue = int.tryParse(value);
    if (customValue == null || customValue < 1 || customValue > 23) return;

    setState(() {
      _customWorkday = customValue;
    });

    // Save immediately
    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      await appSettingsRepository.updateSalaryPaymentConfig(
          _salaryPaymentMode, customValue);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar dia: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onIsAutoCaptureEnabledChanged(bool value) async {
    // Update local state immediately for UI feedback
    setState(() {
      _isAutoCaptureEnabled = value;
    });

    // Auto-save immediately
    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      await appSettingsRepository.updateIsAutoCaptureEnabled(value);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar configuração: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onMaxReservePercentageChanged(double value) async {
    // Update form state
    ref
        .read(appSettingsFormProvider.notifier)
        .updateMaxReserveUsagePercentage(value);

    // Auto-save immediately
    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      await appSettingsRepository.updateMaxReserveUsagePercentage(value);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onMonthlySalaryChanged(double value) {
    // Update form state immediately for UI feedback
    ref.read(appSettingsFormProvider.notifier).updateMonthlySalary(value);

    // Cancel previous timer if exists
    _monthlySalaryDebounce?.cancel();

    // Create new timer for auto-save with 500ms debounce
    _monthlySalaryDebounce = Timer(const Duration(milliseconds: 500), () {
      _saveMonthlySalary(value);
    });
  }

  Future<void> _onSalaryPaymentModeChanged() async {
    // Save immediately
    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      final value = _salaryPaymentMode == 'calendar'
          ? _calendarDay
          : int.tryParse(_workdayOption) ?? 1;
      await appSettingsRepository.updateSalaryPaymentConfig(
          _salaryPaymentMode, value);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar configuração: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onWorkdayOptionChanged(String? value) async {
    if (value == null) return;

    setState(() {
      _workdayOption = value;
      if (value != 'custom') {
        _customWorkday = 1;
      }
    });

    // Save immediately
    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      // Map 'last' to -1 for database storage, otherwise parse as int
      final valueToSave =
          value == 'last' ? -1 : (int.tryParse(value) ?? 1);
      await appSettingsRepository.updateSalaryPaymentConfig(
          _salaryPaymentMode, valueToSave);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar configuração: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveMonthlySalary(double value) async {
    try {
      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      await appSettingsRepository.updateMonthlySalary(value);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar salário: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
