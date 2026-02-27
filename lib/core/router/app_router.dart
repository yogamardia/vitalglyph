import 'package:go_router/go_router.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/entities/scanned_profile.dart';
import 'package:vitalglyph/presentation/screens/home/home_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_display/qr_display_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:vitalglyph/presentation/screens/qr_scanner/scanned_profile_view.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String qrDisplay = '/qr';
  static const String scanner = '/scanner';
  static const String scanResult = '/scanner/result';

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
    ],
  );
}
