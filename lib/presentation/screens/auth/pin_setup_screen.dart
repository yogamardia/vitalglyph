import 'package:flutter/material.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/injection.dart';

/// Two-step PIN setup: enter → confirm → save.
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  static const _pinLength = 6;

  final _controller = TextEditingController();
  final _confirmController = TextEditingController();
  bool _confirming = false;
  String _firstPin = '';
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    _confirmController.dispose();
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

    final confirm = _controller.text.trim();
    if (confirm != _firstPin) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_confirming ? 'Confirm PIN' : 'Set PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _confirming
                  ? 'Re-enter your $_pinLength-digit PIN to confirm.'
                  : 'Choose a $_pinLength-digit PIN to lock the app.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              obscureText: _obscure,
              maxLength: _pinLength,
              autofocus: true,
              decoration: InputDecoration(
                labelText: _confirming ? 'Confirm PIN' : 'Enter PIN',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                errorText: _error,
              ),
              onFieldSubmitted: (_) => _onSubmit(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onSubmit,
                child: Text(_confirming ? 'Confirm' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
