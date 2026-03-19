# VitalGlyph

**Offline-first emergency medical ID — no accounts, no servers, no cloud.**

VitalGlyph stores your critical health information on your device and surfaces it exactly when it's needed: a scannable QR code, a printable wallet card, and a home screen widget. All data stays on your device, optionally protected by PIN or biometrics.

---

## Features

- **Medical profiles** — blood type, biological sex, allergies (with severity), medications, conditions, emergency contacts
- **QR code display** — HMAC-signed payload with wakelock; keeps screen on for first responders
- **QR code scanner** — scan and view another person's VitalGlyph card with integrity verification
- **Printable emergency card** — credit-card-sized two-page PDF, ready to print or share
- **PIN + biometric lock** — SHA-256 salted PIN, Face ID / fingerprint via `local_auth`, configurable auto-lock timeout
- **Home screen widget** — name, blood type, and allergy count at a glance (iOS WidgetKit & Android App Widget)
- **Encrypted backup / restore** — AES-256-CBC + PBKDF2, exported as a `.medid` file with merge-on-import strategy
- **Dark / light theme** — full theme support with glassmorphism design system
- **Onboarding flow** — first-time user experience

---

## Architecture

Clean Architecture with BLoC state management and functional error handling (`Either<Failure, T>`).

```
lib/
├── core/              # Enums, crypto services, router, theme, error types
│   ├── constants/     #   BloodType, AllergySeverity, BiologicalSex, LockTimeout
│   ├── crypto/        #   HMAC, PIN hashing, backup encryption, auth settings
│   ├── error/         #   Failure classes
│   ├── router/        #   GoRouter config + custom page transitions
│   ├── services/      #   App preferences
│   └── theme/         #   Colors, spacing, ThemeData (light/dark)
│
├── domain/            # Entities, repository interfaces, use cases
│   ├── entities/      #   Profile, Allergy, Medication, MedicalCondition, EmergencyContact
│   ├── repositories/  #   Abstract ProfileRepository
│   └── usecases/      #   CRUD, QR generate/parse, PDF export, backup/restore
│
├── data/              # Drift (SQLite) database, repository implementations, services
│   ├── datasources/   #   Drift DB schema + ProfileDao
│   ├── repositories/  #   ProfileRepository implementation
│   └── services/      #   Home screen widget data service
│
└── presentation/      # BLoC cubits + screens + reusable widgets
    ├── blocs/         #   AuthCubit, ProfileBloc, BackupCubit, ThemeCubit
    ├── screens/       #   Home, Onboarding, Auth, ProfileEditor, QR, Settings, Backup
    └── widgets/       #   GlassContainer, GradientScaffold, ProfileCard, AppButton, etc.
```

### Key technology choices

| Concern | Package |
|---|---|
| Local database | `drift` + `sqlite3_flutter_libs` |
| State management | `flutter_bloc` (BLoC + Cubits) |
| Routing | `go_router` |
| Dependency injection | `get_it` |
| Secure storage | `flutter_secure_storage` |
| Biometrics | `local_auth` |
| QR code | `qr_flutter` + `mobile_scanner` |
| PDF generation | `pdf` + `printing` |
| Home screen widget | `home_widget` |
| Backup encryption | `encrypt` (AES-256-CBC) |
| Functional error handling | `dartz` (`Either<Failure, T>`) |
| Typography | `google_fonts` |

### Database schema

Five tables with cascade delete from Profiles:

```
Profiles ──┬── Allergies
            ├── Medications
            ├── MedicalConditions
            └── EmergencyContacts
```

### Screens & routes

| Route | Path | Description |
|---|---|---|
| Home | `/` | Profile list & dashboard |
| Onboarding | `/onboarding` | First-time user flow |
| QR Display | `/qr` | Full-screen immersive QR code |
| Scanner | `/scanner` | Camera-based QR scanner |
| Scan Result | `/scanner/result` | Scanned profile details |
| Settings | `/settings` | Auth, theme, and data settings |
| Profile New | `/profile/new` | Create a medical profile |
| Profile Edit | `/profile/edit` | Edit an existing profile |
| Emergency Card | `/emergency-card` | PDF preview, print & share |
| Backup | `/backup` | Backup export & restore |

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.11.0`
- Dart SDK `^3.11.0`

### Install & run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Run tests

```bash
flutter test
```

72 tests across core services, domain use cases, entities, and presentation BLoCs.

### Analyze

```bash
flutter analyze
```

---

## Home Screen Widget

The widget shows the user's name, blood type, and allergy count at a glance.

**Android** — no extra steps; the widget is declared in `AndroidManifest.xml`.

**iOS** — open `ios/Runner.xcworkspace` in Xcode and:

1. File > New > Target > Widget Extension — name it `VitalglyphWidget` (no configuration intent)
2. Replace the generated Swift files with those in `ios/VitalglyphWidget/`
3. Add the App Group `group.com.example.vitalglyph` to both the Runner and VitalglyphWidget targets
4. Set the widget bundle ID to `$(PRODUCT_BUNDLE_IDENTIFIER).VitalglyphWidget`

---

## Backup Format

Backups are exported as `.medid` files with the format:

```
MEDID_BACKUP|v1|<salt_b64>|<iv_b64>|<cipher_b64>
```

- **Encryption:** AES-256-CBC, key derived via PBKDF2-HMAC-SHA256 (100,000 iterations)
- **Import strategy:** merge — existing profiles (matched by ID) are skipped, new profiles are added
- **Integrity check:** wrong passphrase detected via `medid_version` JSON key validation
- The passphrase never leaves the device

---

## Security

| Layer | Implementation |
|---|---|
| PIN storage | SHA-256 hash with random base64 salt in `flutter_secure_storage` |
| Biometrics | Face ID / fingerprint via `local_auth` |
| Auto-lock | Configurable timeout (immediately, 1 min, 5 min, never) triggered on app resume |
| QR integrity | HMAC-SHA256 signature embedded in QR payload |
| Backup encryption | AES-256-CBC + PBKDF2 (100k iterations) |

---

## Privacy

VitalGlyph makes **zero network requests**. There are no analytics, no accounts, and no third-party SDKs that transmit data. Everything is stored in a local SQLite database on your device.

---

## License

MIT
