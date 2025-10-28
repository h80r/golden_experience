import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class InlineCalendar extends StatefulWidget {
  final int selectedDay;
  final Function(int) onDaySelected;
  final bool compactMode;

  const InlineCalendar({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    this.compactMode = false,
  });

  @override
  State<InlineCalendar> createState() => _InlineCalendarState();
}

class _CalendarDayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isCurrentDay;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.day,
    required this.isSelected,
    required this.isCurrentDay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          border: isCurrentDay && !isSelected
              ? Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                )
              : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Center(
          child: Text(
            '$day',
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final int year;
  final int month;

  const _CalendarHeader({
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_getMonthName(month)} $year',
      style: AppTypography.headlineSmall.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return monthNames[month - 1];
  }
}

class _CalendarWeekdayRow extends StatelessWidget {
  final bool compactMode;

  const _CalendarWeekdayRow({this.compactMode = false});

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    return GridView.count(
      padding: compactMode ? EdgeInsets.zero : null,
      crossAxisCount: 7,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: weekdays
          .map(
            (weekday) => Center(
              child: Text(
                weekday,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InlineCalendarState extends State<InlineCalendar> {
  late DateTime _currentMonth;
  late int _selectedDay;

  @override
  Widget build(BuildContext context) {
    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final daysInMonth = _getDaysInMonth(year, month);
    final firstWeekday = _getFirstWeekdayOfMonth(year, month);

    // Build day cells: empty cells for days before month starts, then day numbers
    final dayWidgets = <Widget>[];

    // Add empty cells for days before the 1st
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox.expand());
    }

    // Add day cells (1 to daysInMonth)
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(
        _CalendarDayCell(
          day: day,
          isSelected: day == _selectedDay,
          isCurrentDay: day == DateTime.now().day &&
              month == DateTime.now().month &&
              year == DateTime.now().year,
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
            widget.onDaySelected(day);
          },
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month/Year header
        if (!widget.compactMode) ...[
          _CalendarHeader(
            year: year,
            month: month,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        // Weekday labels
        _CalendarWeekdayRow(compactMode: widget.compactMode),
        if (!widget.compactMode) const SizedBox(height: AppSpacing.md),
        // Calendar grid
        GridView.count(
          padding: widget.compactMode ? EdgeInsets.zero : null,
          crossAxisCount: 7,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: dayWidgets,
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(InlineCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _selectedDay = widget.selectedDay;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDay = widget.selectedDay;
  }

  int _getDaysInMonth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    }
    return DateTime(year, month + 1, 0).day;
  }

  int _getFirstWeekdayOfMonth(int year, int month) {
    // Returns 0 for Sunday, 1 for Monday, ..., 6 for Saturday
    final firstDay = DateTime(year, month, 1);
    return firstDay.weekday % 7;
  }
}
