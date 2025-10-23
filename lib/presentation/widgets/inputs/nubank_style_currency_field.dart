import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Nubank-style currency input field
/// User types digits without comma, system builds value from right to left (cents first)
/// Examples:
/// - Type `1` → R$ 0,01
/// - Type `2` → R$ 0,12
/// - Type `3` → R$ 1,23
/// - Type `10056` → R$ 100,56
class NubankStyleCurrencyField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<double>? onChanged;
  final double? initialValue;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool required;

  const NubankStyleCurrencyField({
    required this.label,
    this.hint,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.isEnabled = true,
    this.focusNode,
    this.required = false,
    super.key,
  });

  @override
  State<NubankStyleCurrencyField> createState() =>
      _NubankStyleCurrencyFieldState();
}

class _NubankStyleCurrencyFieldState extends State<NubankStyleCurrencyField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late TextEditingController _displayController;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _controller = widget.controller ?? TextEditingController();
    _displayController = TextEditingController();

    // Initialize with initial value if provided (including zero values)
    if (widget.initialValue != null && widget.initialValue! >= 0) {
      final cents = (widget.initialValue! * 100).toInt();
      _controller.text = cents.toString();
      _updateDisplay();
    }

    // Listen to controller changes from outside
    _controller.addListener(_handleExternalChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _displayController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handleExternalChange() {
    if (mounted) {
      _updateDisplay();
    }
  }

  /// Update display based on internal cents value
  void _updateDisplay() {
    final cents = _parseInternalValue(_controller.text);
    _displayController.text = _formatDisplay(cents);
  }

  /// Parse internal representation (cents as int) to double value
  double _parseInternalValue(String internalValue) {
    if (internalValue.isEmpty) return 0.0;
    try {
      final cents = int.parse(internalValue);
      return cents / 100.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Format cents value for display (R$ X.XXX,XX)
  String _formatDisplay(double value) {
    if (value == 0.0) return 'R\$ 0,00';

    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Handle input change - only accepts digits
  void _onTextChanged(String value) {
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Update internal controller with digits only
    _controller.text = digitsOnly;

    // Update display
    _updateDisplay();

    // Notify parent of value change (always notify, even if empty/zero)
    final numValue = _parseInternalValue(digitsOnly);
    widget.onChanged?.call(numValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _displayController,
      enabled: widget.isEnabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      textInputAction: widget.textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: _onTextChanged,
      focusNode: _focusNode,
      validator: (value) {
        if (widget.required) {
          final internalValue = _parseInternalValue(_controller.text);
          if (internalValue == 0.0) {
            return '${widget.label} é obrigatório';
          }
        }
        if (widget.validator != null) {
          return widget.validator!(_controller.text);
        }
        return null;
      },
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint ?? 'R\$ 0,00',
        labelStyle: AppTypography.labelMedium.copyWith(
          color: _isFocused ? AppColors.secondary : AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Text(
            'R\$ ',
            style: AppTypography.bodyMedium.copyWith(
              color: _isFocused ? AppColors.secondary : AppColors.textTertiary,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: widget.isEnabled
            ? AppColors.surfaceVariant
            : AppColors.surface,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}
