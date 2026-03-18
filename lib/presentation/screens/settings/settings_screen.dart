import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/auth_settings_service.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/theme/theme_cubit.dart';
import 'package:vitalglyph/presentation/screens/auth/pin_setup_screen.dart';
import 'package:vitalglyph/presentation/widgets/app_snack_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AuthSettingsService _authSettings;
  late final PinService _pinService;
  late final LocalAuthentication _localAuth;

  bool _authEnabled = false;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  bool _hasPin = false;
  LockTimeout _timeout = LockTimeout.immediately;
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _authSettings = sl<AuthSettingsService>();
    _pinService = sl<PinService>();
    _localAuth = sl<LocalAuthentication>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final authEnabled = await _authSettings.isAuthEnabled();
      final bioEnabled = await _authSettings.isBiometricEnabled();
      final timeout = await _authSettings.getLockTimeout();
      final hasPin = await _pinService.hasPin();
      final bioAvailable = await _localAuth.isDeviceSupported() &&
          await _localAuth.canCheckBiometrics;

      if (mounted) {
        setState(() {
          _authEnabled = authEnabled;
          _biometricEnabled = bioEnabled;
          _biometricAvailable = bioAvailable;
          _timeout = timeout;
          _hasPin = hasPin;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'Failed to load settings. Tap to retry.';
        });
      }
    }
  }

  Future<void> _toggleAuth(bool enabled) async {
    if (enabled && !_hasPin) {
      final set = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const PinSetupScreen()),
      );
      if (set != true) return;
      setState(() => _hasPin = true);
    }
    await _authSettings.setAuthEnabled(enabled);
    if (!mounted) return;
    setState(() => _authEnabled = enabled);
    if (!enabled) {
      context.read<AuthCubit>().disable();
    }
  }

  Future<void> _toggleBiometric(bool enabled) async {
    await _authSettings.setBiometricEnabled(enabled);
    setState(() => _biometricEnabled = enabled);
  }

  Future<void> _changePin() async {
    final set = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PinSetupScreen()),
    );
    if (set == true && mounted) {
      setState(() => _hasPin = true);
      AppSnackBar.success(context, 'PIN updated.');
    }
  }

  Future<void> _clearPin() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove PIN?'),
        content: const Text(
          'This will disable app lock. You can set a new PIN at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _pinService.clearPin();
    await _authSettings.setAuthEnabled(false);
    if (mounted) {
      setState(() {
        _hasPin = false;
        _authEnabled = false;
      });
      context.read<AuthCubit>().disable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(_loadError!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: [
        _SectionHeader('Appearance'),
        _ThemeSelector(),
        const Divider(),
        _SectionHeader('Security'),
        SwitchListTile(
          title: const Text('App Lock'),
          subtitle: Text(
            _authEnabled
                ? 'App is locked when you leave'
                : 'Anyone can open the app',
          ),
          value: _authEnabled,
          onChanged: _toggleAuth,
        ),
        if (_authEnabled) ...[
          ListTile(
            title: const Text('Lock after'),
            trailing: DropdownButton<LockTimeout>(
              value: _timeout,
              underline: const SizedBox(),
              items: LockTimeout.values
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.displayName),
                    ),
                  )
                  .toList(),
              onChanged: (t) async {
                if (t == null) return;
                await _authSettings.setLockTimeout(t);
                setState(() => _timeout = t);
              },
            ),
          ),
          ListTile(
            title: Text(_hasPin ? 'Change PIN' : 'Set PIN'),
            leading: const Icon(Icons.pin_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePin,
          ),
          if (_hasPin)
            ListTile(
              title: const Text('Remove PIN'),
              leading: const Icon(Icons.no_encryption_outlined),
              textColor: Theme.of(context).colorScheme.error,
              iconColor: Theme.of(context).colorScheme.error,
              onTap: _clearPin,
            ),
          if (_biometricAvailable)
            SwitchListTile(
              title: const Text('Use Biometrics'),
              subtitle: const Text('Face ID / fingerprint unlock'),
              value: _biometricEnabled,
              onChanged: _toggleBiometric,
            ),
        ],
        const Divider(),
        _SectionHeader('Data'),
        ListTile(
          title: const Text('Backup & Restore'),
          subtitle: const Text('Export or import an encrypted .medid file'),
          leading: const Icon(Icons.backup_outlined),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(AppRouter.backup),
        ),
        const Divider(),
        _SectionHeader('About'),
        const ListTile(
          title: Text('Version'),
          trailing: Text('1.0.0'),
        ),
        const ListTile(
          title: Text('Privacy'),
          subtitle: Text('No data ever leaves your device.'),
        ),
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto_outlined),
                label: Text('System'),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_outlined),
                label: Text('Light'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined),
                label: Text('Dark'),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selection) {
              final cubit = context.read<ThemeCubit>();
              switch (selection.first) {
                case ThemeMode.light:
                  cubit.setLight();
                case ThemeMode.dark:
                  cubit.setDark();
                case ThemeMode.system:
                  cubit.setSystem();
              }
            },
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
