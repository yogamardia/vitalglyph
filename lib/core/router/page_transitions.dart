import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Factory helpers for [CustomTransitionPage] used in go_router [pageBuilder].
class PageTransitions {
  PageTransitions._();

  /// Bottom-to-top slide — fullscreen dialog feel (editor screens).
  static CustomTransitionPage<T> slideUp<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Fade — immersive takeover (QR display / scanner).
  static CustomTransitionPage<T> fade<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Scale + fade — modern card-style entry (detail views).
  static CustomTransitionPage<T> scaleUp<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        final fadeTween = Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut));
        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  /// Horizontal shared-axis slide (settings / backup / scan result).
  static CustomTransitionPage<T> slideRight<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut));
        final secondary = Tween(
          begin: Offset.zero,
          end: const Offset(-0.25, 0.0),
        ).chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: SlideTransition(
            position: secondaryAnimation.drive(secondary),
            child: child,
          ),
        );
      },
    );
  }
}
