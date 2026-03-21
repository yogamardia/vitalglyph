import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';

const _kAppGroupId = 'group.com.yogamardia.vitalglyph';
const _kAndroidWidgetName = 'VitalglyphWidgetProvider';
const _kiOSWidgetName = 'VitalglyphWidget';

/// Manages the home screen widget that shows a glanceable Medical ID
/// (QR code + name + blood type) for first responders.
///
/// Data is intentionally unencrypted — first responders must read it
/// without unlocking the phone.
class WidgetService {
  WidgetService(this._generateQrData);
  final GenerateQrData _generateQrData;

  /// Sets the iOS App Group ID so the widget extension can share data.
  /// Must be called once at app startup before any save/update calls.
  Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_kAppGroupId);
  }

  /// Renders the QR code for [profile] as a bitmap, saves all widget data,
  /// and triggers a widget refresh on both platforms.
  Future<void> updateWithProfile(Profile profile) async {
    final qrData = _generateQrData(profile).data;

    // Persist text fields readable by native widget code.
    await HomeWidget.saveWidgetData('profile_name', profile.name);
    await HomeWidget.saveWidgetData(
      'blood_type',
      profile.bloodType?.displayName ?? '',
    );
    await HomeWidget.saveWidgetData(
      'allergy_count',
      profile.allergies.length.toString(),
    );

    // Render QR using Flutter's qr_flutter and save the resulting bitmap.
    // pixelRatio: 3 → crisp on high-DPI screens without context dependency.
    await HomeWidget.renderFlutterWidget(
      QrImageView(
        data: qrData,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(8),
      ),
      key: 'qr_widget',
      pixelRatio: 3,
    );

    await HomeWidget.updateWidget(
      androidName: _kAndroidWidgetName,
      iOSName: _kiOSWidgetName,
    );
  }

  /// Clears all widget data (e.g. when the last profile is deleted).
  Future<void> clearWidget() async {
    await HomeWidget.saveWidgetData<String?>('profile_name', null);
    await HomeWidget.saveWidgetData<String?>('blood_type', null);
    await HomeWidget.saveWidgetData<String?>('allergy_count', null);
    await HomeWidget.updateWidget(
      androidName: _kAndroidWidgetName,
      iOSName: _kiOSWidgetName,
    );
  }
}
