import 'package:flutter/material.dart';

/// Semantic color tokens for VitalGlyph.
/// Access via: `Theme.of(context).extension<VitalGlyphColors>()!`
@immutable
class VitalGlyphColors extends ThemeExtension<VitalGlyphColors> {
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
    required this.cardBorder,
    required this.surfaceSubtle,
    required this.inputFill,
    required this.glassBackground,
    required this.glassBorder,
    required this.glassSurface,
    required this.gradientStart,
    required this.gradientEnd,
    required this.glowPrimary,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });
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

  // Modern UI tokens
  final Color cardBorder;
  final Color surfaceSubtle;
  final Color inputFill;

  // Glassmorphism & Gradients
  final Color glassBackground;
  final Color glassBorder;
  final Color glassSurface;
  final Color gradientStart;
  final Color gradientEnd;
  final Color glowPrimary;
  final Color shimmerBase;
  final Color shimmerHighlight;

  static const light = VitalGlyphColors(
    bloodTypeBadge: Color(0xFF991B1B), // Refined Red 800
    bloodTypeBadgeBackground: Color(0xFFFEF2F2), // Red 50
    bloodTypeBadgeBorder: Color(0xFFFEE2E2), // Red 100
    allergyTag: Color(0xFF92400E), // Amber 800
    allergyTagBackground: Color(0xFFFFFBEB), // Amber 50
    allergyTagBorder: Color(0xFFFEF3C7), // Amber 100
    lifeThreatening: Color(0xFF991B1B),
    severe: Color(0xFFC2410C),
    moderate: Color(0xFFD97706),
    mild: Color(0xFF15803D),
    successGreen: Color(0xFF166534),
    emergencyRed: Color(0xFFB91C1C),
    primaryAction: Color(0xFF0F172A), // Deep Obsidian Slate 900
    dividerSubtle: Color(0xFFF1F5F9), // Slate 100
    tamperWarning: Color(0xFF9A3412),
    tamperWarningBackground: Color(0xFFFFF7ED),
    cardBorder: Color(0xFFE2E8F0), // Slate 200
    surfaceSubtle: Color(0xFFF8FAFC), // Slate 50
    inputFill: Color(0xFFF1F5F9), // Slate 100
    glassBackground: Color(0x050F172A),
    glassBorder: Color(0x0F0F172A),
    glassSurface: Color(0xFAFFFFFF),
    gradientStart: Color(0xFFFFFFFF),
    gradientEnd: Color(0xFFF1F5F9),
    glowPrimary: Color(0x1A0F172A),
    shimmerBase: Color(0xFFF1F5F9),
    shimmerHighlight: Color(0xFFF8FAFC),
  );

  static const dark = VitalGlyphColors(
    bloodTypeBadge: Color(0xFFF87171), // Red 400
    bloodTypeBadgeBackground: Color(0xFF450A0A), // Red 950
    bloodTypeBadgeBorder: Color(0xFF7F1D1D), // Red 900
    allergyTag: Color(0xFFFBBF24), // Amber 400
    allergyTagBackground: Color(0xFF451A03), // Amber 950
    allergyTagBorder: Color(0xFF78350F), // Amber 900
    lifeThreatening: Color(0xFFF87171),
    severe: Color(0xFFFB923C),
    moderate: Color(0xFFFCD34D),
    mild: Color(0xFF4ADE80),
    successGreen: Color(0xFF4ADE80),
    emergencyRed: Color(0xFFEF4444),
    primaryAction: Color(0xFFF8FAFC), // Slate 50
    dividerSubtle: Color(0xFF1E293B), // Slate 800
    tamperWarning: Color(0xFFFB923C),
    tamperWarningBackground: Color(0xFF431407),
    cardBorder: Color(0xFF334155), // Slate 700
    surfaceSubtle: Color(0xFF0F172A), // Slate 900
    inputFill: Color(0xFF1E293B), // Slate 800
    glassBackground: Color(0x1AF8FAFC),
    glassBorder: Color(0x33F8FAFC),
    glassSurface: Color(0xFA020617), // Slate 950
    gradientStart: Color(0xFF020617),
    gradientEnd: Color(0xFF0F172A),
    glowPrimary: Color(0x33F8FAFC),
    shimmerBase: Color(0xFF1E293B),
    shimmerHighlight: Color(0xFF334155),
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
    Color? cardBorder,
    Color? surfaceSubtle,
    Color? inputFill,
    Color? glassBackground,
    Color? glassBorder,
    Color? glassSurface,
    Color? gradientStart,
    Color? gradientEnd,
    Color? glowPrimary,
    Color? shimmerBase,
    Color? shimmerHighlight,
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
      cardBorder: cardBorder ?? this.cardBorder,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      inputFill: inputFill ?? this.inputFill,
      glassBackground: glassBackground ?? this.glassBackground,
      glassBorder: glassBorder ?? this.glassBorder,
      glassSurface: glassSurface ?? this.glassSurface,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      glowPrimary: glowPrimary ?? this.glowPrimary,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  VitalGlyphColors lerp(VitalGlyphColors? other, double t) {
    if (other is! VitalGlyphColors) return this;
    return VitalGlyphColors(
      bloodTypeBadge: Color.lerp(bloodTypeBadge, other.bloodTypeBadge, t)!,
      bloodTypeBadgeBackground: Color.lerp(
        bloodTypeBadgeBackground,
        other.bloodTypeBadgeBackground,
        t,
      )!,
      bloodTypeBadgeBorder: Color.lerp(
        bloodTypeBadgeBorder,
        other.bloodTypeBadgeBorder,
        t,
      )!,
      allergyTag: Color.lerp(allergyTag, other.allergyTag, t)!,
      allergyTagBackground: Color.lerp(
        allergyTagBackground,
        other.allergyTagBackground,
        t,
      )!,
      allergyTagBorder: Color.lerp(
        allergyTagBorder,
        other.allergyTagBorder,
        t,
      )!,
      lifeThreatening: Color.lerp(lifeThreatening, other.lifeThreatening, t)!,
      severe: Color.lerp(severe, other.severe, t)!,
      moderate: Color.lerp(moderate, other.moderate, t)!,
      mild: Color.lerp(mild, other.mild, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      emergencyRed: Color.lerp(emergencyRed, other.emergencyRed, t)!,
      primaryAction: Color.lerp(primaryAction, other.primaryAction, t)!,
      dividerSubtle: Color.lerp(dividerSubtle, other.dividerSubtle, t)!,
      tamperWarning: Color.lerp(tamperWarning, other.tamperWarning, t)!,
      tamperWarningBackground: Color.lerp(
        tamperWarningBackground,
        other.tamperWarningBackground,
        t,
      )!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassSurface: Color.lerp(glassSurface, other.glassSurface, t)!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      glowPrimary: Color.lerp(glowPrimary, other.glowPrimary, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
    );
  }
}
