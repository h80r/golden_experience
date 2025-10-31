import 'package:flutter/material.dart';

/// Application color palette following design system (Dark Mode)
/// Based on Design Conceitual specification
class AppColors {
  /// Obsidian - Main background color
  static const Color background = Color(0xFF0B1215);

  // ====== Background Colors (Dark Mode) ======
  /// Midnight Blue - Card and surface background
  static const Color surface = Color(0xFF101720);

  /// Slightly lighter surface variant for interactive elements
  static const Color surfaceVariant = Color(0xFF1A2332);

  /// Amarelo Ouro - Main action/CTA color
  static const Color primary = Color(0xFFFFC700);

  // ====== Primary Action Color ======
  /// Amarelo Ouro - Lighter shade for hover/states
  static const Color primaryLight = Color(0xFFFFD54F);

  /// Amarelo Ouro - Darker shade for pressed state
  static const Color primaryDark = Color(0xFFE6B000);

  /// Ciano Vibrante - Branding, icons, and links
  static const Color secondary = Color(0xFF22D3EE);

  // ====== Secondary Branding Color ======
  /// Ciano Vibrante - Lighter shade
  static const Color secondaryLight = Color(0xFF67E8F9);

  /// Ciano Vibrante - Darker shade
  static const Color secondaryDark = Color(0xFF0891B2);

  /// Unohana Flower - High emphasis text
  static const Color textPrimary = Color(0xFFF7FCFE);

  // ====== Text Colors (Dark Mode) ======
  /// Cinza-Claro - Medium emphasis text
  static const Color textSecondary = Color(0xFFB0B0B0);

  /// Cinza-Médio - Low emphasis text
  static const Color textTertiary = Color(0xFF757575);

  /// Verde Menta - Success feedback
  static const Color success = Color(0xFF00C49A);

  // ====== Semantic Colors ======
  /// Vermelho Tomate - Error/Negative feedback
  static const Color error = Color(0xFFE54B4B);

  /// Laranja Queimado - Warning feedback
  static const Color warning = Color(0xFFF79E02);

  /// Ciano Vibrante - Info feedback
  static const Color info = Color(0xFF22D3EE);

  /// Disabled state color
  static const Color disabled = Color(0xFF757575);

  // ====== State Colors ======
  /// Divider color
  static const Color divider = Color(0xFF2A3A4A);

  /// Border color
  static const Color border = Color(0xFF3A4A5A);

  /// Shadow color with transparency
  static const Color shadow = Color(0x3F000000);

  // ====== Shadows ======
  /// Primary color with opacity (for backgrounds)
  static const Color primaryWithOpacity = Color(0x1FFFC700);

  // ====== Primary Color with Opacity ======
  /// Success color with opacity (for backgrounds)
  static const Color successWithOpacity = Color(0x1F00C49A);

  // ====== Semantic Colors with Opacity ======
  /// Warning color with opacity (for backgrounds)
  static const Color warningWithOpacity = Color(0x1FF79E02);

  /// Error color with opacity (for backgrounds)
  static const Color errorWithOpacity = Color(0x1FE54B4B);

  /// Info color with opacity (for backgrounds)
  static const Color infoWithOpacity = Color(0x1F22D3EE);

  // Prevent instantiation
  AppColors._();
}
