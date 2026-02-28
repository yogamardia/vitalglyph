import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_state.dart';

/// Overlay shown when [AuthRequired] — user must authenticate to proceed.
/// Accepts a [canUseBiometric] and [hasPinSet] flag from the [AuthRequired] state.
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

class _LockScreenState extends State<LockScreen> {
  static const _pinLength = 6;

  String _entered = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Trigger biometric automatically on open if available and no PIN set.
    if (widget.canUseBiometric) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerBiometric();
      });
    }
  }

  void _onDigit(String digit) {
    if (_entered.length >= _pinLength) return;
    setState(() {
      _entered += digit;
      _errorMessage = null;
    });
    if (_entered.length == _pinLength) {
      _submitPin();
    }
  }

  void _onDelete() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  Future<void> _submitPin() async {
    final cubit = context.read<AuthCubit>();
    await cubit.authenticateWithPin(_entered);
    final state = cubit.state;
    if (state is AuthFailure) {
      setState(() {
        _errorMessage = state.message;
        _entered = '';
      });
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          setState(() {
            _errorMessage = state.message;
            _entered = '';
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.lock_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
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
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 40),
              // PIN dots
              if (widget.hasPinSet) ...[
                _PinDots(entered: _entered.length, total: _pinLength),
                const SizedBox(height: 12),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 24),
                _NumPad(
                  onDigit: _onDigit,
                  onDelete: _onDelete,
                  onBiometric: widget.canUseBiometric ? _triggerBiometric : null,
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
        return Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? color : Colors.transparent,
            border: Border.all(
              color: filled ? color : Colors.grey.shade400,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

class _NumPad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;

  const _NumPad({
    required this.onDigit,
    required this.onDelete,
    this.onBiometric,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        _buildRow(['4', '5', '6']),
        _buildRow(['7', '8', '9']),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBioButton(),
            _buildDigitButton('0'),
            _buildDeleteButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map(_buildDigitButton).toList(),
    );
  }

  Widget _buildDigitButton(String digit) {
    return _PadButton(
      onTap: () => onDigit(digit),
      child: Text(
        digit,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return _PadButton(
      onTap: onDelete,
      child: const Icon(Icons.backspace_outlined, size: 22),
    );
  }

  Widget _buildBioButton() {
    if (onBiometric == null) return const SizedBox(width: 88, height: 72);
    return _PadButton(
      onTap: onBiometric!,
      child: const Icon(Icons.fingerprint, size: 28),
    );
  }
}

class _PadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PadButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 72,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
