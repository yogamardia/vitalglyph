// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Medical ID';

  @override
  String get brandName => 'VITALGLYPH';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Retry';

  @override
  String get add => 'Add';

  @override
  String get required => 'Required';

  @override
  String get homeScan => 'Scan';

  @override
  String get homeNewProfile => 'New Profile';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeEmptyTitle => 'Create Your First Profile';

  @override
  String get homeEmptyDescription =>
      'Store blood type, allergies, medications, and emergency contacts so first responders can help you faster.';

  @override
  String get homeAddProfile => 'Add Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLoadError => 'Failed to load settings. Tap to retry.';

  @override
  String get settingsPinUpdated => 'PIN updated.';

  @override
  String get settingsRemovePinTitle => 'Remove PIN?';

  @override
  String get settingsRemovePinMessage =>
      'This will disable app lock. You can set a new PIN at any time.';

  @override
  String get settingsRemovePinAction => 'Remove';

  @override
  String get settingsLockAfterTitle => 'Lock After';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsAppLock => 'App Lock';

  @override
  String get settingsAppLockEnabled => 'App is locked when you leave';

  @override
  String get settingsAppLockDisabled => 'Anyone can open the app';

  @override
  String get settingsLockAfter => 'Lock after';

  @override
  String get settingsChangePin => 'Change PIN';

  @override
  String get settingsSetPin => 'Set PIN';

  @override
  String get settingsRemovePin => 'Remove PIN';

  @override
  String get settingsUseBiometrics => 'Use Biometrics';

  @override
  String get settingsBiometricsDescription => 'Face ID / fingerprint unlock';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsBackupRestore => 'Backup & Restore';

  @override
  String get settingsBackupRestoreDescription =>
      'Export or import an encrypted .medid file';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPrivacyDescription => 'No data ever leaves your device.';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get lockScreenTitle => 'Medical ID Locked';

  @override
  String get lockScreenEnterPin => 'Enter your PIN to continue';

  @override
  String get lockScreenUseBiometrics => 'Use biometrics to unlock';

  @override
  String lockScreenTooManyAttempts(String duration) {
    return 'Too many attempts. Try again in $duration';
  }

  @override
  String get pinSetupTitle => 'Security Setup';

  @override
  String get pinSetupCreate => 'Create a PIN';

  @override
  String get pinSetupConfirm => 'Confirm your PIN';

  @override
  String pinSetupCreateMessage(int length) {
    return 'Choose a $length-digit PIN to secure your medical information.';
  }

  @override
  String pinSetupConfirmMessage(int length) {
    return 'Re-enter your $length-digit PIN to confirm it matches.';
  }

  @override
  String pinSetupLengthError(int length) {
    return 'PIN must be $length digits.';
  }

  @override
  String get pinSetupMismatch => 'PINs do not match. Start over.';

  @override
  String get pinSetupEnter => 'Enter PIN';

  @override
  String get pinSetupReenter => 'Re-enter PIN';

  @override
  String get pinSetupPlaceholder => '••••••';

  @override
  String get pinSetupConfirmSave => 'Confirm & Save';

  @override
  String get pinSetupContinue => 'Continue';

  @override
  String get backupTitle => 'Backup & Restore';

  @override
  String get backupSelectFileWarning => 'Please select a .medid backup file.';

  @override
  String get backupFileAccessError => 'Could not access the selected file.';

  @override
  String get backupImportTitle => 'Import backup?';

  @override
  String get backupImportMessage =>
      'This will add profiles from the backup. Existing profiles with the same ID will be skipped.';

  @override
  String get backupImportAction => 'Import';

  @override
  String get backupShareSuccess => 'Backup shared successfully.';

  @override
  String get backupImportEmpty => 'No profiles found in backup.';

  @override
  String backupImportResult(int imported) {
    return '$imported profile(s) imported.';
  }

  @override
  String backupImportResultWithSkipped(int imported, int skipped) {
    return '$imported profile(s) imported, $skipped already existed (skipped).';
  }

  @override
  String get backupExportSection => 'Export';

  @override
  String get backupExportInfo =>
      'Creates an encrypted .medid file containing all your profiles. You can save it to Files, AirDrop it, or share it anywhere.';

  @override
  String get backupPassphrase => 'Backup passphrase';

  @override
  String get backupPassphraseRequired =>
      'Enter a passphrase to protect the backup.';

  @override
  String get backupPassphraseMinLength =>
      'Passphrase must be at least 6 characters.';

  @override
  String get backupConfirmPassphrase => 'Confirm passphrase';

  @override
  String get backupPassphraseMismatch => 'Passphrases do not match.';

  @override
  String get backupExportAction => 'Export Backup';

  @override
  String get backupRestoreSection => 'Restore';

  @override
  String get backupRestoreInfo =>
      'Select a .medid backup file and enter its passphrase. Profiles that already exist on this device will be skipped.';

  @override
  String get backupRestorePassphraseRequired =>
      'Enter the passphrase for this backup.';

  @override
  String get backupImportBackupAction => 'Import Backup';

  @override
  String get backupPickFile => 'Pick backup file (.medid)';

  @override
  String get onboardingTitle1 => 'Your Medical ID, Always Ready';

  @override
  String get onboardingBody1 =>
      'Store critical medical information — blood type, allergies, medications, and emergency contacts — in one secure place.';

  @override
  String get onboardingTitle2 => 'Instant Access via QR Code';

  @override
  String get onboardingBody2 =>
      'First responders can scan your QR code to access your medical information in seconds, even without internet.';

  @override
  String get onboardingTitle3 => 'Private & Offline by Design';

  @override
  String get onboardingBody3 =>
      'All data stays on your device. Nothing is sent to servers. You control who sees your information.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingNext => 'Next';

  @override
  String get profileEditorTitleEdit => 'Edit Profile';

  @override
  String get profileEditorTitleNew => 'New Profile';

  @override
  String get profileEditorUpdateProfile => 'Update Profile';

  @override
  String get profileEditorSaveProfile => 'Save Profile';

  @override
  String get profileEditorPhotoTitle => 'Profile Photo';

  @override
  String get profileEditorTakePhoto => 'Take Photo';

  @override
  String get profileEditorChooseGallery => 'Choose from Gallery';

  @override
  String get profileEditorRemovePhoto => 'Remove Photo';

  @override
  String get profileEditorPhotoError => 'Could not load photo';

  @override
  String get profileEditorDobRequired => 'Please select a date of birth';

  @override
  String get profileEditorBasicInfo => 'Basic Information';

  @override
  String get profileEditorFullName => 'Full Name';

  @override
  String get profileEditorNameRequired => 'Name is required';

  @override
  String get profileEditorDob => 'Date of Birth';

  @override
  String get profileEditorDobValidation => 'Date of birth is required';

  @override
  String get profileEditorBloodType => 'Blood Type';

  @override
  String get profileEditorBloodTypeUnknown => 'Unknown';

  @override
  String get profileEditorSex => 'Sex';

  @override
  String get profileEditorSexNotSet => 'Not set';

  @override
  String get profileEditorHeight => 'Height (cm)';

  @override
  String get profileEditorWeight => 'Weight (kg)';

  @override
  String get profileEditorOrganDonor => 'Organ Donor';

  @override
  String get profileEditorPrimaryLanguage => 'Primary Language';

  @override
  String get profileEditorMedicalDetails => 'Medical Details';

  @override
  String get profileEditorAllergies => 'Allergies';

  @override
  String get profileEditorMedications => 'Medications';

  @override
  String get profileEditorMedicalConditions => 'Medical Conditions';

  @override
  String get profileEditorMedicalNotes => 'Medical Notes';

  @override
  String get profileEditorEmergencyContacts => 'Emergency Contacts';

  @override
  String get profileEditorContacts => 'Contacts';

  @override
  String profileEditorNoItemsYet(String items) {
    return 'No $items added yet.';
  }

  @override
  String get profileEditorAddAllergy => 'Add Allergy';

  @override
  String get profileEditorEditAllergy => 'Edit Allergy';

  @override
  String get profileEditorAllergen => 'Allergen *';

  @override
  String get profileEditorSeverity => 'Severity';

  @override
  String get profileEditorReaction => 'Reaction (optional)';

  @override
  String get profileEditorAddMedication => 'Add Medication';

  @override
  String get profileEditorEditMedication => 'Edit Medication';

  @override
  String get profileEditorMedicationName => 'Medication Name *';

  @override
  String get profileEditorDosage => 'Dosage';

  @override
  String get profileEditorDosageHint => 'e.g. 500mg';

  @override
  String get profileEditorFrequency => 'Frequency';

  @override
  String get profileEditorFrequencyHint => 'e.g. 2x daily';

  @override
  String get profileEditorPrescribedFor => 'Prescribed For';

  @override
  String get profileEditorPrescribedForHint => 'e.g. Hypertension';

  @override
  String get profileEditorAddCondition => 'Add Condition';

  @override
  String get profileEditorEditCondition => 'Edit Condition';

  @override
  String get profileEditorConditionName => 'Condition Name *';

  @override
  String get profileEditorDiagnosedDate => 'Diagnosed Date';

  @override
  String get profileEditorDiagnosedDateHint => 'e.g. 2020 or Jan 2020';

  @override
  String get profileEditorNotes => 'Notes';

  @override
  String get profileEditorAddContact => 'Add Emergency Contact';

  @override
  String get profileEditorEditContact => 'Edit Contact';

  @override
  String get profileEditorContactName => 'Name *';

  @override
  String get profileEditorContactPhone => 'Phone *';

  @override
  String get profileEditorRelationship => 'Relationship';

  @override
  String get profileEditorRelationshipHint => 'e.g. Spouse, Parent';

  @override
  String emergencyCardTitle(String name) {
    return '$name — Emergency Card';
  }

  @override
  String get emergencyCardGenerating => 'Generating Emergency Card…';

  @override
  String get emergencyCardFailed => 'Failed to generate card';

  @override
  String get emergencyCardTryAgain => 'Try Again';

  @override
  String get qrDisplayEmergencyLabel => 'EMERGENCY MEDICAL ID';

  @override
  String qrDisplaySemanticLabel(String name) {
    return 'QR code with medical info for $name';
  }

  @override
  String qrDisplayBloodType(String type) {
    return 'Type $type';
  }

  @override
  String qrDisplayAllergyCount(int count) {
    return '$count Allergies';
  }

  @override
  String get qrDisplayTruncated =>
      'Some details were omitted to fit QR capacity';

  @override
  String get qrScannerTitle => 'Scan Medical ID';

  @override
  String get qrScannerNotMedicalId => 'This QR code is not a Medical ID.';

  @override
  String get qrScannerInstruction => 'Point at a Medical ID QR code';

  @override
  String get qrScannerProcessing => 'Processing ID...';

  @override
  String get scannedProfileTitle => 'Medical ID Result';

  @override
  String get scannedProfileAllergies => 'ALLERGIES';

  @override
  String get scannedProfileMedications => 'MEDICATIONS';

  @override
  String get scannedProfileConditions => 'MEDICAL CONDITIONS';

  @override
  String get scannedProfileContacts => 'EMERGENCY CONTACTS';

  @override
  String get scannedProfileTamperTitle =>
      'FORMAT CHECK FAILED — VERIFY DATA WITH PATIENT';

  @override
  String get scannedProfileTamperMessage =>
      'This QR may have been altered or generated by another app. Confirm all details directly.';

  @override
  String get scannedProfileBorn => 'Born';

  @override
  String get scannedProfileBloodType => 'Blood Type';

  @override
  String get scannedProfileSex => 'Sex';

  @override
  String get scannedProfileHeight => 'Height';

  @override
  String get scannedProfileWeight => 'Weight';

  @override
  String get scannedProfileOrganDonor => 'Organ Donor';

  @override
  String get scannedProfileYes => 'YES';

  @override
  String get scannedProfileNo => 'NO';

  @override
  String get profileCardEditProfile => 'Edit Profile';

  @override
  String get profileCardEmergencyCard => 'Emergency Card';

  @override
  String get profileCardDeleteProfile => 'Delete Profile';

  @override
  String get profileCardDeleteTitle => 'Delete profile?';

  @override
  String profileCardDeleteMessage(String name) {
    return 'This will permanently delete $name\'s medical profile.';
  }

  @override
  String get profileCardPrimary => 'Primary';

  @override
  String get profileCardSecondary => 'Secondary';

  @override
  String get profileCardCriticalAllergies => 'Critical Allergies';

  @override
  String get profileCardViewQr => 'View Emergency QR';

  @override
  String get profileCardEncrypted => 'Database Encrypted';

  @override
  String profileCardUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String get profileCardToday => 'today';

  @override
  String get profileCardYesterday => 'yesterday';

  @override
  String get dialogConfirm => 'Confirm';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogDelete => 'Delete';

  @override
  String get allergySeverityMild => 'Mild';

  @override
  String get allergySeverityModerate => 'Moderate';

  @override
  String get allergySeveritySevere => 'Severe';

  @override
  String get allergySeverityLifeThreatening => 'Life-Threatening';

  @override
  String get lockTimeoutImmediately => 'Immediately';

  @override
  String get lockTimeoutAfter1Min => 'After 1 minute';

  @override
  String get lockTimeoutAfter5Min => 'After 5 minutes';

  @override
  String get lockTimeoutNever => 'Never';

  @override
  String get biologicalSexMale => 'Male';

  @override
  String get biologicalSexFemale => 'Female';

  @override
  String get biologicalSexOther => 'Other';

  @override
  String get pdfMedicalId => '⚕  MEDICAL ID';

  @override
  String pdfTitle(String name) {
    return 'Emergency Medical Card — $name';
  }

  @override
  String pdfDobBlood(String dob, String bloodType) {
    return 'DOB: $dob   Blood: $bloodType';
  }

  @override
  String pdfSexDonor(String sex, String donor) {
    return 'Sex: $sex   Organ Donor: $donor';
  }

  @override
  String pdfDonorOnly(String donor) {
    return 'Organ Donor: $donor';
  }

  @override
  String get pdfAllergies => '⚠  ALLERGIES';

  @override
  String get pdfNoAllergies => 'No known allergies';

  @override
  String get pdfConditions => 'CONDITIONS';

  @override
  String get pdfMedications => 'MEDICATIONS';

  @override
  String get pdfEmergencyContacts => 'EMERGENCY CONTACTS';

  @override
  String get pdfNotes => 'NOTES';

  @override
  String get pdfNoAdditionalInfo => 'No additional medical information.';

  @override
  String get pdfYes => 'YES';

  @override
  String get pdfNo => 'NO';

  @override
  String a11yPinDigit(String digit) {
    return 'Digit $digit';
  }

  @override
  String get a11yPinDelete => 'Delete last digit';

  @override
  String get a11yPinBiometric => 'Authenticate with biometrics';

  @override
  String a11yPinDotsEntered(int entered, int total) {
    return '$entered of $total digits entered';
  }

  @override
  String get a11yCloseQrDisplay => 'Close QR display';

  @override
  String get a11yToggleTorch => 'Toggle flashlight';

  @override
  String get a11yMoreActions => 'More actions';

  @override
  String a11yEditItem(String item) {
    return 'Edit $item';
  }

  @override
  String a11yDeleteItem(String item) {
    return 'Delete $item';
  }

  @override
  String get a11yProfilePhoto => 'Change profile photo';

  @override
  String a11yAllergyWithSeverity(String name, String severity) {
    return 'Allergy: $name, severity: $severity';
  }

  @override
  String get a11yTogglePasswordVisibility => 'Toggle password visibility';

  @override
  String a11ySelectedOption(String label) {
    return '$label, selected';
  }

  @override
  String get a11yLoadingButton => 'Loading';

  @override
  String get a11yProcessingQr => 'Processing scanned QR code';

  @override
  String a11yStepIndicator(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get disclaimerShort =>
      'This app is not a substitute for professional medical advice.';

  @override
  String get settingsMedicalDisclaimer => 'Medical Disclaimer';

  @override
  String get disclaimerTitle => 'Medical Disclaimer';

  @override
  String get disclaimerBody =>
      'VitalGlyph is designed to store and display medical information for emergency reference only.\n\nThis app is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.\n\nIn an emergency, always call your local emergency services. Do not rely solely on this app for critical medical decisions.\n\nThe developers of this app assume no liability for any actions taken based on the information stored or displayed.';
}
