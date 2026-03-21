# Google Play Data Safety Form

Use these answers when filling out the Data Safety section in Google Play Console.

## Overview
- **Does your app collect or share any of the required user data types?** Yes
- **Is all of the user data collected by your app encrypted in transit?** N/A (no network requests)
- **Do you provide a way for users to request that their data is deleted?** Yes (users can delete profiles directly in-app)

## Data Types

### Health Info
- **Collected:** Yes (stored locally only)
- **Shared:** No
- **Is this data processed ephemerally?** No (persisted locally)
- **Is this data required or optional?** Required (core app function)
- **Purpose:** App functionality

### Personal Info — Name
- **Collected:** Yes (stored locally only)
- **Shared:** No
- **Purpose:** App functionality

### Personal Info — Date of Birth
- **Collected:** Yes (stored locally only)
- **Shared:** No
- **Purpose:** App functionality

### Personal Info — Phone Number (emergency contacts)
- **Collected:** Yes (stored locally only)
- **Shared:** No
- **Purpose:** App functionality

### Photos (profile photo)
- **Collected:** Yes (stored locally only)
- **Shared:** No
- **Purpose:** App functionality

## Key Points for Review
- The app makes **zero network requests** — all data stays on device
- No analytics, crash reporting, or telemetry SDKs
- No advertising SDKs
- Camera permission is used only for QR code scanning, not photo capture from camera (image_picker uses gallery)
- Biometric data is handled by the OS (local_auth) and never accessed by the app
- Encrypted backups are user-initiated and shared via the user's chosen method (AirDrop, Files, etc.)
