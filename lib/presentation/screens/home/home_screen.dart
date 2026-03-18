import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/data/services/widget_service.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_event.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_state.dart';
import 'package:vitalglyph/presentation/widgets/profile_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    context.read<ProfileBloc>().add(const ProfilesWatchStarted());
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _triggerListAnimation() {
    _listController.forward(from: 0);
  }

  Future<void> _onRefresh() async {
    context.read<ProfileBloc>().add(const ProfilesWatchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical ID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan Medical ID',
            onPressed: () => context.push(AppRouter.scanner),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _triggerListAnimation();
            final widgetService = sl<WidgetService>();
            if (state.profiles.isNotEmpty) {
              widgetService.updateWithProfile(state.profiles.first);
            } else {
              widgetService.clearWidget();
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<ProfileBloc>()
                          .add(const ProfilesWatchStarted()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profiles =
              state is ProfileLoaded ? state.profiles : <Profile>[];

          if (profiles.isEmpty) {
            return _EmptyState(
              onAddProfile: () => context.push(AppRouter.profileNew),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                // Staggered entry animation per item
                final itemStart = (index * 0.1).clamp(0.0, 0.7);
                final itemEnd = (itemStart + 0.4).clamp(0.0, 1.0);
                final animation = CurvedAnimation(
                  parent: _listController,
                  curve: Interval(itemStart, itemEnd, curve: Curves.easeOut),
                );

                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.15),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: ProfileCard(
                    profile: profiles[index],
                    isPrimary: index == 0,
                    onDelete: () => context
                        .read<ProfileBloc>()
                        .add(ProfileDeleteRequested(profiles[index].id)),
                    onShowQr: () => context.push(
                      AppRouter.qrDisplay,
                      extra: profiles[index],
                    ),
                    onEdit: () => context.push(
                      AppRouter.profileEdit,
                      extra: profiles[index],
                    ),
                    onEmergencyCard: () => context.push(
                      AppRouter.emergencyCard,
                      extra: profiles[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.profileNew),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Profile'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddProfile;

  const _EmptyState({required this.onAddProfile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_information_outlined,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Create Your First Profile',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Store blood type, allergies, medications, and emergency contacts '
              'so first responders can help you faster.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onAddProfile,
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Add Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
