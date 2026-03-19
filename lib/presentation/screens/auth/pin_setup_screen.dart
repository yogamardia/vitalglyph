import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/widgets/app_button.dart';
import 'package:vitalglyph/presentation/widgets/app_text_field.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';

/// Two-step PIN setup: enter → confirm → save.
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  static const _pinLength = 6;

  final _controller = TextEditingController();
  bool _confirming = false;
  String _firstPin = '';
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final pin = _controller.text.trim();
    if (pin.length < _pinLength) {
      setState(() => _error = 'PIN must be $_pinLength digits.');
      return;
    }

    if (!_confirming) {
      setState(() {
        _firstPin = pin;
        _confirming = true;
        _controller.clear();
        _error = null;
      });
      return;
    }

    if (pin != _firstPin) {
      setState(() {
        _error = 'PINs do not match. Start over.';
        _confirming = false;
        _firstPin = '';
        _controller.clear();
      });
      return;
    }

    await sl<PinService>().setPin(_firstPin);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Security Setup'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepIndicator(currentStep: _confirming ? 1 : 0),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey(_confirming),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _confirming ? 'Confirm your PIN' : 'Create a PIN',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _confirming
                        ? 'Re-enter your $_pinLength-digit PIN to confirm it matches.'
                        : 'Choose a $_pinLength-digit PIN to secure your medical information.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: _confirming ? 'Re-enter PIN' : 'Enter PIN',
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    obscureText: _obscure,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_pinLength),
                    ],
                    hintText: '••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(color: cs.error, fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            AppButton.primary(
              onPressed: _onSubmit,
              label: _confirming ? 'Confirm & Save' : 'Continue',
              icon: _confirming ? Icons.lock_outline_rounded : Icons.arrow_forward_rounded,
              fullWidth: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(2, (i) {
        final active = i <= currentStep;
        final isCurrent = i == currentStep;
        return AnimatedContainer(
          duration: AppDuration.medium,
          margin: const EdgeInsets.only(right: 8),
          width: isCurrent ? 32 : 12,
          height: 8,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              if (isCurrent)
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
        );
      }),
    );
  }
}
