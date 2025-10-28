import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Calculator overlay for entering expense values
class CalculatorOverlay extends StatefulWidget {
  final void Function(double value) onConfirm;
  final VoidCallback onCancel;

  const CalculatorOverlay({
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  @override
  State<CalculatorOverlay> createState() => _CalculatorOverlayState();
}

/// Individual calculator button widget
class _CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOperator;
  final bool isAction;

  const _CalculatorButton({
    required this.label,
    required this.onPressed,
    this.isOperator = false,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isAction) {
      // Action buttons (Clear, Backspace) - Red error color
      backgroundColor = AppColors.error.withValues(alpha: 0.15);
      textColor = AppColors.error;
      borderColor = AppColors.error;
    } else if (isOperator) {
      // Operator buttons - Amarelo Ouro (primary)
      backgroundColor = AppColors.primary;
      textColor = AppColors.background;
      borderColor = AppColors.primary;
    } else {
      // Number buttons - Slightly lighter surface
      backgroundColor = AppColors.surfaceVariant;
      textColor = AppColors.textPrimary;
      borderColor = AppColors.border;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.headlineMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalculatorOverlayState extends State<CalculatorOverlay> {
  String _display = '0';
  double? _currentValue;
  String? _operator;
  bool _shouldResetDisplay = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLarge),
                      topRight: Radius.circular(AppSpacing.radiusLarge),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Valor da Transação',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: widget.onCancel,
                      ),
                    ],
                  ),
                ),

                // Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  alignment: Alignment.centerRight,
                  child: Text(
                    _display,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Buttons Grid
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.0,
                    children: [
                      // Row 1: 7, 8, 9, Clear
                      _CalculatorButton(
                        label: '7',
                        onPressed: () => _handleNumberInput('7'),
                      ),
                      _CalculatorButton(
                        label: '8',
                        onPressed: () => _handleNumberInput('8'),
                      ),
                      _CalculatorButton(
                        label: '9',
                        onPressed: () => _handleNumberInput('9'),
                      ),
                      _CalculatorButton(
                        label: 'C',
                        onPressed: _handleClear,
                        isAction: true,
                      ),

                      // Row 2: 4, 5, 6, Delete
                      _CalculatorButton(
                        label: '4',
                        onPressed: () => _handleNumberInput('4'),
                      ),
                      _CalculatorButton(
                        label: '5',
                        onPressed: () => _handleNumberInput('5'),
                      ),
                      _CalculatorButton(
                        label: '6',
                        onPressed: () => _handleNumberInput('6'),
                      ),
                      _CalculatorButton(
                        label: '⌫',
                        onPressed: _handleBackspace,
                        isAction: true,
                      ),

                      // Row 3: 1, 2, 3, Division
                      _CalculatorButton(
                        label: '1',
                        onPressed: () => _handleNumberInput('1'),
                      ),
                      _CalculatorButton(
                        label: '2',
                        onPressed: () => _handleNumberInput('2'),
                      ),
                      _CalculatorButton(
                        label: '3',
                        onPressed: () => _handleNumberInput('3'),
                      ),
                      _CalculatorButton(
                        label: '/',
                        onPressed: () => _handleOperator('/'),
                        isOperator: true,
                      ),

                      // Row 4: 0, Decimal, Multiplication, Subtraction
                      _CalculatorButton(
                        label: '0',
                        onPressed: () => _handleNumberInput('0'),
                      ),
                      _CalculatorButton(
                        label: ',',
                        onPressed: _handleDecimal,
                      ),
                      _CalculatorButton(
                        label: '*',
                        onPressed: () => _handleOperator('*'),
                        isOperator: true,
                      ),
                      _CalculatorButton(
                        label: '-',
                        onPressed: () => _handleOperator('-'),
                        isOperator: true,
                      ),

                      // Row 5: Plus, Equals (2 cells)
                      _CalculatorButton(
                        label: '+',
                        onPressed: () => _handleOperator('+'),
                        isOperator: true,
                      ),
                      _CalculatorButton(
                        label: '=',
                        onPressed: _handleEquals,
                        isOperator: true,
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onCancel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            side: const BorderSide(
                              color: AppColors.secondary,
                              width: 1.5,
                            ),
                            foregroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: FilledButton(
                          onPressed: _handleConfirm,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium,
                              ),
                            ),
                          ),
                          child: Text(
                            'Confirmar',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleBackspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _handleClear() {
    setState(() {
      _display = '0';
      _currentValue = null;
      _operator = null;
      _shouldResetDisplay = false;
    });
  }

  void _handleConfirm() {
    final value = double.tryParse(_display);
    if (value != null && value > 0) {
      widget.onConfirm(value);
    }
  }

  void _handleDecimal() {
    setState(() {
      if (!_display.contains('.')) {
        _display = '$_display.';
        _shouldResetDisplay = false;
      }
    });
  }

  void _handleEquals() {
    _performCalculation();
  }

  void _handleNumberInput(String digit) {
    setState(() {
      if (_shouldResetDisplay) {
        _display = digit;
        _shouldResetDisplay = false;
      } else {
        _display = _display == '0' ? digit : _display + digit;
      }
    });
  }

  void _handleOperator(String op) {
    final currentValue = double.tryParse(_display);
    if (currentValue == null) return;

    if (_currentValue != null && _operator != null && !_shouldResetDisplay) {
      _performCalculation();
    } else {
      _currentValue = currentValue;
    }

    _operator = op;
    _shouldResetDisplay = true;
  }

  void _performCalculation() {
    if (_currentValue == null || _operator == null) return;

    final secondValue = double.tryParse(_display);
    if (secondValue == null) return;

    double result = 0;
    switch (_operator) {
      case '+':
        result = _currentValue! + secondValue;
        break;
      case '-':
        result = _currentValue! - secondValue;
        break;
      case '*':
        result = _currentValue! * secondValue;
        break;
      case '/':
        result = secondValue != 0 ? _currentValue! / secondValue : 0;
        break;
    }

    setState(() {
      _display = result.toString();
      _currentValue = null;
      _operator = null;
      _shouldResetDisplay = true;
    });
  }
}
