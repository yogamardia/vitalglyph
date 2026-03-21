# App Store Review Notes

## App Review Information

### Notes for Reviewer
VitalGlyph is an offline-first medical ID app. It does not require an internet connection, user accounts, or any server infrastructure.

To test the app:
1. Launch the app and complete the onboarding flow
2. Create a profile with sample medical information (name, blood type, allergies, etc.)
3. View the generated QR code from the profile card
4. Use the QR scanner to scan the code (you can use a second device or screenshot)
5. Generate an emergency PDF card from the profile menu
6. Test backup/restore: Settings > Backup & Restore > Export with a passphrase

No login credentials are needed. All features work fully offline.

### Demo Account
Not applicable — the app has no accounts or server connectivity.

## Health App Declaration

### Does your app provide health-related services?
Yes — the app stores and displays medical identification information for emergency use.

### What health data does your app handle?
- Blood type
- Allergies (name, severity, reaction)
- Medications (name, dosage, frequency)
- Medical conditions (name, diagnosis date)
- Emergency contact information
- Organ donor status
- Biological sex, height, weight

### How is health data stored?
All data is stored locally on the user's device in a SQLite database. No data is transmitted to any server.

### Is the app a regulated medical device?
No. VitalGlyph is an informational tool for storing medical ID data. It does not diagnose, treat, cure, or prevent any disease or condition. A medical disclaimer is displayed during onboarding and accessible from Settings.

### HealthKit integration?
No. The app does not read from or write to Apple HealthKit.

## App Privacy Details (App Store Connect)

### Data Not Collected
VitalGlyph does not collect any data. All information entered by the user is stored exclusively on their device and is never transmitted to us or any third party.

Select: **Data Not Collected** in App Store Connect privacy section.

## Export Compliance

### Does the app use encryption?
Yes — the app uses encryption for:
- AES-256-CBC for backup file encryption (user-initiated, with user-provided passphrase)
- HMAC-SHA256 for QR code data integrity
- SHA-256 for PIN hashing

### Is the encryption exempt from export compliance?
Yes — all encryption is used for:
- Authentication (PIN hashing)
- Data protection on device (backup encryption)
- Data integrity (HMAC signatures)

This qualifies for the encryption exemption under Category 5, Part 2 of the EAR (mass-market encryption). Select **Yes** for "Does your app qualify for any of the exemptions provided in Category 5, Part 2?"

## Content Rights
All content in the app is user-generated (their own medical information). The app does not include third-party content requiring rights clearance.
