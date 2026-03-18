import 'package:flutter/material.dart';

/// Semantic color tokens for VitalGlyph.
/// Access via: Theme.of(context).extension<VitalGlyphColors>()!
@immutable
class VitalGlyphColors extends ThemeExtension<VitalGlyphColors> {
  // Blood type badge
  final Color bloodTypeBadge;
  final Color bloodTypeBadgeBackground;
  final Color bloodTypeBadgeBorder;

  // Allergy tag
  final Color allergyTag;
  final Color allergyTagBackground;
  final Color allergyTagBorder;

  // Severity
  final Color lifeThreatening;
  final Color severe;
  final Color moderate;
  final Color mild;

  // Status
  final Color successGreen;
  final Color emergencyRed;
  final Color primaryAction;

  // Surface
  final Color dividerSubtle;
  final Color tamperWarning;
  final Color tamperWarningBackground;

  const VitalGlyphColors({
    required this.bloodTypeBadge,
    required this.bloodTypeBadgeBackground,
    required this.bloodTypeBadgeBorder,
    required this.allergyTag,
    required this.allergyTagBackground,
    required this.allergyTagBorder,
    required this.lifeThreatening,
    required this.severe,
    required this.moderate,
    required this.mild,
    required this.successGreen,
    required this.emergencyRed,
    required this.primaryAction,
    required this.dividerSubtle,
    required this.tamperWarning,
    required this.tamperWarningBackground,
  });

  static const light = VitalGlyphColors(
    bloodTypeBadge: Color(0xFFB71C1C),
    bloodTypeBadgeBackground: Color(0xFFFFF1F1),
    bloodTypeBadgeBorder: Color(0xFFFFE1E1),
    allergyTag: Color(0xFFC2410C),
    allergyTagBackground: Color(0xFFFFF7ED),
    allergyTagBorder: Color(0xFFFFEDD5),
    lifeThreatening: Color(0xFFB71C1C),
    severe: Color(0xFFE64A19),
    moderate: Color(0xFFF57C00),
    mild: Color(0xFF388E3C),
    successGreen: Color(0xFF2E7D32),
    emergencyRed: Color(0xFFD32F2F),
    primaryAction: Color(0xFF1565C0),
    dividerSubtle: Color(0xFFF0F0F0),
    tamperWarning: Color(0xFFE65100),
    tamperWarningBackground: Color(0xFFFFF3E0),
  );

  static const dark = VitalGlyphColors(
    bloodTypeBadge: Color(0xFFEF9A9A),
    bloodTypeBadgeBackground: Color(0xFF3E1010),
    bloodTypeBadgeBorder: Color(0xFF5C1A1A),
    allergyTag: Color(0xFFFFAB76),
    allergyTagBackground: Color(0xFF3E2010),
    allergyTagBorder: Color(0xFF5C3010),
    lifeThreatening: Color(0xFFEF9A9A),
    severe: Color(0xFFFFAB76),
    moderate: Color(0xFFFFCC80),
    mild: Color(0xFFA5D6A7),
    successGreen: Color(0xFF66BB6A),
    emergencyRed: Color(0xFFEF5350),
    primaryAction: Color(0xFF90CAF9),
    dividerSubtle: Color(0xFF2A2A2A),
    tamperWarning: Color(0xFFFFAB40),
    tamperWarningBackground: Color(0xFF3E2800),
  );

  @override
  VitalGlyphColors copyWith({
    Color? bloodTypeBadge,
    Color? bloodTypeBadgeBackground,
    Color? bloodTypeBadgeBorder,
    Color? allergyTag,
    Color? allergyTagBackground,
    Color? allergyTagBorder,
    Color? lifeThreatening,
    Color? severe,
    Color? moderate,
    Color? mild,
    Color? successGreen,
    Color? emergencyRed,
    Color? primaryAction,
    Color? dividerSubtle,
    Color? tamperWarning,
    Color? tamperWarningBackground,
  }) {
    return VitalGlyphColors(
      bloodTypeBadge: bloodTypeBadge ?? this.bloodTypeBadge,
      bloodTypeBadgeBackground:
          bloodTypeBadgeBackground ?? this.bloodTypeBadgeBackground,
      bloodTypeBadgeBorder: bloodTypeBadgeBorder ?? this.bloodTypeBadgeBorder,
      allergyTag: allergyTag ?? this.allergyTag,
      allergyTagBackground: allergyTagBackground ?? this.allergyTagBackground,
      allergyTagBorder: allergyTagBorder ?? this.allergyTagBorder,
      lifeThreatening: lifeThreatening ?? this.lifeThreatening,
      severe: severe ?? this.severe,
      moderate: moderate ?? this.moderate,
      mild: mild ?? this.mild,
      successGreen: successGreen ?? this.successGreen,
      emergencyRed: emergencyRed ?? this.emergencyRed,
      primaryAction: primaryAction ?? this.primaryAction,
      dividerSubtle: dividerSubtle ?? this.dividerSubtle,
      tamperWarning: tamperWarning ?? this.tamperWarning,
      tamperWarningBackground:
          tamperWarningBackground ?? this.tamperWarningBackground,
    );
  }

  @override
  VitalGlyphColors lerp(VitalGlyphColors? other, double t) {
    if (other is! VitalGlyphColors) return this;
    return VitalGlyphColors(
      bloodTypeBadge: Color.lerp(bloodTypeBadge, other.bloodTypeBadge, t)!,
      bloodTypeBadgeBackground: Color.lerp(
          bloodTypeBadgeBackground, other.bloodTypeBadgeBackground, t)!,
      bloodTypeBadgeBorder:
          Color.lerp(bloodTypeBadgeBorder, other.bloodTypeBadgeBorder, t)!,
      allergyTag: Color.lerp(allergyTag, other.allergyTag, t)!,
      allergyTagBackground:
          Color.lerp(allergyTagBackground, other.allergyTagBackground, t)!,
      allergyTagBorder:
          Color.lerp(allergyTagBorder, other.allergyTagBorder, t)!,
      lifeThreatening:
          Color.lerp(lifeThreatening, other.lifeThreatening, t)!,
      severe: Color.lerp(severe, other.severe, t)!,
      moderate: Color.lerp(moderate, other.moderate, t)!,
      mild: Color.lerp(mild, other.mild, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      emergencyRed: Color.lerp(emergencyRed, other.emergencyRed, t)!,
      primaryAction: Color.lerp(primaryAction, other.primaryAction, t)!,
      dividerSubtle: Color.lerp(dividerSubtle, other.dividerSubtle, t)!,
      tamperWarning: Color.lerp(tamperWarning, other.tamperWarning, t)!,
      tamperWarningBackground: Color.lerp(
          tamperWarningBackground, other.tamperWarningBackground, t)!,
    );
  }
}
