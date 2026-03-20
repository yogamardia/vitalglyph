import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/l10n/l10n.dart';
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
      if (mounted) AppSnackBar.error(context, context.l10n.backupFileAccessError);
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
      AppSnackBar.warning(context, context.l10n.backupSelectFileWarning);
      return;
    }
    if (!_importFormKey.currentState!.validate()) return;

    final confirmed = await AppDialog.show(
      context,
      title: context.l10n.backupImportTitle,
      message: context.l10n.backupImportMessage,
      confirmLabel: context.l10n.backupImportAction,
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
        title: Text(context.l10n.backupTitle),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocConsumer<BackupCubit, BackupState>(
        listener: (context, state) {
          if (state is BackupExportSuccess) {
            _exportPassCtrl.clear();
            _exportConfirmCtrl.clear();
            context.read<BackupCubit>().reset();
            AppSnackBar.success(context, context.l10n.backupShareSuccess);
          } else if (state is BackupImportSuccess) {
            _importPassCtrl.clear();
            setState(() {
              _selectedFilePath = null;
              _selectedFileName = null;
            });
            context.read<BackupCubit>().reset();
            final r = state.result;
            final msg = r.imported == 0 && r.skipped == 0
                ? context.l10n.backupImportEmpty
                : r.skipped > 0
                    ? context.l10n.backupImportResultWithSkipped(r.imported, r.skipped)
                    : context.l10n.backupImportResult(r.imported);
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
                title: context.l10n.backupExportSection,
                icon: Icons.upload_rounded,
                children: [
                  _InfoBanner(
                    icon: Icons.cloud_upload_rounded,
                    text: context.l10n.backupExportInfo,
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
                            label: context.l10n.backupPassphrase,
                            controller: _exportPassCtrl,
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return context.l10n.backupPassphraseRequired;
                              }
                              if (v.trim().length < 6) {
                                return context.l10n.backupPassphraseMinLength;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: context.l10n.backupConfirmPassphrase,
                            controller: _exportConfirmCtrl,
                            obscureText: true,
                            validator: (v) {
                              if (v != _exportPassCtrl.text) {
                                return context.l10n.backupPassphraseMismatch;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton.primary(
                            onPressed: loading ? null : () => _onExport(context),
                            isLoading: loading,
                            icon: Icons.ios_share_rounded,
                            label: context.l10n.backupExportAction,
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
                title: context.l10n.backupRestoreSection,
                icon: Icons.download_rounded,
                children: [
                  _InfoBanner(
                    icon: Icons.settings_backup_restore_rounded,
                    text: context.l10n.backupRestoreInfo,
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
                            label: context.l10n.backupPassphrase,
                            controller: _importPassCtrl,
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return context.l10n.backupRestorePassphraseRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton.primary(
                            onPressed: loading ? null : () => _onImport(context),
                            isLoading: loading,
                            icon: Icons.restore_rounded,
                            label: context.l10n.backupImportBackupAction,
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
      label: fileName ?? context.l10n.backupPickFile,
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
