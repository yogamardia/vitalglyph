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
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Profile' : 'New Profile'),
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
            else
              TextButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildBasicInfoCard(),
              const SizedBox(height: 16),
              _buildSubEntityCard<Allergy>(
                title: 'Allergies',
                icon: Icons.warning_amber_rounded,
                items: _allergies,
                itemBuilder: _allergyTile,
                onAdd: () async {
                  final result = await _showAllergyDialog();
                  if (result != null) setState(() => _allergies.add(result));
                },
              ),
              const SizedBox(height: 16),
              _buildSubEntityCard<Medication>(
                title: 'Medications',
                icon: Icons.medication_outlined,
                items: _medications,
                itemBuilder: _medicationTile,
                onAdd: () async {
                  final result = await _showMedicationDialog();
                  if (result != null) setState(() => _medications.add(result));
                },
              ),
              const SizedBox(height: 16),
              _buildSubEntityCard<MedicalCondition>(
                title: 'Medical Conditions',
                icon: Icons.monitor_heart_outlined,
                items: _conditions,
                itemBuilder: _conditionTile,
                onAdd: () async {
                  final result = await _showConditionDialog();
                  if (result != null) setState(() => _conditions.add(result));
                },
              ),
              const SizedBox(height: 16),
              _buildSubEntityCard<EmergencyContact>(
                title: 'Emergency Contacts',
                icon: Icons.contact_phone_outlined,
                items: _contacts,
                itemBuilder: _contactTile,
                onAdd: () async {
                  final result = await _showContactDialog();
                  if (result != null) setState(() => _contacts.add(result));
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dobCtrl,
              decoration: const InputDecoration(
                labelText: 'Date of Birth *',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                hintText: 'Tap to select',
              ),
              readOnly: true,
              onTap: _pickDateOfBirth,
              validator: (_) =>
                  _dateOfBirth == null ? 'Date of birth is required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BloodType?>(
              initialValue: _bloodType,
              decoration: const InputDecoration(
                labelText: 'Blood Type',
                prefixIcon: Icon(Icons.water_drop_outlined),
              ),
              items: [
                const DropdownMenuItem<BloodType?>(
                  value: null,
                  child: Text('Unknown'),
                ),
                ...BloodType.values.map(
                  (b) => DropdownMenuItem<BloodType?>(
                    value: b,
                    child: Text(b.displayName),
                  ),
                ),
              ],
              onChanged: (b) => _bloodType = b,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BiologicalSex?>(
              initialValue: _biologicalSex,
              decoration: const InputDecoration(
                labelText: 'Biological Sex',
                prefixIcon: Icon(Icons.people_outline),
              ),
              items: [
                const DropdownMenuItem<BiologicalSex?>(
                  value: null,
                  child: Text('Prefer not to say'),
                ),
                ...BiologicalSex.values.map(
                  (s) => DropdownMenuItem<BiologicalSex?>(
                    value: s,
                    child: Text(s.displayName),
                  ),
                ),
              ],
              onChanged: (s) => _biologicalSex = s,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _heightCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      prefixIcon: Icon(Icons.height),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (v) {
                      if (v != null && v.isNotEmpty) {
                        final d = int.tryParse(v);
                        if (d == null || d < 1 || d > 300) return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _weightCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (v) {
                      if (v != null && v.isNotEmpty) {
                        final d = double.tryParse(v);
                        if (d == null || d < 1 || d > 500) return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              value: _isOrganDonor,
              onChanged: (v) => setState(() => _isOrganDonor = v),
              title: const Text('Organ Donor'),
              secondary: const Icon(Icons.favorite_border),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _langCtrl,
              decoration: const InputDecoration(
                labelText: 'Primary Language',
                prefixIcon: Icon(Icons.language),
                hintText: 'e.g. English',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Medical Notes',
                prefixIcon: Icon(Icons.notes),
                hintText: 'Physician notes, special instructions...',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubEntityCard<T>({
    required String title,
    required IconData icon,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required VoidCallback onAdd,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'None added',
                  style: TextStyle(color: theme.hintColor),
                ),
              )
            else
              ...items.map(itemBuilder),
          ],
        ),
      ),
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

  Future<Allergy?> _showAllergyDialog([Allergy? existing]) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final reactionCtrl = TextEditingController(text: existing?.reaction ?? '');
    var severity = existing?.severity ?? AllergySeverity.mild;
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Allergy>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Allergy' : 'Edit Allergy'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Allergen *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AllergySeverity>(
                  initialValue: severity,
                  decoration: const InputDecoration(labelText: 'Severity'),
                  items: AllergySeverity.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (s) => severity = s ?? severity,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: reactionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Reaction (optional)',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(
                  ctx,
                  Allergy(
                    id: existing?.id ?? _uuid.v4(),
                    name: nameCtrl.text.trim(),
                    severity: severity,
                    reaction: reactionCtrl.text.trim().isEmpty
                        ? null
                        : reactionCtrl.text.trim(),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    nameCtrl.dispose();
    reactionCtrl.dispose();
    return result;
  }

  Future<Medication?> _showMedicationDialog([Medication? existing]) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final dosageCtrl = TextEditingController(text: existing?.dosage ?? '');
    final freqCtrl = TextEditingController(text: existing?.frequency ?? '');
    final forCtrl = TextEditingController(text: existing?.prescribedFor ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Medication>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add Medication' : 'Edit Medication'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Medication Name *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: dosageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    hintText: 'e.g. 500mg',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: freqCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    hintText: 'e.g. 2x daily',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: forCtrl,
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(
                ctx,
                Medication(
                  id: existing?.id ?? _uuid.v4(),
                  name: nameCtrl.text.trim(),
                  dosage: dosageCtrl.text.trim().isEmpty
                      ? null
                      : dosageCtrl.text.trim(),
                  frequency:
                      freqCtrl.text.trim().isEmpty ? null : freqCtrl.text.trim(),
                  prescribedFor:
                      forCtrl.text.trim().isEmpty ? null : forCtrl.text.trim(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameCtrl.dispose();
    dosageCtrl.dispose();
    freqCtrl.dispose();
    forCtrl.dispose();
    return result;
  }

  Future<MedicalCondition?> _showConditionDialog([
    MedicalCondition? existing,
  ]) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final dateCtrl =
        TextEditingController(text: existing?.diagnosedDate ?? '');
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<MedicalCondition>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add Condition' : 'Edit Condition'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Condition Name *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: dateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Diagnosed Date',
                    hintText: 'e.g. 2020 or Jan 2020',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesCtrl,
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(
                ctx,
                MedicalCondition(
                  id: existing?.id ?? _uuid.v4(),
                  name: nameCtrl.text.trim(),
                  diagnosedDate: dateCtrl.text.trim().isEmpty
                      ? null
                      : dateCtrl.text.trim(),
                  notes: notesCtrl.text.trim().isEmpty
                      ? null
                      : notesCtrl.text.trim(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameCtrl.dispose();
    dateCtrl.dispose();
    notesCtrl.dispose();
    return result;
  }

  Future<EmergencyContact?> _showContactDialog([
    EmergencyContact? existing,
  ]) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final relCtrl = TextEditingController(text: existing?.relationship ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<EmergencyContact>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          existing == null ? 'Add Emergency Contact' : 'Edit Contact',
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name *'),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone *'),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: relCtrl,
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(
                ctx,
                EmergencyContact(
                  id: existing?.id ?? _uuid.v4(),
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  relationship: relCtrl.text.trim().isEmpty
                      ? null
                      : relCtrl.text.trim(),
                  priority: existing?.priority ?? (_contacts.length + 1),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameCtrl.dispose();
    phoneCtrl.dispose();
    relCtrl.dispose();
    return result;
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: SizedBox(
        width: 80,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              iconSize: 20,
              onPressed: onEdit,
              tooltip: 'Edit',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              iconSize: 20,
              onPressed: onDelete,
              tooltip: 'Remove',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ],
        ),
      ),
    );
  }
}
