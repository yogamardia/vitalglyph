import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool _isSaving = false;

  bool get _isEditing => widget.profile != null;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date of birth')),
      );
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
      photoPath: existing?.photoPath,
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
    final colorScheme = theme.colorScheme;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (!_isSaving) return;
        if (state is ProfileLoaded) {
          context.pop();
        } else if (state is ProfileError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
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
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _isSaving ? null : _save,
          label: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(_isEditing ? 'Update Profile' : 'Save Profile'),
          icon: _isSaving ? null : const Icon(Icons.check),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return SliverAppBar(
      expandedHeight: 280,
      floating: true,
      pinned: true,
      stretch: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: const BackButton(),
      actions: [
        if (_isSaving)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        centerTitle: true,
        title: Text(
          _isEditing ? 'Edit Profile' : 'New Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
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
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.surface,
                  ],
                ),
              ),
            ),
            Center(
              child: Hero(
                tag: 'profile_image_${widget.profile?.id ?? 'new'}',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: widget.profile?.photoPath != null
                        ? FileImage(File(widget.profile!.photoPath!))
                        : null,
                    child: widget.profile?.photoPath == null
                        ? Icon(
                            Icons.person_add_rounded,
                            size: 48,
                            color: colorScheme.onPrimaryContainer,
                          )
                        : null,
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
    return _SectionCard(
      title: 'Basic Information',
      icon: Icons.person_outline_rounded,
      children: [
        _CustomTextField(
          controller: _nameCtrl,
          label: 'Full Name',
          prefixIcon: Icons.badge_outlined,
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
                prefixIcon: Icons.water_drop_outlined,
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
                prefixIcon: Icons.people_outline_rounded,
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
                prefixIcon: Icons.monitor_weight_outlined,
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
        SwitchListTile(
          value: _isOrganDonor,
          onChanged: (v) => setState(() => _isOrganDonor = v),
          title: Text(
            'Organ Donor',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          secondary: Icon(
            _isOrganDonor ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _isOrganDonor ? Theme.of(context).colorScheme.error : null,
          ),
          contentPadding: EdgeInsets.zero,
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
    return _SectionCard(
      title: 'Medical Details',
      icon: Icons.health_and_safety_outlined,
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
        const Divider(height: 32),
        _buildSubEntitySection<Medication>(
          title: 'Medications',
          items: _medications,
          itemBuilder: _medicationTile,
          onAdd: () async {
            final result = await _showMedicationDialog();
            if (result != null) setState(() => _medications.add(result));
          },
        ),
        const Divider(height: 32),
        _buildSubEntitySection<MedicalCondition>(
          title: 'Conditions',
          items: _conditions,
          itemBuilder: _conditionTile,
          onAdd: () async {
            final result = await _showConditionDialog();
            if (result != null) setState(() => _conditions.add(result));
          },
        ),
        const Divider(height: 32),
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
    return _SectionCard(
      title: 'Emergency Contacts',
      icon: Icons.contact_emergency_outlined,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            IconButton.filledTonal(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 20),
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'No ${title.toLowerCase()} added',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(top: 8),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Icon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
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
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isFocused ? colorScheme.surface : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
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
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          label: widget.isRequired
              ? RichText(
                  text: TextSpan(
                    text: widget.label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ],
                  ),
                )
              : null,
          labelText: widget.isRequired ? null : widget.label,
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
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
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: InputBorder.none,
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
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
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
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Allergy' : 'Edit Allergy'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Allergen *'),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<AllergySeverity>(
                value: _severity,
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _reactionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Reaction (optional)',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
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
          child: const Text('Save'),
        ),
      ],
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
    return AlertDialog(
      title:
          Text(widget.existing == null ? 'Add Medication' : 'Edit Medication'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Medication Name *'),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dosageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  hintText: 'e.g. 500mg',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _freqCtrl,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  hintText: 'e.g. 2x daily',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _forCtrl,
                decoration: const InputDecoration(
                  labelText: 'Prescribed For',
                  hintText: 'e.g. Hypertension',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
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
                frequency:
                    _freqCtrl.text.trim().isEmpty ? null : _freqCtrl.text.trim(),
                prescribedFor:
                    _forCtrl.text.trim().isEmpty ? null : _forCtrl.text.trim(),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
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
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Condition' : 'Edit Condition'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Condition Name *'),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateCtrl,
                decoration: const InputDecoration(
                  labelText: 'Diagnosed Date',
                  hintText: 'e.g. 2020 or Jan 2020',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
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
          child: const Text('Save'),
        ),
      ],
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
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Add Emergency Contact' : 'Edit Contact',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name *'),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone *'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _relCtrl,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  hintText: 'e.g. Spouse, Parent',
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
