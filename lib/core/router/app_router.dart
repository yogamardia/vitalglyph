import 'package:go_router/go_router.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/entities/scanned_profile.dart';
import 'package:vitalglyph/domain/usecases/export_emergency_card.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/screens/emergency_card/emergency_card_screen.dart';
import 'package:vitalglyph/presentation/screens/home/home_screen.dart';
import 'package:vitalglyph/presentation/screens/profile_editor/profile_editor_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_display/qr_display_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_scanner/scanned_profile_view.dart';
import 'package:vitalglyph/presentation/screens/settings/settings_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String qrDisplay = '/qr';
  static const String scanner = '/scanner';
  static const String scanResult = '/scanner/result';
  static const String settings = '/settings';
  static const String profileNew = '/profile/new';
  static const String profileEdit = '/profile/edit';
  static const String emergencyCard = '/emergency-card';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: qrDisplay,
        builder: (context, state) {
          final profile = state.extra! as Profile;
          return QrDisplayScreen(profile: profile);
        },
      ),
      GoRoute(
        path: scanner,
        builder: (context, state) => const QrScannerScreen(),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) {
              final scanned = state.extra! as ScannedProfile;
              return ScannedProfileView(profile: scanned);
            },
          ),
        ],
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: profileNew,
        builder: (context, state) => const ProfileEditorScreen(),
      ),
      GoRoute(
        path: profileEdit,
        builder: (context, state) {
          final profile = state.extra! as Profile;
          return ProfileEditorScreen(profile: profile);
        },
      ),
      GoRoute(
        path: emergencyCard,
        builder: (context, state) {
          final profile = state.extra! as Profile;
          return EmergencyCardScreen(
            profile: profile,
            exportEmergencyCard: sl<ExportEmergencyCard>(),
          );
        },
      ),
    ],
  );
}
