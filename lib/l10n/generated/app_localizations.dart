import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical ID'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'VITALGLYPH'**
  String get brandName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @homeScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get homeScan;

  /// No description provided for @homeNewProfile.
  ///
  /// In en, this message translates to:
  /// **'New Profile'**
  String get homeNewProfile;

  /// No description provided for @homeSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettings;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your First Profile'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Store blood type, allergies, medications, and emergency contacts so first responders can help you faster.'**
  String get homeEmptyDescription;

  /// No description provided for @homeAddProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get homeAddProfile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings. Tap to retry.'**
  String get settingsLoadError;

  /// No description provided for @settingsPinUpdated.
  ///
  /// In en, this message translates to:
  /// **'PIN updated.'**
  String get settingsPinUpdated;

  /// No description provided for @settingsRemovePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN?'**
  String get settingsRemovePinTitle;

  /// No description provided for @settingsRemovePinMessage.
  ///
  /// In en, this message translates to:
  /// **'This will disable app lock. You can set a new PIN at any time.'**
  String get settingsRemovePinMessage;

  /// No description provided for @settingsRemovePinAction.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get settingsRemovePinAction;

  /// No description provided for @settingsLockAfterTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock After'**
  String get settingsLockAfterTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsAppLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get settingsAppLock;

  /// No description provided for @settingsAppLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'App is locked when you leave'**
  String get settingsAppLockEnabled;

  /// No description provided for @settingsAppLockDisabled.
  ///
  /// In en, this message translates to:
  /// **'Anyone can open the app'**
  String get settingsAppLockDisabled;

  /// No description provided for @settingsLockAfter.
  ///
  /// In en, this message translates to:
  /// **'Lock after'**
  String get settingsLockAfter;

  /// No description provided for @settingsChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settingsChangePin;

  /// No description provided for @settingsSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get settingsSetPin;

  /// No description provided for @settingsRemovePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get settingsRemovePin;

  /// No description provided for @settingsUseBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use Biometrics'**
  String get settingsUseBiometrics;

  /// No description provided for @settingsBiometricsDescription.
  ///
  /// In en, this message translates to:
  /// **'Face ID / fingerprint unlock'**
  String get settingsBiometricsDescription;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsBackupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackupRestore;

  /// No description provided for @settingsBackupRestoreDescription.
  ///
  /// In en, this message translates to:
  /// **'Export or import an encrypted .medid file'**
  String get settingsBackupRestoreDescription;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'No data ever leaves your device.'**
  String get settingsPrivacyDescription;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @lockScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical ID Locked'**
  String get lockScreenTitle;

  /// No description provided for @lockScreenEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to continue'**
  String get lockScreenEnterPin;

  /// No description provided for @lockScreenUseBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics to unlock'**
  String get lockScreenUseBiometrics;

  /// No description provided for @lockScreenTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {duration}'**
  String lockScreenTooManyAttempts(String duration);

  /// No description provided for @pinSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Setup'**
  String get pinSetupTitle;

  /// No description provided for @pinSetupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create a PIN'**
  String get pinSetupCreate;

  /// No description provided for @pinSetupConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get pinSetupConfirm;

  /// No description provided for @pinSetupCreateMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a {length}-digit PIN to secure your medical information.'**
  String pinSetupCreateMessage(int length);

  /// No description provided for @pinSetupConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your {length}-digit PIN to confirm it matches.'**
  String pinSetupConfirmMessage(int length);

  /// No description provided for @pinSetupLengthError.
  ///
  /// In en, this message translates to:
  /// **'PIN must be {length} digits.'**
  String pinSetupLengthError(int length);

  /// No description provided for @pinSetupMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Start over.'**
  String get pinSetupMismatch;

  /// No description provided for @pinSetupEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get pinSetupEnter;

  /// No description provided for @pinSetupReenter.
  ///
  /// In en, this message translates to:
  /// **'Re-enter PIN'**
  String get pinSetupReenter;

  /// No description provided for @pinSetupPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'••••••'**
  String get pinSetupPlaceholder;

  /// No description provided for @pinSetupConfirmSave.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Save'**
  String get pinSetupConfirmSave;

  /// No description provided for @pinSetupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get pinSetupContinue;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupTitle;

  /// No description provided for @backupSelectFileWarning.
  ///
  /// In en, this message translates to:
  /// **'Please select a .medid backup file.'**
  String get backupSelectFileWarning;

  /// No description provided for @backupFileAccessError.
  ///
  /// In en, this message translates to:
  /// **'Could not access the selected file.'**
  String get backupFileAccessError;

  /// No description provided for @backupImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import backup?'**
  String get backupImportTitle;

  /// No description provided for @backupImportMessage.
  ///
  /// In en, this message translates to:
  /// **'This will add profiles from the backup. Existing profiles with the same ID will be skipped.'**
  String get backupImportMessage;

  /// No description provided for @backupImportAction.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get backupImportAction;

  /// No description provided for @backupShareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup shared successfully.'**
  String get backupShareSuccess;

  /// No description provided for @backupImportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No profiles found in backup.'**
  String get backupImportEmpty;

  /// No description provided for @backupImportResult.
  ///
  /// In en, this message translates to:
  /// **'{imported} profile(s) imported.'**
  String backupImportResult(int imported);

  /// No description provided for @backupImportResultWithSkipped.
  ///
  /// In en, this message translates to:
  /// **'{imported} profile(s) imported, {skipped} already existed (skipped).'**
  String backupImportResultWithSkipped(int imported, int skipped);

  /// No description provided for @backupExportSection.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get backupExportSection;

  /// No description provided for @backupExportInfo.
  ///
  /// In en, this message translates to:
  /// **'Creates an encrypted .medid file containing all your profiles. You can save it to Files, AirDrop it, or share it anywhere.'**
  String get backupExportInfo;

  /// No description provided for @backupPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Backup passphrase'**
  String get backupPassphrase;

  /// No description provided for @backupPassphraseRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a passphrase to protect the backup.'**
  String get backupPassphraseRequired;

  /// No description provided for @backupPassphraseMinLength.
  ///
  /// In en, this message translates to:
  /// **'Passphrase must be at least 6 characters.'**
  String get backupPassphraseMinLength;

  /// No description provided for @backupConfirmPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Confirm passphrase'**
  String get backupConfirmPassphrase;

  /// No description provided for @backupPassphraseMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passphrases do not match.'**
  String get backupPassphraseMismatch;

  /// No description provided for @backupExportAction.
  ///
  /// In en, this message translates to:
  /// **'Export Backup'**
  String get backupExportAction;

  /// No description provided for @backupRestoreSection.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestoreSection;

  /// No description provided for @backupRestoreInfo.
  ///
  /// In en, this message translates to:
  /// **'Select a .medid backup file and enter its passphrase. Profiles that already exist on this device will be skipped.'**
  String get backupRestoreInfo;

  /// No description provided for @backupRestorePassphraseRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the passphrase for this backup.'**
  String get backupRestorePassphraseRequired;

  /// No description provided for @backupImportBackupAction.
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get backupImportBackupAction;

  /// No description provided for @backupPickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick backup file (.medid)'**
  String get backupPickFile;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Your Medical ID, Always Ready'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Store critical medical information — blood type, allergies, medications, and emergency contacts — in one secure place.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Instant Access via QR Code'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'First responders can scan your QR code to access your medical information in seconds, even without internet.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Private & Offline by Design'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'All data stays on your device. Nothing is sent to servers. You control who sees your information.'**
  String get onboardingBody3;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @profileEditorTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditorTitleEdit;

  /// No description provided for @profileEditorTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Profile'**
  String get profileEditorTitleNew;

  /// No description provided for @profileEditorUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get profileEditorUpdateProfile;

  /// No description provided for @profileEditorSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get profileEditorSaveProfile;

  /// No description provided for @profileEditorPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profileEditorPhotoTitle;

  /// No description provided for @profileEditorTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get profileEditorTakePhoto;

  /// No description provided for @profileEditorChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get profileEditorChooseGallery;

  /// No description provided for @profileEditorRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get profileEditorRemovePhoto;

  /// No description provided for @profileEditorPhotoError.
  ///
  /// In en, this message translates to:
  /// **'Could not load photo'**
  String get profileEditorPhotoError;

  /// No description provided for @profileEditorDobRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a date of birth'**
  String get profileEditorDobRequired;

  /// No description provided for @profileEditorBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get profileEditorBasicInfo;

  /// No description provided for @profileEditorFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileEditorFullName;

  /// No description provided for @profileEditorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get profileEditorNameRequired;

  /// No description provided for @profileEditorDob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profileEditorDob;

  /// No description provided for @profileEditorDobValidation.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get profileEditorDobValidation;

  /// No description provided for @profileEditorBloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get profileEditorBloodType;

  /// No description provided for @profileEditorBloodTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get profileEditorBloodTypeUnknown;

  /// No description provided for @profileEditorSex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get profileEditorSex;

  /// No description provided for @profileEditorSexNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileEditorSexNotSet;

  /// No description provided for @profileEditorHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get profileEditorHeight;

  /// No description provided for @profileEditorWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get profileEditorWeight;

  /// No description provided for @profileEditorOrganDonor.
  ///
  /// In en, this message translates to:
  /// **'Organ Donor'**
  String get profileEditorOrganDonor;

  /// No description provided for @profileEditorPrimaryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Primary Language'**
  String get profileEditorPrimaryLanguage;

  /// No description provided for @profileEditorMedicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Medical Details'**
  String get profileEditorMedicalDetails;

  /// No description provided for @profileEditorAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get profileEditorAllergies;

  /// No description provided for @profileEditorMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get profileEditorMedications;

  /// No description provided for @profileEditorMedicalConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical Conditions'**
  String get profileEditorMedicalConditions;

  /// No description provided for @profileEditorMedicalNotes.
  ///
  /// In en, this message translates to:
  /// **'Medical Notes'**
  String get profileEditorMedicalNotes;

  /// No description provided for @profileEditorEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get profileEditorEmergencyContacts;

  /// No description provided for @profileEditorContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get profileEditorContacts;

  /// No description provided for @profileEditorNoItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No {items} added yet.'**
  String profileEditorNoItemsYet(String items);

  /// No description provided for @profileEditorAddAllergy.
  ///
  /// In en, this message translates to:
  /// **'Add Allergy'**
  String get profileEditorAddAllergy;

  /// No description provided for @profileEditorEditAllergy.
  ///
  /// In en, this message translates to:
  /// **'Edit Allergy'**
  String get profileEditorEditAllergy;

  /// No description provided for @profileEditorAllergen.
  ///
  /// In en, this message translates to:
  /// **'Allergen *'**
  String get profileEditorAllergen;

  /// No description provided for @profileEditorSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get profileEditorSeverity;

  /// No description provided for @profileEditorReaction.
  ///
  /// In en, this message translates to:
  /// **'Reaction (optional)'**
  String get profileEditorReaction;

  /// No description provided for @profileEditorAddMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get profileEditorAddMedication;

  /// No description provided for @profileEditorEditMedication.
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get profileEditorEditMedication;

  /// No description provided for @profileEditorMedicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name *'**
  String get profileEditorMedicationName;

  /// No description provided for @profileEditorDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get profileEditorDosage;

  /// No description provided for @profileEditorDosageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500mg'**
  String get profileEditorDosageHint;

  /// No description provided for @profileEditorFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get profileEditorFrequency;

  /// No description provided for @profileEditorFrequencyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2x daily'**
  String get profileEditorFrequencyHint;

  /// No description provided for @profileEditorPrescribedFor.
  ///
  /// In en, this message translates to:
  /// **'Prescribed For'**
  String get profileEditorPrescribedFor;

  /// No description provided for @profileEditorPrescribedForHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hypertension'**
  String get profileEditorPrescribedForHint;

  /// No description provided for @profileEditorAddCondition.
  ///
  /// In en, this message translates to:
  /// **'Add Condition'**
  String get profileEditorAddCondition;

  /// No description provided for @profileEditorEditCondition.
  ///
  /// In en, this message translates to:
  /// **'Edit Condition'**
  String get profileEditorEditCondition;

  /// No description provided for @profileEditorConditionName.
  ///
  /// In en, this message translates to:
  /// **'Condition Name *'**
  String get profileEditorConditionName;

  /// No description provided for @profileEditorDiagnosedDate.
  ///
  /// In en, this message translates to:
  /// **'Diagnosed Date'**
  String get profileEditorDiagnosedDate;

  /// No description provided for @profileEditorDiagnosedDateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2020 or Jan 2020'**
  String get profileEditorDiagnosedDateHint;

  /// No description provided for @profileEditorNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get profileEditorNotes;

  /// No description provided for @profileEditorAddContact.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get profileEditorAddContact;

  /// No description provided for @profileEditorEditContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get profileEditorEditContact;

  /// No description provided for @profileEditorContactName.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get profileEditorContactName;

  /// No description provided for @profileEditorContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone *'**
  String get profileEditorContactPhone;

  /// No description provided for @profileEditorRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get profileEditorRelationship;

  /// No description provided for @profileEditorRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Spouse, Parent'**
  String get profileEditorRelationshipHint;

  /// No description provided for @emergencyCardTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} — Emergency Card'**
  String emergencyCardTitle(String name);

  /// No description provided for @emergencyCardGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating Emergency Card…'**
  String get emergencyCardGenerating;

  /// No description provided for @emergencyCardFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate card'**
  String get emergencyCardFailed;

  /// No description provided for @emergencyCardTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get emergencyCardTryAgain;

  /// No description provided for @qrDisplayEmergencyLabel.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY MEDICAL ID'**
  String get qrDisplayEmergencyLabel;

  /// No description provided for @qrDisplaySemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'QR code with medical info for {name}'**
  String qrDisplaySemanticLabel(String name);

  /// No description provided for @qrDisplayBloodType.
  ///
  /// In en, this message translates to:
  /// **'Type {type}'**
  String qrDisplayBloodType(String type);

  /// No description provided for @qrDisplayAllergyCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Allergies'**
  String qrDisplayAllergyCount(int count);

  /// No description provided for @qrDisplayTruncated.
  ///
  /// In en, this message translates to:
  /// **'Some details were omitted to fit QR capacity'**
  String get qrDisplayTruncated;

  /// No description provided for @qrScannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Medical ID'**
  String get qrScannerTitle;

  /// No description provided for @qrScannerNotMedicalId.
  ///
  /// In en, this message translates to:
  /// **'This QR code is not a Medical ID.'**
  String get qrScannerNotMedicalId;

  /// No description provided for @qrScannerInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point at a Medical ID QR code'**
  String get qrScannerInstruction;

  /// No description provided for @qrScannerProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing ID...'**
  String get qrScannerProcessing;

  /// No description provided for @scannedProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical ID Result'**
  String get scannedProfileTitle;

  /// No description provided for @scannedProfileAllergies.
  ///
  /// In en, this message translates to:
  /// **'ALLERGIES'**
  String get scannedProfileAllergies;

  /// No description provided for @scannedProfileMedications.
  ///
  /// In en, this message translates to:
  /// **'MEDICATIONS'**
  String get scannedProfileMedications;

  /// No description provided for @scannedProfileConditions.
  ///
  /// In en, this message translates to:
  /// **'MEDICAL CONDITIONS'**
  String get scannedProfileConditions;

  /// No description provided for @scannedProfileContacts.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY CONTACTS'**
  String get scannedProfileContacts;

  /// No description provided for @scannedProfileTamperTitle.
  ///
  /// In en, this message translates to:
  /// **'FORMAT CHECK FAILED — VERIFY DATA WITH PATIENT'**
  String get scannedProfileTamperTitle;

  /// No description provided for @scannedProfileTamperMessage.
  ///
  /// In en, this message translates to:
  /// **'This QR may have been altered or generated by another app. Confirm all details directly.'**
  String get scannedProfileTamperMessage;

  /// No description provided for @scannedProfileBorn.
  ///
  /// In en, this message translates to:
  /// **'Born'**
  String get scannedProfileBorn;

  /// No description provided for @scannedProfileBloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get scannedProfileBloodType;

  /// No description provided for @scannedProfileSex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get scannedProfileSex;

  /// No description provided for @scannedProfileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get scannedProfileHeight;

  /// No description provided for @scannedProfileWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get scannedProfileWeight;

  /// No description provided for @scannedProfileOrganDonor.
  ///
  /// In en, this message translates to:
  /// **'Organ Donor'**
  String get scannedProfileOrganDonor;

  /// No description provided for @scannedProfileYes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get scannedProfileYes;

  /// No description provided for @scannedProfileNo.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get scannedProfileNo;

  /// No description provided for @profileCardEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileCardEditProfile;

  /// No description provided for @profileCardEmergencyCard.
  ///
  /// In en, this message translates to:
  /// **'Emergency Card'**
  String get profileCardEmergencyCard;

  /// No description provided for @profileCardDeleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get profileCardDeleteProfile;

  /// No description provided for @profileCardDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete profile?'**
  String get profileCardDeleteTitle;

  /// No description provided for @profileCardDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete {name}\'s medical profile.'**
  String profileCardDeleteMessage(String name);

  /// No description provided for @profileCardPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get profileCardPrimary;

  /// No description provided for @profileCardSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get profileCardSecondary;

  /// No description provided for @profileCardCriticalAllergies.
  ///
  /// In en, this message translates to:
  /// **'Critical Allergies'**
  String get profileCardCriticalAllergies;

  /// No description provided for @profileCardViewQr.
  ///
  /// In en, this message translates to:
  /// **'View Emergency QR'**
  String get profileCardViewQr;

  /// No description provided for @profileCardEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Database Encrypted'**
  String get profileCardEncrypted;

  /// No description provided for @profileCardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String profileCardUpdated(String date);

  /// No description provided for @profileCardToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get profileCardToday;

  /// No description provided for @profileCardYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get profileCardYesterday;

  /// No description provided for @dialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialogConfirm;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDelete;

  /// No description provided for @allergySeverityMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get allergySeverityMild;

  /// No description provided for @allergySeverityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get allergySeverityModerate;

  /// No description provided for @allergySeveritySevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get allergySeveritySevere;

  /// No description provided for @allergySeverityLifeThreatening.
  ///
  /// In en, this message translates to:
  /// **'Life-Threatening'**
  String get allergySeverityLifeThreatening;

  /// No description provided for @lockTimeoutImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get lockTimeoutImmediately;

  /// No description provided for @lockTimeoutAfter1Min.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get lockTimeoutAfter1Min;

  /// No description provided for @lockTimeoutAfter5Min.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get lockTimeoutAfter5Min;

  /// No description provided for @lockTimeoutNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get lockTimeoutNever;

  /// No description provided for @biologicalSexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get biologicalSexMale;

  /// No description provided for @biologicalSexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get biologicalSexFemale;

  /// No description provided for @biologicalSexOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get biologicalSexOther;

  /// No description provided for @pdfMedicalId.
  ///
  /// In en, this message translates to:
  /// **'⚕  MEDICAL ID'**
  String get pdfMedicalId;

  /// No description provided for @pdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Medical Card — {name}'**
  String pdfTitle(String name);

  /// No description provided for @pdfDobBlood.
  ///
  /// In en, this message translates to:
  /// **'DOB: {dob}   Blood: {bloodType}'**
  String pdfDobBlood(String dob, String bloodType);

  /// No description provided for @pdfSexDonor.
  ///
  /// In en, this message translates to:
  /// **'Sex: {sex}   Organ Donor: {donor}'**
  String pdfSexDonor(String sex, String donor);

  /// No description provided for @pdfDonorOnly.
  ///
  /// In en, this message translates to:
  /// **'Organ Donor: {donor}'**
  String pdfDonorOnly(String donor);

  /// No description provided for @pdfAllergies.
  ///
  /// In en, this message translates to:
  /// **'⚠  ALLERGIES'**
  String get pdfAllergies;

  /// No description provided for @pdfNoAllergies.
  ///
  /// In en, this message translates to:
  /// **'No known allergies'**
  String get pdfNoAllergies;

  /// No description provided for @pdfConditions.
  ///
  /// In en, this message translates to:
  /// **'CONDITIONS'**
  String get pdfConditions;

  /// No description provided for @pdfMedications.
  ///
  /// In en, this message translates to:
  /// **'MEDICATIONS'**
  String get pdfMedications;

  /// No description provided for @pdfEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY CONTACTS'**
  String get pdfEmergencyContacts;

  /// No description provided for @pdfNotes.
  ///
  /// In en, this message translates to:
  /// **'NOTES'**
  String get pdfNotes;

  /// No description provided for @pdfNoAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'No additional medical information.'**
  String get pdfNoAdditionalInfo;

  /// No description provided for @pdfYes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get pdfYes;

  /// No description provided for @pdfNo.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get pdfNo;

  /// No description provided for @a11yPinDigit.
  ///
  /// In en, this message translates to:
  /// **'Digit {digit}'**
  String a11yPinDigit(String digit);

  /// No description provided for @a11yPinDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete last digit'**
  String get a11yPinDelete;

  /// No description provided for @a11yPinBiometric.
  ///
  /// In en, this message translates to:
  /// **'Authenticate with biometrics'**
  String get a11yPinBiometric;

  /// No description provided for @a11yPinDotsEntered.
  ///
  /// In en, this message translates to:
  /// **'{entered} of {total} digits entered'**
  String a11yPinDotsEntered(int entered, int total);

  /// No description provided for @a11yCloseQrDisplay.
  ///
  /// In en, this message translates to:
  /// **'Close QR display'**
  String get a11yCloseQrDisplay;

  /// No description provided for @a11yToggleTorch.
  ///
  /// In en, this message translates to:
  /// **'Toggle flashlight'**
  String get a11yToggleTorch;

  /// No description provided for @a11yMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get a11yMoreActions;

  /// No description provided for @a11yEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit {item}'**
  String a11yEditItem(String item);

  /// No description provided for @a11yDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete {item}'**
  String a11yDeleteItem(String item);

  /// No description provided for @a11yProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get a11yProfilePhoto;

  /// No description provided for @a11yAllergyWithSeverity.
  ///
  /// In en, this message translates to:
  /// **'Allergy: {name}, severity: {severity}'**
  String a11yAllergyWithSeverity(String name, String severity);

  /// No description provided for @a11yTogglePasswordVisibility.
  ///
  /// In en, this message translates to:
  /// **'Toggle password visibility'**
  String get a11yTogglePasswordVisibility;

  /// No description provided for @a11ySelectedOption.
  ///
  /// In en, this message translates to:
  /// **'{label}, selected'**
  String a11ySelectedOption(String label);

  /// No description provided for @a11yLoadingButton.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get a11yLoadingButton;

  /// No description provided for @a11yProcessingQr.
  ///
  /// In en, this message translates to:
  /// **'Processing scanned QR code'**
  String get a11yProcessingQr;

  /// No description provided for @a11yStepIndicator.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String a11yStepIndicator(int current, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
