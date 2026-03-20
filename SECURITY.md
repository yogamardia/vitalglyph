# Security Policy

## Supported Versions

We only provide security updates for the latest major version of VitalGlyph. 

| Version | Supported          |
| ------- | ------------------ |
| >= 1.0  | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

Security and privacy are the core promises of VitalGlyph. We take all security vulnerabilities seriously.

If you have discovered a security vulnerability in VitalGlyph, please **DO NOT** disclose it publicly.

Instead, please send an email to `security@vitalglyph.example.com` (replace with actual security contact) or use GitHub Security Advisories to privately report the issue. 

Please include:
- A description of the vulnerability.
- Steps to reproduce the issue.
- Potential impact.

We will acknowledge receipt of your vulnerability report as soon as possible and strive to send you regular updates about our progress. If for some reason you do not receive a timely response, please reach out again.

## Threat Model & Scope

VitalGlyph operates as an offline-first application. Key security features include:

- **Local Storage:** All medical data is stored locally in an SQLite database.
- **Biometric/PIN Lock:** Implemented via `local_auth` and hashed PINs using SHA-256 with a salt.
- **Backup Encryption:** Backups are encrypted using AES-256-CBC, with keys derived via PBKDF2-HMAC-SHA256.
- **QR Code Integrity:** HMAC-SHA256 signatures are used to detect data tampering of QR payloads.

If you find ways to bypass local locks without root access, extract the encryption key for backups without the passphrase, or forge valid HMAC signatures with the open-source key in a way that tricks the application into improper behavior, please report it immediately.

_Note: Physical access to an unlocked device or a rooted/jailbroken device falls outside our typical threat model, though we implement defenses in depth where possible._