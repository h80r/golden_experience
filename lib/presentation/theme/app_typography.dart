import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Application typography system following Design Conceitual specification
/// Fonts:
/// - Titles/Headers: Montserrat Alternates (SemiBold)
/// - Values/Buttons: Prompt (Bold)
/// - Body/Labels: Karma (Regular)
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  // ====== Display Styles (Prompt Bold for large values) ======
  static TextStyle displayLarge = GoogleFonts.prompt(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.prompt(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.prompt(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ====== Headline Styles (Montserrat Alternates SemiBold) ======
  static TextStyle headlineLarge = GoogleFonts.montserratAlternates(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.montserratAlternates(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.montserratAlternates(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  // ====== Title Styles (Montserrat Alternates SemiBold for buttons/labels) ======
  static TextStyle titleLarge = GoogleFonts.prompt(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.prompt(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.prompt(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  // ====== Body Styles (Karma Regular) ======
  static TextStyle bodyLarge = GoogleFonts.karma(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.karma(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.karma(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  // ====== Label Styles (Karma Regular) ======
  static TextStyle labelLarge = GoogleFonts.karma(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  static TextStyle labelMedium = GoogleFonts.karma(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.karma(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
  );
}
