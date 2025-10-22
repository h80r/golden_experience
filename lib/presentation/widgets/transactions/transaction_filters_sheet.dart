import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Filter period options
enum FilterPeriod {
  today('Hoje'),
  thisWeek('Esta semana'),
  thisMonth('Este mês'),
  custom('Personalizado');

  final String label;
  const FilterPeriod(this.label);
}

/// Callback with filter results
typedef OnFiltersChanged = void Function({
  required FilterPeriod period,
  required DateTime? customStartDate,
  required DateTime? customEndDate,
  required Set<int> selectedAccountIds,
  required Set<int> selectedCategoryIds,
});

/// Bottom sheet widget for filtering transactions
class TransactionFiltersSheet extends StatefulWidget {
  final List<({int id, String name})> accounts;
  final List<({int id, String name})> categories;
  final OnFiltersChanged onFiltersChanged;
  final FilterPeriod initialPeriod;
  final DateTime? initialCustomStartDate;
  final DateTime? initialCustomEndDate;
  final Set<int> initialSelectedAccountIds;
  final Set<int> initialSelectedCategoryIds;

  const TransactionFiltersSheet({
    super.key,
    required this.accounts,
    required this.categories,
    required this.onFiltersChanged,
    this.initialPeriod = FilterPeriod.thisMonth,
    this.initialCustomStartDate,
    this.initialCustomEndDate,
    this.initialSelectedAccountIds = const {},
    this.initialSelectedCategoryIds = const {},
  });

  @override
  State<TransactionFiltersSheet> createState() =>
      _TransactionFiltersSheetState();
}

class _TransactionFiltersSheetState extends State<TransactionFiltersSheet> {
  late FilterPeriod _selectedPeriod;
  late DateTime? _customStartDate;
  late DateTime? _customEndDate;
  late Set<int> _selectedAccountIds;
  late Set<int> _selectedCategoryIds;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.initialPeriod;
    _customStartDate = widget.initialCustomStartDate;
    _customEndDate = widget.initialCustomEndDate;
    _selectedAccountIds = Set.from(widget.initialSelectedAccountIds);
    _selectedCategoryIds = Set.from(widget.initialSelectedCategoryIds);
  }

  Future<void> _selectDate(bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _customStartDate ?? DateTime.now() : _customEndDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _customStartDate = picked;
        } else {
          _customEndDate = picked;
        }
      });
    }
  }

  void _applyFilters() {
    widget.onFiltersChanged(
      period: _selectedPeriod,
      customStartDate: _customStartDate,
      customEndDate: _customEndDate,
      selectedAccountIds: _selectedAccountIds,
      selectedCategoryIds: _selectedCategoryIds,
    );
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _selectedPeriod = FilterPeriod.thisMonth;
      _customStartDate = null;
      _customEndDate = null;
      _selectedAccountIds.clear();
      _selectedCategoryIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.divider),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period filter
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Período',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...FilterPeriod.values.map((period) {
                    return CheckboxListTile(
                      title: Text(period.label),
                      value: _selectedPeriod == period,
                      onChanged: (value) {
                        if (value ?? false) {
                          setState(() => _selectedPeriod = period);
                        }
                      },
                      activeColor: AppColors.primary,
                    );
                  }),
                  // Custom date range (only if custom period selected)
                  if (_selectedPeriod == FilterPeriod.custom) ...[
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_customStartDate == null
                          ? 'Data inicial'
                          : _customStartDate.toString().split(' ')[0]),
                      onPressed: () => _selectDate(true),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_customEndDate == null
                          ? 'Data final'
                          : _customEndDate.toString().split(' ')[0]),
                      onPressed: () => _selectDate(false),
                    ),
                  ],
                  // Accounts filter
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Contas',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...widget.accounts.map((account) {
                    final isSelected = _selectedAccountIds.contains(account.id);
                    return CheckboxListTile(
                      title: Text(account.name),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value ?? false) {
                            _selectedAccountIds.add(account.id);
                          } else {
                            _selectedAccountIds.remove(account.id);
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                    );
                  }),
                  // Categories filter
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Categorias',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...widget.categories.map((category) {
                    final isSelected = _selectedCategoryIds.contains(category.id);
                    return CheckboxListTile(
                      title: Text(category.name),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value ?? false) {
                            _selectedCategoryIds.add(category.id);
                          } else {
                            _selectedCategoryIds.remove(category.id);
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                    );
                  }),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
          Divider(color: AppColors.divider),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    child: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
