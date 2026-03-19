import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Provides HMAC-SHA256 signing and verification for QR payloads.
///
/// **Security model — read before modifying:**
///
/// The key is a well-known constant embedded in the source code. Because
/// VitalGlyph is open-source, **any person who reads this file can forge a
/// valid signature**. The HMAC therefore provides *format-integrity checking*,
/// not tamper-proofing:
///
///  - It detects accidental corruption (truncated QR, encoding errors).
///  - It detects edits by someone who doesn't know the key.
///  - It does **NOT** guarantee the data hasn't been deliberately altered by
///    a knowledgeable attacker.
///
/// The UI never claims cryptographic verification — a failed check triggers a
/// "format check failed" warning, not a "tampered" accusation.
///
/// A future enhancement could derive a per-device key (stored in secure
/// storage) so that a user can verify their *own* QR codes haven't been
/// modified since generation. That would still not help a third-party scanner,
/// because the verifier needs the key.
class HmacService {
  // Well-known constant key — intentionally public. See class doc.
  static const String _key = 'MEDID-v1-integrity-key-vitalglyph-2025';

  /// Returns the first 16 hex characters of HMAC-SHA256(payload).
  String sign(String payload) {
    final keyBytes = utf8.encode(_key);
    final payloadBytes = utf8.encode(payload);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(payloadBytes);
    return digest.toString().substring(0, 16);
  }

  /// Returns true if [signature] matches sign([payload]).
  bool verify(String payload, String signature) {
    return sign(payload) == signature;
  }
}
