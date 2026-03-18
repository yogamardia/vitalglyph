import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_state.dart';

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
    with SingleTickerProviderStateMixin {
  static const _pinLength = 6;

  String _entered = '';
  String? _errorMessage;
  Duration? _lockoutRemaining;
  Timer? _lockoutTimer;

  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    if (widget.canUseBiometric) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) _triggerBiometric();
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
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
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Semantics(
                label: 'Medical ID locked',
                excludeSemantics: true,
                child: Icon(
                  Icons.shield_outlined,
                  size: 52,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Medical ID Locked',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.hasPinSet
                    ? 'Enter your PIN to continue'
                    : 'Use biometrics to unlock',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 40),
              if (widget.hasPinSet) ...[
                SlideTransition(
                  position: _shakeAnimation,
                  child: ExcludeSemantics(
                    child: _PinDots(entered: _entered.length, total: _pinLength),
                  ),
                ),
                Semantics(
                  label: '${_entered.length} of $_pinLength digits entered',
                  liveRegion: true,
                  child: const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                if (_lockoutRemaining != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 4),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            'Too many attempts. Try again in ${_formatDuration(_lockoutRemaining!)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 24),
                _NumPad(
                  onDigit: _onDigit,
                  onDelete: _onDelete,
                  onBiometric:
                      widget.canUseBiometric ? _triggerBiometric : null,
                  disabled: _lockoutRemaining != null,
                ),
              ] else if (widget.canUseBiometric) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _triggerBiometric,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Use Biometrics'),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  final int entered;
  final int total;

  const _PinDots({required this.entered, required this.total});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final filled = i < entered;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: filled ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          builder: (context, value, _) {
            return Transform.scale(
              scale: filled ? (0.8 + 0.2 * value) : 1.0,
              child: Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(Colors.transparent, color, value),
                  border: Border.all(
                    color: Color.lerp(
                        Theme.of(context).colorScheme.outline, color, value)!,
                    width: 2,
                  ),
                ),
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

  const _NumPad({
    required this.onDigit,
    required this.onDelete,
    this.onBiometric,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(context, ['1', '2', '3']),
        _buildRow(context, ['4', '5', '6']),
        _buildRow(context, ['7', '8', '9']),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBioButton(context),
            _buildDigitButton(context, '0'),
            _buildDeleteButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((d) => _buildDigitButton(context, d)).toList(),
    );
  }

  Widget _buildDigitButton(BuildContext context, String digit) {
    return Semantics(
      button: true,
      label: 'digit $digit',
      child: _PadButton(
        onTap: disabled ? null : () => onDigit(digit),
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: disabled
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Semantics(
      button: true,
      label: 'delete',
      child: _PadButton(
        onTap: disabled ? null : onDelete,
        child: Icon(
          Icons.backspace_outlined,
          size: 22,
          color: disabled
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)
              : null,
        ),
      ),
    );
  }

  Widget _buildBioButton(BuildContext context) {
    if (onBiometric == null) return const SizedBox(width: 100, height: 84);
    return Semantics(
      button: true,
      label: 'use biometrics',
      child: _PadButton(
        onTap: disabled ? null : onBiometric!,
        child: Icon(
          Icons.fingerprint,
          size: 28,
          color: disabled
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)
              : null,
        ),
      ),
    );
  }
}

class _PadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PadButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        highlightColor: cs.primaryContainer.withValues(alpha: 0.5),
        splashColor: cs.primaryContainer.withValues(alpha: 0.3),
        child: SizedBox(
          width: 100,
          height: 84,
          child: Center(child: child),
        ),
      ),
    );
  }
}
