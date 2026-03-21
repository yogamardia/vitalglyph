import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Factory helpers for [CustomTransitionPage] with premium animations.
class PageTransitions {
  PageTransitions._();

  /// Bottom-to-top slide with spring physics and background fade.
  static CustomTransitionPage<T> slideUp<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final position =
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            );

        return SlideTransition(
          position: position,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  /// Fade with subtle scale component.
  static CustomTransitionPage<T> fade<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.97, end: 1).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  /// Scale + fade with spring overshoot.
  static CustomTransitionPage<T> scaleUp<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.9, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );
        return ScaleTransition(
          scale: scale,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  /// Horizontal slide with parallax and exit fade.
  static CustomTransitionPage<T> slideRight<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final enterTween =
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        final exitTween =
            Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.15, 0),
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeOut,
              ),
            );

        final exitOpacity = Tween<double>(
          begin: 1,
          end: 0.8,
        ).animate(secondaryAnimation);

        return SlideTransition(
          position: enterTween,
          child: SlideTransition(
            position: exitTween,
            child: FadeTransition(opacity: exitOpacity, child: child),
          ),
        );
      },
    );
  }

  /// Scale + fade + blur — translucent frosted entry (settings / backup).
  static CustomTransitionPage<T> glassFade<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.95, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        final blur = Tween<double>(begin: 15, end: 0).animate(animation);

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur.value, sigmaY: blur.value),
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: scale, child: child),
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}
