import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_state.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';

/// Overlay shown when [AuthRequired] — user must authenticate to proceed.
class LockScreen extends StatefulWidget {
  final bool canUseBiometric;
  final bool hasPinSet;

  const LockScreen({
    super.key,
    required this.canUseBiometric,
    required this.hasPinSet,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with TickerProviderStateMixin {
  static const _pinLength = 6;

  String _entered = '';
  String? _errorMessage;
  Duration? _lockoutRemaining;
  Timer? _lockoutTimer;

  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.02, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.canUseBiometric) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) _triggerBiometric();
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  void _startLockoutCountdown(Duration remaining) {
    _lockoutTimer?.cancel();
    setState(() => _lockoutRemaining = remaining);
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final newRemaining = _lockoutRemaining! - const Duration(seconds: 1);
      if (newRemaining <= Duration.zero) {
        timer.cancel();
        setState(() {
          _lockoutRemaining = null;
          _entered = '';
          _errorMessage = null;
        });
      } else {
        setState(() => _lockoutRemaining = newRemaining);
      }
    });
  }

  void _onDigit(String digit) {
    if (_lockoutRemaining != null) return;
    if (_entered.length >= _pinLength) return;
    HapticFeedback.lightImpact();
    setState(() {
      _entered += digit;
      _errorMessage = null;
    });
    if (_entered.length == _pinLength) {
      _submitPin();
    }
  }

  void _onDelete() {
    if (_lockoutRemaining != null) return;
    if (_entered.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  Future<void> _submitPin() async {
    final cubit = context.read<AuthCubit>();
    await cubit.authenticateWithPin(_entered);
    if (!mounted) return;
    final state = cubit.state;
    if (state is AuthFailure) {
      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0);
      setState(() {
        _errorMessage = state.message;
        _entered = '';
      });
    } else if (state is AuthLockedOut) {
      HapticFeedback.heavyImpact();
      _startLockoutCountdown(state.remaining);
      setState(() => _entered = '');
    }
  }

  Future<void> _triggerBiometric() async {
    final cubit = context.read<AuthCubit>();
    await cubit.authenticateWithBiometric();
    if (!mounted) return;
    final state = cubit.state;
    if (state is AuthFailure) {
      setState(() => _errorMessage = state.message);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
    }
    return '${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          HapticFeedback.heavyImpact();
          _shakeController.forward(from: 0);
          setState(() {
            _errorMessage = state.message;
            _entered = '';
          });
        } else if (state is AuthLockedOut) {
          _startLockoutCountdown(state.remaining);
          setState(() => _entered = '');
        }
      },
      child: GradientScaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: colors.glowPrimary.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.shield_rounded,
                      size: 64,
                      color: cs.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Medical ID Locked',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.hasPinSet
                      ? 'Enter your PIN to continue'
                      : 'Use biometrics to unlock',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 48),
                if (widget.hasPinSet) ...[
                  SlideTransition(
                    position: _shakeAnimation,
                    child: _PinDots(entered: _entered.length, total: _pinLength, colors: colors),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSize(
                    duration: AppDuration.fast,
                    child: _errorMessage != null && _lockoutRemaining == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: cs.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (_lockoutRemaining != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: cs.errorContainer.withValues(alpha: 0.1),
                        borderColor: cs.error.withValues(alpha: 0.3),
                        child: Column(
                          children: [
                            Icon(Icons.timer_rounded, color: cs.error),
                            const SizedBox(height: 8),
                            Text(
                              'Too many attempts. Try again in ${_formatDuration(_lockoutRemaining!)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: cs.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 48),
                  _NumPad(
                    onDigit: _onDigit,
                    onDelete: _onDelete,
                    onBiometric:
                        widget.canUseBiometric ? _triggerBiometric : null,
                    disabled: _lockoutRemaining != null,
                    colors: colors,
                  ),
                ] else if (widget.canUseBiometric) ...[
                  const SizedBox(height: 24),
                  _HeaderAction(
                    icon: Icons.fingerprint_rounded,
                    onPressed: _triggerBiometric,
                    colors: colors,
                    size: 80,
                    iconSize: 40,
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: cs.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  final int entered;
  final int total;
  final VitalGlyphColors colors;

  const _PinDots({required this.entered, required this.total, required this.colors});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final filled = i < entered;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: filled ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuart,
          builder: (context, value, _) {
            return Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  cs.onSurface.withValues(alpha: 0.1),
                  cs.primary,
                  value,
                ),
                boxShadow: [
                  if (value > 0.5)
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.2 * value),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

class _NumPad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;
  final bool disabled;
  final VitalGlyphColors colors;

  const _NumPad({
    required this.onDigit,
    required this.onDelete,
    this.onBiometric,
    this.disabled = false,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(context, ['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(context, ['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(context, ['7', '8', '9']),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBioButton(context),
            const SizedBox(width: 16),
            _buildDigitButton(context, '0'),
            const SizedBox(width: 16),
            _buildDeleteButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < digits.length; i++) ...[
          _buildDigitButton(context, digits[i]),
          if (i < digits.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildDigitButton(BuildContext context, String digit) {
    return _PadButton(
      onTap: disabled ? null : () => onDigit(digit),
      colors: colors,
      child: Text(
        digit,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          fontFamily: 'Plus Jakarta Sans',
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return _PadButton(
      onTap: disabled ? null : onDelete,
      colors: colors,
      child: Icon(
        Icons.backspace_rounded,
        size: 24,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildBioButton(BuildContext context) {
    if (onBiometric == null) return const SizedBox(width: 80, height: 80);
    return _PadButton(
      onTap: disabled ? null : onBiometric!,
      colors: colors,
      enableGlow: true,
      child: Icon(
        Icons.fingerprint_rounded,
        size: 32,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _PadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VitalGlyphColors colors;
  final bool enableGlow;

  const _PadButton({
    required this.child,
    required this.onTap,
    required this.colors,
    this.enableGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onTap,
      enableGlow: enableGlow,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: colors.cardBorder,
            width: 1.5,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VitalGlyphColors colors;
  final double size;
  final double iconSize;

  const _HeaderAction({
    required this.icon,
    required this.onPressed,
    required this.colors,
    this.size = 40,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onPressed,
      enableGlow: true,
      child: GlassContainer(
        width: size,
        height: size,
        backgroundColor: colors.glassBackground,
        borderColor: colors.glassBorder,
        borderRadius: BorderRadius.circular(size / 2),
        child: Center(
          child: Icon(icon, size: iconSize, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
