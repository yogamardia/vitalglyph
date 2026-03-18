import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
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
        titleSpacing: AppSpacing.lg,
        title: const Text('Medical ID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan Medical ID',
            onPressed: () => context.push(AppRouter.scanner),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(AppRouter.settings),
          ),
          const SizedBox(width: AppSpacing.sm),
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
            return const _ShimmerLoading();
          }

          if (state is ProfileError) {
            return _ErrorState(
              message: state.message,
              onRetry: () => context
                  .read<ProfileBloc>()
                  .add(const ProfilesWatchStarted()),
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
            color: Theme.of(context).colorScheme.primary,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
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
                          begin: const Offset(0, 0.1),
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
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Profile'),
      ),
    );
  }
}

class _ShimmerLoading extends StatefulWidget {
  const _ShimmerLoading();

  @override
  State<_ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<_ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final gradient = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            colors.surfaceSubtle,
            cs.surface,
            colors.surfaceSubtle,
          ],
          transform: _SlidingGradientTransform(_animation.value),
        );

        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          children: [
            _ShimmerCard(gradient: gradient, colors: colors),
            const SizedBox(height: AppSpacing.lg),
            _ShimmerCard(gradient: gradient, colors: colors),
          ],
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

class _ShimmerCard extends StatelessWidget {
  final Gradient gradient;
  final VitalGlyphColors colors;

  const _ShimmerCard({required this.gradient, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: colors.cardBorder),
      ),
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => gradient.createShader(bounds),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.lg),
            Text(message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddProfile;

  const _EmptyState({required this.onAddProfile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Composed card illustration
            SizedBox(
              width: 120,
              height: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      width: 90,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: colors.cardBorder),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: 0.08,
                    child: Container(
                      width: 90,
                      height: 60,
                      decoration: BoxDecoration(
                        color:
                            colorScheme.primaryContainer.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Create Your First Profile',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Store blood type, allergies, medications, and emergency contacts '
              'so first responders can help you faster.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Your medical data stays on your device.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
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
