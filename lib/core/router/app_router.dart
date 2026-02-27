import 'package:go_router/go_router.dart';
import 'package:vitalglyph/presentation/screens/home/home_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
