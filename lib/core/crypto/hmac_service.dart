import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Provides HMAC-SHA256 signing and verification for QR payloads.
///
/// The key is a well-known constant — this is intentional.
/// The QR must be readable by any first responder without authentication,
/// so the goal of the HMAC is **integrity** (detect accidental or malicious
/// corruption), NOT confidentiality.
class HmacService {
  // Public constant key — anyone with the app can verify, but
  // tampering is still detectable if the attacker doesn't know this value.
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
