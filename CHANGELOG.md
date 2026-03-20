# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-03-20

### Added
- Medical profiles for storing critical health information locally on the device (blood type, allergies, medications, conditions, emergency contacts).
- QR code display for quick scanning of medical profiles with HMAC-signed payload and screen wakelock to ensure readability by first responders.
- QR code scanner capability to read other people's VitalGlyph cards with integrity verification.
- Printable emergency card functionality via PDF generation (credit-card sized).
- PIN and biometric authentication (Face ID / fingerprint) with configurable auto-lock timeouts.
- Encrypted backup and restore functionality (AES-256-CBC, PBKDF2).
- Dark and light theme modes using a glassmorphism design system.
- Functional error handling framework throughout the application via Clean Architecture principles.
- Built-in home screen widget for quick access to critical information (name, blood type, and allergy count) on iOS and Android.