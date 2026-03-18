import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/core/theme/app_theme.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_state.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';
import 'package:vitalglyph/presentation/blocs/theme/theme_cubit.dart';
import 'package:vitalglyph/presentation/screens/auth/lock_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>()..load(),
        ),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
      ],
      child: const _AppContent(),
    );
  }
}

/// Separated so [BlocProvider]s are available before [_AppContent] builds.
class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    return _LifecycleObserver(
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Medical ID',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLocked = state is AuthRequired;
                  return Stack(
                    children: [
                      if (child != null)
                        IgnorePointer(
                          ignoring: isLocked,
                          child: child,
                        ),
                      if (isLocked)
                        LockScreen(
                          canUseBiometric: state.canUseBiometric,
                          hasPinSet: state.hasPinSet,
                        ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Handles [AppLifecycleState] changes to trigger auto-lock.
class _LifecycleObserver extends StatefulWidget {
  final Widget child;
  const _LifecycleObserver({required this.child});

  @override
  State<_LifecycleObserver> createState() => _LifecycleObserverState();
}

class _LifecycleObserverState extends State<_LifecycleObserver>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check auth on startup (may show lock screen if enabled).
    context.read<AuthCubit>().checkAuthRequired();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed &&
        _backgroundedAt != null) {
      final elapsed = DateTime.now().difference(_backgroundedAt!);
      _backgroundedAt = null;
      context.read<AuthCubit>().onResumed(elapsed);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
