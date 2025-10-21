/// Application spacing constants for consistent layout
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // Base unit
  static const double baseUnit = 8.0;

  // Spacing scale
  static const double xs = baseUnit * 0.5; // 4
  static const double sm = baseUnit * 1.0; // 8
  static const double md = baseUnit * 1.5; // 12
  static const double lg = baseUnit * 2.0; // 16
  static const double xl = baseUnit * 3.0; // 24
  static const double xxl = baseUnit * 4.0; // 32
  static const double xxxl = baseUnit * 5.0; // 40

  // Border radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 999.0;
}
