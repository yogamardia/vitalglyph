import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/auth_settings_service.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/theme/theme_cubit.dart';
import 'package:vitalglyph/presentation/screens/auth/pin_setup_screen.dart';
import 'package:vitalglyph/presentation/widgets/app_button.dart';
import 'package:vitalglyph/presentation/widgets/app_dialog.dart';
import 'package:vitalglyph/presentation/widgets/app_section_card.dart';
import 'package:vitalglyph/presentation/widgets/app_snack_bar.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';
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
      AppSnackBar.success(context, context.l10n.settingsPinUpdated);
    }
  }

  Future<void> _clearPin() async {
    final l10n = context.l10n;
    final confirm = await AppDialog.showDestructive(
      context,
      title: l10n.settingsRemovePinTitle,
      message: l10n.settingsRemovePinMessage,
      confirmLabel: l10n.settingsRemovePinAction,
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
    final l10n = context.l10n;
    final selected = await AppBottomSheet.show<LockTimeout>(
      context,
      title: l10n.settingsLockAfterTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: LockTimeout.values.map((t) {
          return BottomSheetOption(
            value: t,
            label: t.localizedName(l10n),
            isSelected: _timeout == t,
            onTap: (val) => Navigator.of(context).pop(val),
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
    return GradientScaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
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
                label: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxl),
      children: [
        // Appearance
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) => AppSectionCard(
            title: context.l10n.settingsAppearance,
            icon: Icons.palette_outlined,
            padding: EdgeInsets.zero,
            children: [
              _ThemeSelectorInternal(mode: mode),
            ],
          ),
        ),

        // Security
        AppSectionCard(
          title: context.l10n.settingsSecurity,
          icon: Icons.security_rounded,
          showDividers: true,
          padding: EdgeInsets.zero,
          children: [
            SettingsToggleTile(
              title: context.l10n.settingsAppLock,
              subtitle: _authEnabled
                  ? context.l10n.settingsAppLockEnabled
                  : context.l10n.settingsAppLockDisabled,
              value: _authEnabled,
              onChanged: _toggleAuth,
            ),
            if (_authEnabled) ...[
              SettingsTile(
                title: context.l10n.settingsLockAfter,
                subtitle: _timeout.localizedName(context.l10n),
                leading: Icons.timer_outlined,
                onTap: _showTimeoutPicker,
              ),
              SettingsTile(
                title: _hasPin ? context.l10n.settingsChangePin : context.l10n.settingsSetPin,
                leading: Icons.pin_outlined,
                onTap: _changePin,
              ),
              if (_hasPin)
                SettingsTile(
                  title: context.l10n.settingsRemovePin,
                  leading: Icons.no_encryption_outlined,
                  destructive: true,
                  onTap: _clearPin,
                ),
              if (_biometricAvailable)
                SettingsToggleTile(
                  title: context.l10n.settingsUseBiometrics,
                  subtitle: context.l10n.settingsBiometricsDescription,
                  value: _biometricEnabled,
                  onChanged: _toggleBiometric,
                ),
            ],
          ],
        ),

        // Data
        AppSectionCard(
          title: context.l10n.settingsData,
          icon: Icons.storage_rounded,
          showDividers: true,
          padding: EdgeInsets.zero,
          children: [
            SettingsTile(
              title: context.l10n.settingsBackupRestore,
              subtitle: context.l10n.settingsBackupRestoreDescription,
              onTap: () => context.push(AppRouter.backup),
            ),
          ],
        ),

        // About
        AppSectionCard(
          title: context.l10n.settingsAbout,
          icon: Icons.info_outline_rounded,
          showDividers: true,
          padding: EdgeInsets.zero,
          children: [
            SettingsTile(
              title: context.l10n.settingsVersion,
              trailing: Text(
                '1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SettingsTile(
              title: context.l10n.settingsPrivacy,
              subtitle: context.l10n.settingsPrivacyDescription,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class _ThemeSelectorInternal extends StatelessWidget {
  final ThemeMode mode;

  const _ThemeSelectorInternal({required this.mode});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.cardBorder,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Sliding highlight
          AnimatedAlign(
            duration: AppDuration.medium,
            curve: Curves.easeOutQuart,
            alignment: _getAlignment(mode),
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _ThemeOption(
                label: context.l10n.settingsThemeSystem,
                icon: Icons.brightness_auto_rounded,
                selected: mode == ThemeMode.system,
                onTap: () => context.read<ThemeCubit>().setSystem(),
              ),
              _ThemeOption(
                label: context.l10n.settingsThemeLight,
                icon: Icons.light_mode_rounded,
                selected: mode == ThemeMode.light,
                onTap: () => context.read<ThemeCubit>().setLight(),
              ),
              _ThemeOption(
                label: context.l10n.settingsThemeDark,
                icon: Icons.dark_mode_rounded,
                selected: mode == ThemeMode.dark,
                onTap: () => context.read<ThemeCubit>().setDark(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Alignment _getAlignment(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Alignment.centerLeft;
      case ThemeMode.light:
        return Alignment.center;
      case ThemeMode.dark:
        return Alignment.centerRight;
    }
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
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.7),
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
