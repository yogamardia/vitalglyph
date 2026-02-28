import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_cubit.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_state.dart';

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
  // ── Export controllers ────────────────────────────────────────────────────
  final _exportPassCtrl = TextEditingController();
  final _exportConfirmCtrl = TextEditingController();
  final _exportFormKey = GlobalKey<FormState>();
  bool _exportObscure = true;

  // ── Import controllers ────────────────────────────────────────────────────
  final _importPassCtrl = TextEditingController();
  final _importFormKey = GlobalKey<FormState>();
  bool _importObscure = true;
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  void dispose() {
    _exportPassCtrl.dispose();
    _exportConfirmCtrl.dispose();
    _importPassCtrl.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['medid'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.path == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access the selected file.')),
        );
      }
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

  void _onImport(BuildContext context) {
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a .medid backup file.')),
      );
      return;
    }
    if (!_importFormKey.currentState!.validate()) return;
    context
        .read<BackupCubit>()
        .importFromFile(_selectedFilePath!, _importPassCtrl.text.trim());
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: BlocConsumer<BackupCubit, BackupState>(
        listener: (context, state) {
          if (state is BackupExportSuccess) {
            _exportPassCtrl.clear();
            _exportConfirmCtrl.clear();
            context.read<BackupCubit>().reset();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup shared successfully.')),
            );
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          } else if (state is BackupError) {
            context.read<BackupCubit>().reset();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final loading = state is BackupLoading;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _SectionHeader('Export'),
              const _InfoCard(
                icon: Icons.upload_outlined,
                text:
                    'Creates an encrypted .medid file containing all your profiles. '
                    'You can save it to Files, AirDrop it, or share it anywhere.',
              ),
              const SizedBox(height: 12),
              Form(
                key: _exportFormKey,
                child: Column(
                  children: [
                    _PassphraseField(
                      controller: _exportPassCtrl,
                      label: 'Backup passphrase',
                      obscure: _exportObscure,
                      onToggle: () =>
                          setState(() => _exportObscure = !_exportObscure),
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
                    const SizedBox(height: 12),
                    _PassphraseField(
                      controller: _exportConfirmCtrl,
                      label: 'Confirm passphrase',
                      obscure: _exportObscure,
                      onToggle: () =>
                          setState(() => _exportObscure = !_exportObscure),
                      validator: (v) {
                        if (v != _exportPassCtrl.text) {
                          return 'Passphrases do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: loading ? null : () => _onExport(context),
                        icon: loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.ios_share_outlined),
                        label: const Text('Export Backup'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              _SectionHeader('Restore'),
              const _InfoCard(
                icon: Icons.download_outlined,
                text:
                    'Select a .medid backup file and enter its passphrase. '
                    'Profiles that already exist on this device will be skipped.',
              ),
              const SizedBox(height: 12),
              // File picker button
              OutlinedButton.icon(
                onPressed: loading ? null : _pickFile,
                icon: const Icon(Icons.folder_open_outlined),
                label: Text(
                  _selectedFileName ?? 'Pick backup file (.medid)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _importFormKey,
                child: Column(
                  children: [
                    _PassphraseField(
                      controller: _importPassCtrl,
                      label: 'Backup passphrase',
                      obscure: _importObscure,
                      onToggle: () =>
                          setState(() => _importObscure = !_importObscure),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter the passphrase for this backup.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: loading ? null : () => _onImport(context),
                        icon: loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.restore_outlined),
                        label: const Text('Import Backup'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

// ── Shared local widgets ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 20, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassphraseField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final FormFieldValidator<String>? validator;

  const _PassphraseField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }
}
