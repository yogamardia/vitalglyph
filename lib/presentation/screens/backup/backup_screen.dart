import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_cubit.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_state.dart';
import 'package:vitalglyph/presentation/widgets/app_button.dart';
import 'package:vitalglyph/presentation/widgets/app_dialog.dart';
import 'package:vitalglyph/presentation/widgets/app_section_card.dart';
import 'package:vitalglyph/presentation/widgets/app_snack_bar.dart';
import 'package:vitalglyph/presentation/widgets/app_text_field.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BackupCubit>(),
      child: const _BackupView(),
    );
  }
}

class _BackupView extends StatefulWidget {
  const _BackupView();

  @override
  State<_BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends State<_BackupView> {
  final _exportPassCtrl = TextEditingController();
  final _exportConfirmCtrl = TextEditingController();
  final _exportFormKey = GlobalKey<FormState>();

  final _importPassCtrl = TextEditingController();
  final _importFormKey = GlobalKey<FormState>();
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  void dispose() {
    _exportPassCtrl.dispose();
    _exportConfirmCtrl.dispose();
    _importPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['medid'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.path == null) {
      if (mounted) AppSnackBar.error(context, 'Could not access the selected file.');
      return;
    }
    setState(() {
      _selectedFilePath = file.path;
      _selectedFileName = file.name;
    });
  }

  void _onExport(BuildContext context) {
    if (!_exportFormKey.currentState!.validate()) return;
    context.read<BackupCubit>().export(_exportPassCtrl.text.trim());
  }

  Future<void> _onImport(BuildContext context) async {
    if (_selectedFilePath == null) {
      AppSnackBar.warning(context, 'Please select a .medid backup file.');
      return;
    }
    if (!_importFormKey.currentState!.validate()) return;

    final confirmed = await AppDialog.show(
      context,
      title: 'Import backup?',
      message: 'This will add profiles from the backup. '
          'Existing profiles with the same ID will be skipped.',
      confirmLabel: 'Import',
    );

    if (confirmed != true || !context.mounted) return;
    context
        .read<BackupCubit>()
        .importFromFile(_selectedFilePath!, _importPassCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocConsumer<BackupCubit, BackupState>(
        listener: (context, state) {
          if (state is BackupExportSuccess) {
            _exportPassCtrl.clear();
            _exportConfirmCtrl.clear();
            context.read<BackupCubit>().reset();
            AppSnackBar.success(context, 'Backup shared successfully.');
          } else if (state is BackupImportSuccess) {
            _importPassCtrl.clear();
            setState(() {
              _selectedFilePath = null;
              _selectedFileName = null;
            });
            context.read<BackupCubit>().reset();
            final r = state.result;
            final msg = r.imported == 0 && r.skipped == 0
                ? 'No profiles found in backup.'
                : '${r.imported} profile(s) imported'
                    '${r.skipped > 0 ? ', ${r.skipped} already existed (skipped).' : '.'}';
            AppSnackBar.success(context, msg);
          } else if (state is BackupError) {
            context.read<BackupCubit>().reset();
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          final loading = state is BackupLoading;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            children: [
              // Export section
              AppSectionCard(
                title: 'Export',
                icon: Icons.upload_rounded,
                children: [
                  _InfoBanner(
                    icon: Icons.cloud_upload_rounded,
                    text: 'Creates an encrypted .medid file containing all your profiles. '
                        'You can save it to Files, AirDrop it, or share it anywhere.',
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg,
                    ),
                    child: Form(
                      key: _exportFormKey,
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Backup passphrase',
                            controller: _exportPassCtrl,
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Enter a passphrase to protect the backup.';
                              }
                              if (v.trim().length < 6) {
                                return 'Passphrase must be at least 6 characters.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Confirm passphrase',
                            controller: _exportConfirmCtrl,
                            obscureText: true,
                            validator: (v) {
                              if (v != _exportPassCtrl.text) {
                                return 'Passphrases do not match.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton.primary(
                            onPressed: loading ? null : () => _onExport(context),
                            isLoading: loading,
                            icon: Icons.ios_share_rounded,
                            label: 'Export Backup',
                            fullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Restore section
              AppSectionCard(
                title: 'Restore',
                icon: Icons.download_rounded,
                children: [
                  _InfoBanner(
                    icon: Icons.settings_backup_restore_rounded,
                    text: 'Select a .medid backup file and enter its passphrase. '
                        'Profiles that already exist on this device will be skipped.',
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg,
                    ),
                    child: Form(
                      key: _importFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FilePickerButton(
                            fileName: _selectedFileName,
                            onTap: loading ? null : _pickFile,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Backup passphrase',
                            controller: _importPassCtrl,
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Enter the passphrase for this backup.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton.primary(
                            onPressed: loading ? null : () => _onImport(context),
                            isLoading: loading,
                            icon: Icons.restore_rounded,
                            label: 'Import Backup',
                            fullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }
}

class _FilePickerButton extends StatelessWidget {
  final String? fileName;
  final VoidCallback? onTap;

  const _FilePickerButton({this.fileName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      onPressed: onTap,
      icon: Icons.folder_open_rounded,
      label: fileName ?? 'Pick backup file (.medid)',
      fullWidth: true,
    );
  }
}

/// Soft info banner with a gradient accent bar and glass background.
class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBanner({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 64,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppRadius.md),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: cs.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
