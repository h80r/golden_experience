import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/app_settings_repository_impl.dart';
import '../../../utils/brazilian_holidays.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../inputs/custom_dropdown.dart';
import '../inputs/inline_calendar.dart';
import '../inputs/nubank_style_currency_field.dart';
import '../inputs/reserve_percentage_slider.dart';
import '../inputs/segmented_toggle.dart';

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

  // Salary payment configuration
  String _salaryPaymentMode = 'calendar';
  int _calendarDay = 1;
  String _workdayOption = '1';
  int _customWorkday = 1;
  final Map<String, String> _workdayDates = {};

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
                SizedBox(height: AppSpacing.xl),
                // Salary payment date section
                _buildSalaryPaymentSection(),
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

  Widget _buildSalaryPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data de Recebimento do Salário',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        // Mode toggle
        SegmentedToggle(
          leftLabel: 'Dia Específico',
          rightLabel: 'Dia Útil',
          isLeftSelected: _salaryPaymentMode == 'calendar',
          onLeftTap: () {
            setState(() {
              _salaryPaymentMode = 'calendar';
            });
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
          },
        ),
        SizedBox(height: AppSpacing.lg),
        // Calendar or workday selector
        if (_salaryPaymentMode == 'calendar')
          InlineCalendar(
            selectedDay: _calendarDay,
            onDaySelected: (day) {
              setState(() {
                _calendarDay = day;
              });
            },
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
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _workdayOption = value;
                    if (value != 'custom') {
                      _customWorkday = 1;
                    }
                  });
                },
              ),
              if (_workdayOption == 'custom') ...[
                SizedBox(height: AppSpacing.md),
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
                  onChanged: (value) {
                    final customValue = int.tryParse(value);
                    if (customValue == null ||
                        customValue < 1 ||
                        customValue > 23) {
                      return;
                    }
                    setState(() {
                      _customWorkday = customValue;
                    });
                  },
                ),
              ],
            ],
          ),
      ],
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
      _calculateWorkdayDates();
      if (settings != null && mounted) {
        setState(() {
          // NubankStyleCurrencyField uses internal representation (cents)
          if (settings.monthlySalary > 0) {
            final cents = (settings.monthlySalary * 100).toInt();
            _salaryController.text = cents.toString();
          }
          _reservePercentage = settings.maxReserveUsagePercentage;
          _salaryPaymentMode = settings.salaryPaymentMode;
          _calendarDay = settings.salaryPaymentValue;
          // Map -1 back to 'last' for UI
          _workdayOption = settings.salaryPaymentMode == 'workday'
              ? (settings.salaryPaymentValue == -1
                  ? 'last'
                  : settings.salaryPaymentValue.toString())
              : '1';
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

      final salaryPaymentValue = _salaryPaymentMode == 'calendar'
          ? _calendarDay
          : (_workdayOption == 'custom'
              ? _customWorkday
              : (_workdayOption == 'last'
                  ? -1
                  : int.tryParse(_workdayOption) ?? 1));
      await repository.updateSalaryPaymentConfig(
          _salaryPaymentMode, salaryPaymentValue);

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
