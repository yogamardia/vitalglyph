import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/auth_settings_service.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/theme/theme_cubit.dart';
import 'package:vitalglyph/presentation/screens/auth/pin_setup_screen.dart';
import 'package:vitalglyph/presentation/widgets/app_dialog.dart';
import 'package:vitalglyph/presentation/widgets/app_snack_bar.dart';
import 'package:vitalglyph/presentation/widgets/section_group.dart';
import 'package:vitalglyph/presentation/widgets/settings_tile.dart';

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
    final confirm = await AppDialog.showDestructive(
      context,
      title: 'Remove PIN?',
      message:
          'This will disable app lock. You can set a new PIN at any time.',
      confirmLabel: 'Remove',
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

  Future<void> _showTimeoutPicker() async {
    HapticFeedback.selectionClick();
    final selected = await AppBottomSheet.show<LockTimeout>(
      context,
      title: 'Lock After',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: LockTimeout.values.map((t) {
          return ListTile(
            title: Text(t.displayName),
            trailing: _timeout == t
                ? Icon(Icons.check_rounded,
                    color: Theme.of(context).colorScheme.primary, size: 20)
                : null,
            onTap: () => Navigator.of(context).pop(t),
          );
        }).toList(),
      ),
    );
    if (selected != null && mounted) {
      await _authSettings.setLockTimeout(selected);
      setState(() => _timeout = selected);
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: AppSpacing.lg),
              Text(_loadError!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        // Appearance
        SectionGroup(
          title: 'Appearance',
          children: [_ThemeSelector()],
        ),

        // Security
        SectionGroup(
          title: 'Security',
          children: [
            SettingsToggleTile(
              title: 'App Lock',
              subtitle: _authEnabled
                  ? 'App is locked when you leave'
                  : 'Anyone can open the app',
              leading: Icons.lock_outline_rounded,
              value: _authEnabled,
              onChanged: _toggleAuth,
            ),
            if (_authEnabled) ...[
              SettingsTile(
                title: 'Lock after',
                subtitle: _timeout.displayName,
                leading: Icons.timer_outlined,
                onTap: _showTimeoutPicker,
              ),
              SettingsTile(
                title: _hasPin ? 'Change PIN' : 'Set PIN',
                leading: Icons.pin_outlined,
                onTap: _changePin,
              ),
              if (_hasPin)
                SettingsTile(
                  title: 'Remove PIN',
                  leading: Icons.no_encryption_outlined,
                  destructive: true,
                  onTap: _clearPin,
                ),
              if (_biometricAvailable)
                SettingsToggleTile(
                  title: 'Use Biometrics',
                  subtitle: 'Face ID / fingerprint unlock',
                  leading: Icons.fingerprint_rounded,
                  value: _biometricEnabled,
                  onChanged: _toggleBiometric,
                ),
            ],
          ],
        ),

        // Data
        SectionGroup(
          title: 'Data',
          children: [
            SettingsTile(
              title: 'Backup & Restore',
              subtitle: 'Export or import an encrypted .medid file',
              leading: Icons.backup_outlined,
              onTap: () => context.push(AppRouter.backup),
            ),
          ],
        ),

        // About
        SectionGroup(
          title: 'About',
          children: [
            const SettingsTile(
              title: 'Version',
              trailing: Text(
                '1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            const SettingsTile(
              title: 'Privacy',
              subtitle: 'No data ever leaves your device.',
              leading: Icons.shield_outlined,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<VitalGlyphColors>()!;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.inputFill,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    _ThemeOption(
                      label: 'System',
                      icon: Icons.brightness_auto_outlined,
                      selected: mode == ThemeMode.system,
                      onTap: () => context.read<ThemeCubit>().setSystem(),
                    ),
                    _ThemeOption(
                      label: 'Light',
                      icon: Icons.light_mode_outlined,
                      selected: mode == ThemeMode.light,
                      onTap: () => context.read<ThemeCubit>().setLight(),
                    ),
                    _ThemeOption(
                      label: 'Dark',
                      icon: Icons.dark_mode_outlined,
                      selected: mode == ThemeMode.dark,
                      onTap: () => context.read<ThemeCubit>().setDark(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
