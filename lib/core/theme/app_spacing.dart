// Spacing, radius, sizing, and animation duration constants for VitalGlyph.

class AppSpacing {
  AppSpacing._();
  static const double zero = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double xxxxl = 64;
}

class AppRadius {
  AppRadius._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 36;
  static const double xxxl = 48;
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
  static const spring = Duration(milliseconds: 500);
}
