import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/presentation/widgets/app_button.dart';
import 'package:vitalglyph/presentation/widgets/app_dialog.dart';
import 'package:vitalglyph/presentation/widgets/app_section_card.dart';
import 'package:vitalglyph/presentation/widgets/app_snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_event.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_state.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';

const _uuid = Uuid();

class ProfileEditorScreen extends StatefulWidget {
  final Profile? profile;

  const ProfileEditorScreen({super.key, this.profile});

  @override
  State<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends State<ProfileEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _langCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;

  DateTime? _dateOfBirth;
  BloodType? _bloodType;
  BiologicalSex? _biologicalSex;
  bool _isOrganDonor = false;

  late List<Allergy> _allergies;
  late List<Medication> _medications;
  late List<MedicalCondition> _conditions;
  late List<EmergencyContact> _contacts;

  String? _photoPath;
  bool _isSaving = false;

  bool get _isEditing => widget.profile != null;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _photoPath = p?.photoPath;
    _dateOfBirth = p?.dateOfBirth;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _dobCtrl = TextEditingController(
      text: p?.dateOfBirth != null ? _formatDate(p!.dateOfBirth) : '',
    );
    _notesCtrl = TextEditingController(text: p?.medicalNotes ?? '');
    _langCtrl = TextEditingController(text: p?.primaryLanguage ?? '');
    _heightCtrl = TextEditingController(
      text: p?.heightCm != null ? p!.heightCm!.toStringAsFixed(0) : '',
    );
    _weightCtrl = TextEditingController(
      text: p?.weightKg != null ? p!.weightKg!.toStringAsFixed(1) : '',
    );
    _bloodType = p?.bloodType;
    _biologicalSex = p?.biologicalSex;
    _isOrganDonor = p?.isOrganDonor ?? false;
    _allergies = List.from(p?.allergies ?? []);
    _medications = List.from(p?.medications ?? []);
    _conditions = List.from(p?.conditions ?? []);
    _contacts = List.from(p?.emergencyContacts ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _notesCtrl.dispose();
    _langCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(DateTime.now().year - 30),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        _dobCtrl.text = _formatDate(picked);
      });
    }
  }

  Future<void> _pickPhoto() async {
    // Use String result: 'camera', 'gallery', 'remove', or null (dismissed)
    final choice = await AppBottomSheet.show<String>(
      context,
      title: 'Profile Photo',
      child: Column(
        children: [
          BottomSheetOption(
            value: 'camera',
            label: 'Take Photo',
            icon: Icons.camera_alt_rounded,
            onTap: (_) {},
          ),
          const SizedBox(height: AppSpacing.sm),
          BottomSheetOption(
            value: 'gallery',
            label: 'Choose from Gallery',
            icon: Icons.photo_library_rounded,
            onTap: (_) {},
          ),
          if (_photoPath != null) ...[
            const SizedBox(height: AppSpacing.sm),
            BottomSheetOption(
              value: 'remove',
              label: 'Remove Photo',
              icon: Icons.delete_rounded,
              isDestructive: true,
              onTap: (_) {},
            ),
          ],
        ],
      ),
    );

    if (choice == null) return;

    if (choice == 'remove') {
      if (_photoPath != null) {
        final oldFile = File(_photoPath!);
        if (oldFile.existsSync()) oldFile.deleteSync();
      }
      setState(() => _photoPath = null);
      return;
    }

    final source =
        choice == 'camera' ? ImageSource.camera : ImageSource.gallery;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );
      if (picked == null) return;

      // Copy to app documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(appDir.path, 'profile_photos'));
      if (!photosDir.existsSync()) {
        photosDir.createSync(recursive: true);
      }

      final ext = p.extension(picked.path).isEmpty
          ? '.jpg'
          : p.extension(picked.path);
      final fileName = '${_uuid.v4()}$ext';
      final destPath = p.join(photosDir.path, fileName);
      await File(picked.path).copy(destPath);

      // Delete old photo file if replacing
      if (_photoPath != null) {
        final oldFile = File(_photoPath!);
        if (oldFile.existsSync()) oldFile.deleteSync();
      }

      setState(() => _photoPath = destPath);
    } catch (e) {
      if (mounted) AppSnackBar.error(context, 'Could not load photo');
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      AppSnackBar.warning(context, 'Please select a date of birth');
      return;
    }
    setState(() => _isSaving = true);

    final now = DateTime.now();
    final existing = widget.profile;
    final profile = Profile(
      id: existing?.id ?? _uuid.v4(),
      name: _nameCtrl.text.trim(),
      dateOfBirth: _dateOfBirth!,
      bloodType: _bloodType,
      biologicalSex: _biologicalSex,
      heightCm: _heightCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(_heightCtrl.text.trim()),
      weightKg: _weightCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(_weightCtrl.text.trim()),
      isOrganDonor: _isOrganDonor,
      medicalNotes:
          _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      primaryLanguage:
          _langCtrl.text.trim().isEmpty ? null : _langCtrl.text.trim(),
      photoPath: _photoPath,
      allergies: List.unmodifiable(_allergies),
      medications: List.unmodifiable(_medications),
      conditions: List.unmodifiable(_conditions),
      emergencyContacts: List.unmodifiable(_contacts),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    if (!_isEditing) {
      context.read<ProfileBloc>().add(ProfileCreateRequested(profile));
    } else {
      context.read<ProfileBloc>().add(ProfileUpdateRequested(profile));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (!_isSaving) return;
        if (state is ProfileLoaded) {
          HapticFeedback.mediumImpact();
          context.pop();
        } else if (state is ProfileError) {
          setState(() => _isSaving = false);
          AppSnackBar.error(context, state.message);
        }
      },
      child: GradientScaffold(
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(theme),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 24),
                    _buildBasicInfoSection(theme),
                    const SizedBox(height: 24),
                    _buildMedicalSection(theme),
                    const SizedBox(height: 24),
                    _buildEmergencySection(theme),
                    const SizedBox(height: 120),
                  ]),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppButton.primary(
            onPressed: _isSaving ? null : _save,
            isLoading: _isSaving,
            label: _isEditing ? 'Update Profile' : 'Save Profile',
            icon: Icons.check_rounded,
            fullWidth: true,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;
    return SliverAppBar(
      expandedHeight: 220,
      floating: true,
      pinned: true,
      stretch: true,
      backgroundColor: cs.surface,
      elevation: 0,
      leading: const BackButton(),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        centerTitle: true,
        title: Text(
          _isEditing ? 'Edit Profile' : 'New Profile',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.surfaceSubtle,
                    cs.surface,
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: Hero(
                  tag: 'profile_image_${widget.profile?.id ?? 'new'}',
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.cardBorder,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: colors.inputFill,
                          backgroundImage: _photoPath != null
                              ? FileImage(File(_photoPath!))
                              : null,
                          child: _photoPath == null
                              ? Icon(
                                  Icons.person_add_rounded,
                                  size: 40,
                                  color: cs.primary.withValues(alpha: 0.5),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cs.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _photoPath != null
                                  ? Icons.edit_rounded
                                  : Icons.camera_alt_rounded,
                              size: 14,
                              color: cs.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(ThemeData theme) {
    return AppSectionCard(
      title: 'Basic Information',
      icon: Icons.person_rounded,
      children: [
        _CustomTextField(
          controller: _nameCtrl,
          label: 'Full Name',
          prefixIcon: Icons.badge_rounded,
          isRequired: true,
          textCapitalization: TextCapitalization.words,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Name is required' : null,
        ),
        const SizedBox(height: 20),
        _CustomTextField(
          controller: _dobCtrl,
          label: 'Date of Birth',
          prefixIcon: Icons.calendar_today_rounded,
          isRequired: true,
          readOnly: true,
          onTap: _pickDateOfBirth,
          validator: (_) =>
              _dateOfBirth == null ? 'Date of birth is required' : null,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _CustomDropdown<BloodType?>(
                value: _bloodType,
                label: 'Blood Type',
                prefixIcon: Icons.water_drop_rounded,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Unknown')),
                  ...BloodType.values.map(
                    (b) => DropdownMenuItem(
                      value: b,
                      child: Text(b.displayName),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _bloodType = v),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CustomDropdown<BiologicalSex?>(
                value: _biologicalSex,
                label: 'Sex',
                prefixIcon: Icons.people_rounded,
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Not set')),
                  ...BiologicalSex.values.map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.displayName),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _biologicalSex = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _CustomTextField(
                controller: _heightCtrl,
                label: 'Height (cm)',
                prefixIcon: Icons.height_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CustomTextField(
                controller: _weightCtrl,
                label: 'Weight (kg)',
                prefixIcon: Icons.monitor_weight_rounded,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              _isOrganDonor
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: 20,
              color: _isOrganDonor ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Organ Donor',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Switch(
              value: _isOrganDonor,
              onChanged: (v) => setState(() => _isOrganDonor = v),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _CustomTextField(
          controller: _langCtrl,
          label: 'Primary Language',
          prefixIcon: Icons.translate_rounded,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildMedicalSection(ThemeData theme) {
    return AppSectionCard(
      title: 'Medical Details',
      icon: Icons.health_and_safety_rounded,
      children: [
        _buildSubEntitySection<Allergy>(
          title: 'Allergies',
          items: _allergies,
          itemBuilder: _allergyTile,
          onAdd: () async {
            final result = await _showAllergyDialog();
            if (result != null) setState(() => _allergies.add(result));
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Divider(height: 1),
        ),
        _buildSubEntitySection<Medication>(
          title: 'Medications',
          items: _medications,
          itemBuilder: _medicationTile,
          onAdd: () async {
            final result = await _showMedicationDialog();
            if (result != null) setState(() => _medications.add(result));
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Divider(height: 1),
        ),
        _buildSubEntitySection<MedicalCondition>(
          title: 'Medical Conditions',
          items: _conditions,
          itemBuilder: _conditionTile,
          onAdd: () async {
            final result = await _showConditionDialog();
            if (result != null) setState(() => _conditions.add(result));
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Divider(height: 1),
        ),
        _CustomTextField(
          controller: _notesCtrl,
          label: 'Medical Notes',
          prefixIcon: Icons.notes_rounded,
          maxLines: 4,
          minLines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildEmergencySection(ThemeData theme) {
    return AppSectionCard(
      title: 'Emergency Contacts',
      icon: Icons.contact_emergency_rounded,
      children: [
        _buildSubEntitySection<EmergencyContact>(
          title: 'Contacts',
          items: _contacts,
          itemBuilder: _contactTile,
          onAdd: () async {
            final result = await _showContactDialog();
            if (result != null) setState(() => _contacts.add(result));
          },
        ),
      ],
    );
  }

  Widget _buildSubEntitySection<T>({
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required VoidCallback onAdd,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.primary,
              ),
            ),
            _AddButton(onPressed: onAdd),
          ],
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'No ${title.toLowerCase()} added yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(top: 12),
                child: itemBuilder(item),
              )),
      ],
    );
  }

  Widget _allergyTile(Allergy allergy) {
    final index = _allergies.indexOf(allergy);
    final sub = allergy.reaction != null
        ? '${allergy.severity.displayName} · ${allergy.reaction}'
        : allergy.severity.displayName;
    return _SubEntityTile(
      title: allergy.name,
      subtitle: sub,
      onEdit: () async {
        final result = await _showAllergyDialog(allergy);
        if (result != null) setState(() => _allergies[index] = result);
      },
      onDelete: () => setState(() => _allergies.removeAt(index)),
    );
  }

  Widget _medicationTile(Medication med) {
    final index = _medications.indexOf(med);
    final parts = <String>[
      if (med.dosage != null) med.dosage!,
      if (med.frequency != null) med.frequency!,
    ];
    return _SubEntityTile(
      title: med.name,
      subtitle: parts.isEmpty ? null : parts.join(' · '),
      onEdit: () async {
        final result = await _showMedicationDialog(med);
        if (result != null) setState(() => _medications[index] = result);
      },
      onDelete: () => setState(() => _medications.removeAt(index)),
    );
  }

  Widget _conditionTile(MedicalCondition condition) {
    final index = _conditions.indexOf(condition);
    return _SubEntityTile(
      title: condition.name,
      subtitle: condition.diagnosedDate,
      onEdit: () async {
        final result = await _showConditionDialog(condition);
        if (result != null) setState(() => _conditions[index] = result);
      },
      onDelete: () => setState(() => _conditions.removeAt(index)),
    );
  }

  Widget _contactTile(EmergencyContact contact) {
    final index = _contacts.indexOf(contact);
    final sub = contact.relationship != null
        ? '${contact.relationship} · ${contact.phone}'
        : contact.phone;
    return _SubEntityTile(
      title: contact.name,
      subtitle: sub,
      onEdit: () async {
        final result = await _showContactDialog(contact);
        if (result != null) setState(() => _contacts[index] = result);
      },
      onDelete: () => setState(() => _contacts.removeAt(index)),
    );
  }

  Future<Allergy?> _showAllergyDialog([Allergy? existing]) {
    return showDialog<Allergy>(
      context: context,
      builder: (ctx) => _AllergyDialog(existing: existing),
    );
  }

  Future<Medication?> _showMedicationDialog([Medication? existing]) {
    return showDialog<Medication>(
      context: context,
      builder: (ctx) => _MedicationDialog(existing: existing),
    );
  }

  Future<MedicalCondition?> _showConditionDialog([MedicalCondition? existing]) {
    return showDialog<MedicalCondition>(
      context: context,
      builder: (ctx) => _ConditionDialog(existing: existing),
    );
  }

  Future<EmergencyContact?> _showContactDialog([EmergencyContact? existing]) {
    return showDialog<EmergencyContact>(
      context: context,
      builder: (ctx) => _ContactDialog(
        existing: existing,
        nextPriority: _contacts.length + 1,
      ),
    );
  }
}


class _CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final bool readOnly;
  final bool isRequired;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;

  const _CustomTextField({
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.readOnly = false,
    this.isRequired = false,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return AnimatedContainer(
      duration: AppDuration.fast,
      decoration: BoxDecoration(
        color: _isFocused ? cs.surface : colors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _isFocused ? cs.primary : colors.cardBorder,
          width: 1.5,
        ),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        textCapitalization: widget.textCapitalization,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
        decoration: InputDecoration(
          label: widget.isRequired
              ? RichText(
                  text: TextSpan(
                    text: widget.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _isFocused ? cs.primary : cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: cs.error,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          labelText: widget.isRequired ? null : widget.label,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  size: 20,
                  color: _isFocused ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.5),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _CustomDropdown<T> extends StatelessWidget {
  final T value;
  final String label;
  final IconData? prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _CustomDropdown({
    required this.value,
    required this.label,
    this.prefixIcon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.cardBorder, width: 1.5),
      ),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }
}

class _SubEntityTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubEntityTile({
    required this.title,
    this.subtitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 16, right: 4),
              title: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              subtitle: subtitle != null
                  ? Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_rounded, size: 20, color: cs.primary),
                    onPressed: onEdit,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, size: 20, color: cs.error),
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
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

class _AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded, size: 16),
      label: const Text('Add'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(80, 32),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        side: BorderSide(color: colors.cardBorder, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
    );
  }
}

class _AllergyDialog extends StatefulWidget {
  final Allergy? existing;
  const _AllergyDialog({this.existing});

  @override
  State<_AllergyDialog> createState() => _AllergyDialogState();
}

class _AllergyDialogState extends State<_AllergyDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _reactionCtrl;
  late AllergySeverity _severity;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _reactionCtrl = TextEditingController(text: widget.existing?.reaction ?? '');
    _severity = widget.existing?.severity ?? AllergySeverity.mild;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _reactionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.glassSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.cardBorder, width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existing == null ? 'Add Allergy' : 'Edit Allergy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Allergen *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<AllergySeverity>(
                  initialValue: _severity,
                  decoration: const InputDecoration(labelText: 'Severity'),
                  items: AllergySeverity.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (s) => setState(() => _severity = s ?? _severity),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reactionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Reaction (optional)',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    AppButton.primary(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        Navigator.pop(
                          context,
                          Allergy(
                            id: widget.existing?.id ?? _uuid.v4(),
                            name: _nameCtrl.text.trim(),
                            severity: _severity,
                            reaction: _reactionCtrl.text.trim().isEmpty
                                ? null
                                : _reactionCtrl.text.trim(),
                          ),
                        );
                      },
                      label: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicationDialog extends StatefulWidget {
  final Medication? existing;
  const _MedicationDialog({this.existing});

  @override
  State<_MedicationDialog> createState() => _MedicationDialogState();
}

class _MedicationDialogState extends State<_MedicationDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dosageCtrl;
  late final TextEditingController _freqCtrl;
  late final TextEditingController _forCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _dosageCtrl = TextEditingController(text: widget.existing?.dosage ?? '');
    _freqCtrl = TextEditingController(text: widget.existing?.frequency ?? '');
    _forCtrl =
        TextEditingController(text: widget.existing?.prescribedFor ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _freqCtrl.dispose();
    _forCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.glassSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.cardBorder, width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existing == null ? 'Add Medication' : 'Edit Medication',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Medication Name *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dosageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    hintText: 'e.g. 500mg',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _freqCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    hintText: 'e.g. 2x daily',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _forCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Prescribed For',
                    hintText: 'e.g. Hypertension',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    AppButton.primary(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        Navigator.pop(
                          context,
                          Medication(
                            id: widget.existing?.id ?? _uuid.v4(),
                            name: _nameCtrl.text.trim(),
                            dosage: _dosageCtrl.text.trim().isEmpty
                                ? null
                                : _dosageCtrl.text.trim(),
                            frequency: _freqCtrl.text.trim().isEmpty
                                ? null
                                : _freqCtrl.text.trim(),
                            prescribedFor: _forCtrl.text.trim().isEmpty
                                ? null
                                : _forCtrl.text.trim(),
                          ),
                        );
                      },
                      label: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionDialog extends StatefulWidget {
  final MedicalCondition? existing;
  const _ConditionDialog({this.existing});

  @override
  State<_ConditionDialog> createState() => _ConditionDialogState();
}

class _ConditionDialogState extends State<_ConditionDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _notesCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _dateCtrl =
        TextEditingController(text: widget.existing?.diagnosedDate ?? '');
    _notesCtrl = TextEditingController(text: widget.existing?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.glassSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.cardBorder, width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existing == null ? 'Add Condition' : 'Edit Condition',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Condition Name *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Diagnosed Date',
                    hintText: 'e.g. 2020 or Jan 2020',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    AppButton.primary(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        Navigator.pop(
                          context,
                          MedicalCondition(
                            id: widget.existing?.id ?? _uuid.v4(),
                            name: _nameCtrl.text.trim(),
                            diagnosedDate: _dateCtrl.text.trim().isEmpty
                                ? null
                                : _dateCtrl.text.trim(),
                            notes: _notesCtrl.text.trim().isEmpty
                                ? null
                                : _notesCtrl.text.trim(),
                          ),
                        );
                      },
                      label: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactDialog extends StatefulWidget {
  final EmergencyContact? existing;
  final int nextPriority;
  const _ContactDialog({this.existing, this.nextPriority = 1});

  @override
  State<_ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<_ContactDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _relCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.existing?.phone ?? '');
    _relCtrl = TextEditingController(text: widget.existing?.relationship ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _relCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.glassSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.cardBorder, width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existing == null ? 'Add Emergency Contact' : 'Edit Contact',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone *'),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _relCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Relationship',
                    hintText: 'e.g. Spouse, Parent',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    AppButton.primary(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        Navigator.pop(
                          context,
                          EmergencyContact(
                            id: widget.existing?.id ?? _uuid.v4(),
                            name: _nameCtrl.text.trim(),
                            phone: _phoneCtrl.text.trim(),
                            relationship: _relCtrl.text.trim().isEmpty
                                ? null
                                : _relCtrl.text.trim(),
                            priority: widget.existing?.priority ?? widget.nextPriority,
                          ),
                        );
                      },
                      label: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
