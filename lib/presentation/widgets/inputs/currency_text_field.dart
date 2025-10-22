import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Custom text field for currency input with Brazilian locale support
/// Accepts comma (,) as decimal separator and formats with thousand separators
class CurrencyTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(double)? onChanged;
  final double? initialValue;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool required;

  const CurrencyTextField({
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
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late FocusNode _focusNode;
  late bool _isFocused;
  late TextEditingController _controller;
  final _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$ ',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _isFocused = false;
    _focusNode.addListener(_handleFocusChange);

    // Initialize controller with initial value if provided
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && widget.initialValue! > 0) {
      _controller.text = _formatCurrency(widget.initialValue!);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
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

  /// Format value to currency string
  String _formatCurrency(double value) {
    return _currencyFormatter.format(value);
  }

  /// Convert formatted currency string to double
  /// Handles both comma and period as decimal separator
  double? _parseValue(String value) {
    if (value.isEmpty) return null;

    // Remove currency symbol and spaces
    String cleaned = value.replaceAll('R\$ ', '').trim();

    // Replace comma with period for parsing
    cleaned = cleaned.replaceAll('.', ''); // Remove thousand separators
    cleaned = cleaned.replaceAll(',', '.'); // Convert comma to period

    try {
      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  void _onChanged(String value) {
    final parsedValue = _parseValue(value);
    if (parsedValue != null && widget.onChanged != null) {
      widget.onChanged!(parsedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.isEnabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: widget.textInputAction,
      inputFormatters: [
        CurrencyInputFormatter(),
      ],
      validator: (value) {
        if (widget.required && (value == null || value.isEmpty)) {
          return '${widget.label} é obrigatório';
        }
        if (widget.validator != null) {
          return widget.validator!(value);
        }
        return null;
      },
      onChanged: _onChanged,
      focusNode: _focusNode,
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

/// Custom TextInputFormatter for currency input
/// Accepts comma as decimal separator and formats with thousand separators
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If empty, return as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-numeric characters except comma and period
    String cleaned = newValue.text.replaceAll(RegExp(r'[^0-9,.]'), '');

    // Find the LAST comma or period (treat as decimal separator)
    int lastSeparatorIndex = -1;
    for (int i = cleaned.length - 1; i >= 0; i--) {
      if (cleaned[i] == ',' || cleaned[i] == '.') {
        lastSeparatorIndex = i;
        break;
      }
    }

    String integerPart;
    String decimalPart;
    bool hasDecimalSeparator = false;

    if (lastSeparatorIndex != -1) {
      // Extract integer and decimal parts
      integerPart = cleaned.substring(0, lastSeparatorIndex).replaceAll(RegExp(r'[,.]'), '');
      decimalPart = cleaned.substring(lastSeparatorIndex + 1).replaceAll(RegExp(r'[,.]'), '');
      hasDecimalSeparator = true;
    } else {
      // No decimal separator
      integerPart = cleaned.replaceAll(RegExp(r'[,.]'), '');
      decimalPart = '';
      hasDecimalSeparator = false;
    }

    // Format with thousand separators
    String formatted = _formatWithSeparators(integerPart, decimalPart, hasDecimalSeparator);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Add thousand separators to currency string
  String _formatWithSeparators(String integerPart, String decimalPart, bool hasDecimalSeparator) {
    // Handle empty integer part
    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    // Add thousand separators to integer part
    String formatted = '';
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count == 3) {
        formatted = '.$formatted';
        count = 0;
      }
      formatted = integerPart[i] + formatted;
      count++;
    }

    // Combine with decimal part (preserve comma even if empty)
    if (hasDecimalSeparator) {
      formatted = '$formatted,$decimalPart';
    }

    return formatted;
  }
}
