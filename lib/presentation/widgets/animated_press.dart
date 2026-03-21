import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';

/// A reusable widget that provides animated scale feedback on press.
class AnimatedPress extends StatefulWidget {

  const AnimatedPress({
    required this.child, super.key,
    this.onTap,
    this.onLongPress,
    this.scaleDown = 0.97,
    this.enableGlow = false,
    this.behavior = HitTestBehavior.opaque,
  });
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleDown;
  final bool enableGlow;
  final HitTestBehavior behavior;

  @override
  State<AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<AnimatedPress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDuration.fast,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      behavior: widget.behavior,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          Widget current = Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );

          if (widget.enableGlow && _scaleAnimation.value < 1.0) {
            current = Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: colors.glowPrimary.withValues(
                      alpha: (1.0 - _scaleAnimation.value) * 0.5,
                    ),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: current,
            );
          }

          return current;
        },
        child: widget.child,
      ),
    );
  }
}
