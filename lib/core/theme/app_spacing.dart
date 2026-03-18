// Spacing, radius, sizing, and animation duration constants for VitalGlyph.

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 28;
}

class AppSizing {
  AppSizing._();
  static const double numPadButtonWidth = 100;
  static const double numPadButtonHeight = 84;
  static const double pinDot = 14;
  static const double minTouchTarget = 48;
}

class AppDuration {
  AppDuration._();
  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}
