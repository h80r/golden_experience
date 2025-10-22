import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Application theme configuration using the custom design system
/// Implements dark mode with gold primary and cyan secondary colors
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  /// Dark theme using AppColors design system
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Color Scheme
      colorScheme: ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryDark,
        error: AppColors.error,
        errorContainer: AppColors.error.withValues(alpha: 0.2),
        onSurface: AppColors.textPrimary,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        onError: Colors.white,
      ),
      // Scaffold background
      scaffoldBackgroundColor: AppColors.background,
      // Card theme
      cardColor: AppColors.surface,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      // Text themes
      textTheme: _buildTextTheme(),
      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(),
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 4,
      ),
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.secondary,
      ),
    );
  }

  /// Build input decoration theme
  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textTertiary,
      ),
      errorStyle: AppTypography.bodySmall.copyWith(
        color: AppColors.error,
      ),
    );
  }

  /// Build text theme using AppTypography
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      displayMedium: AppTypography.displayMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      displaySmall: AppTypography.displaySmall.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.textPrimary,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      bodySmall: AppTypography.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      labelLarge: AppTypography.labelLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: AppColors.textTertiary,
      ),
    );
  }
}
