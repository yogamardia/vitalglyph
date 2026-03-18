import 'package:go_router/go_router.dart';
import 'package:vitalglyph/core/router/page_transitions.dart';
import 'package:vitalglyph/core/services/app_preferences.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/entities/scanned_profile.dart';
import 'package:vitalglyph/domain/usecases/export_emergency_card.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/screens/emergency_card/emergency_card_screen.dart';
import 'package:vitalglyph/presentation/screens/home/home_screen.dart';
import 'package:vitalglyph/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:vitalglyph/presentation/screens/profile_editor/profile_editor_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_display/qr_display_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_scanner/scanned_profile_view.dart';
import 'package:vitalglyph/presentation/screens/backup/backup_screen.dart';
import 'package:vitalglyph/presentation/screens/settings/settings_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String qrDisplay = '/qr';
  static const String scanner = '/scanner';
  static const String scanResult = '/scanner/result';
  static const String settings = '/settings';
  static const String profileNew = '/profile/new';
  static const String profileEdit = '/profile/edit';
  static const String emergencyCard = '/emergency-card';
  static const String backup = '/backup';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    redirect: (context, state) async {
      if (state.matchedLocation == onboarding) return null;
      final seen = await sl<AppPreferences>().hasSeenOnboarding();
      if (!seen) return onboarding;
      return null;
    },
    routes: [
      GoRoute(
        path: onboarding,
        pageBuilder: (context, state) => PageTransitions.fade(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      // Immersive fade — QR display takeover
      GoRoute(
        path: qrDisplay,
        pageBuilder: (context, state) {
          final profile = state.extra! as Profile;
          return PageTransitions.fade(
            state: state,
            child: QrDisplayScreen(profile: profile),
          );
        },
      ),
      // Fade for scanner + shared-axis for result
      GoRoute(
        path: scanner,
        pageBuilder: (context, state) => PageTransitions.fade(
          state: state,
          child: const QrScannerScreen(),
        ),
        routes: [
          GoRoute(
            path: 'result',
            pageBuilder: (context, state) {
              final scanned = state.extra! as ScannedProfile;
              return PageTransitions.slideRight(
                state: state,
                child: ScannedProfileView(profile: scanned),
              );
            },
          ),
        ],
      ),
      // Horizontal shared-axis for settings / backup
      GoRoute(
        path: settings,
        pageBuilder: (context, state) => PageTransitions.slideRight(
          state: state,
          child: const SettingsScreen(),
        ),
      ),
      // Bottom-to-top for editor (fullscreen dialog feel)
      GoRoute(
        path: profileNew,
        pageBuilder: (context, state) => PageTransitions.slideUp(
          state: state,
          child: const ProfileEditorScreen(),
        ),
      ),
      GoRoute(
        path: profileEdit,
        pageBuilder: (context, state) {
          final profile = state.extra! as Profile;
          return PageTransitions.slideUp(
            state: state,
            child: ProfileEditorScreen(profile: profile),
          );
        },
      ),
      GoRoute(
        path: emergencyCard,
        pageBuilder: (context, state) {
          final profile = state.extra! as Profile;
          return PageTransitions.slideRight(
            state: state,
            child: EmergencyCardScreen(
              profile: profile,
              exportEmergencyCard: sl<ExportEmergencyCard>(),
            ),
          );
        },
      ),
      GoRoute(
        path: backup,
        pageBuilder: (context, state) => PageTransitions.slideRight(
          state: state,
          child: const BackupScreen(),
        ),
      ),
    ],
  );
}
