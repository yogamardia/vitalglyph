import 'dart:ui';
import 'package:screen_protector/screen_protector.dart';

/// Service to handle app-wide screen protection (preventing screenshots and screen recording).
class ScreenProtectionService {
  /// Enables protection against screenshots and screen recording.
  /// Also protects against data leakage in the app switcher (iOS).
  static Future<void> enable() async {
    await ScreenProtector.preventScreenshotOn();
    // Protect data leakage with a solid color in app switcher (iOS)
    await ScreenProtector.protectDataLeakageWithColor(const Color(0xFF000000));
  }

  /// Disables all screen protection.
  static Future<void> disable() async {
    await ScreenProtector.preventScreenshotOff();
    await ScreenProtector.protectDataLeakageOff();
  }
}
