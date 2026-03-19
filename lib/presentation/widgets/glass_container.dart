import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';

/// A reusable glassmorphism container that applies a blur effect and semi-transparent background.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final bool enableBlur;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.blurSigma = 20,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.gradient,
    this.enableBlur = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.xxxl);
    final effectiveBackgroundColor = backgroundColor ?? colors.glassBackground;
    final effectiveBorderColor = borderColor ?? colors.glassBorder;

    Widget current = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? effectiveBackgroundColor : null,
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: 1.5,
        ),
      ),
      child: child,
    );

    if (enableBlur) {
      current = ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: current,
        ),
      );
    } else {
      current = ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: current,
      );
    }

    return current;
  }
}
