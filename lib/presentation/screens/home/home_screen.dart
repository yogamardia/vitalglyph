import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/data/services/widget_service.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_event.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_state.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';
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
      duration: AppDuration.spring,
    );
    context.read<ProfileBloc>().add(const ProfilesWatchStarted());
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.push(AppRouter.scanner);
      case 1:
        context.push(AppRouter.profileNew);
      case 2:
        context.push(AppRouter.settings);
    }
  }

  void _triggerListAnimation() {
    _listController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<VitalGlyphColors>()!;
    final cs = theme.colorScheme;

    return GradientScaffold(
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
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.xl,
                    bottom: AppSpacing.md,
                  ),
                  centerTitle: false,
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.brandName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        context.l10n.appTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is ProfileLoading || state is ProfileInitial)
                const SliverFillRemaining(
                  child: _ShimmerLoading(),
                )
              else if (state is ProfileError)
                SliverFillRemaining(
                  child: _ErrorState(
                    message: state.message,
                    onRetry: () => context
                        .read<ProfileBloc>()
                        .add(const ProfilesWatchStarted()),
                  ),
                )
              else if (state is ProfileLoaded && state.profiles.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(
                    onAddProfile: () => context.push(AppRouter.profileNew),
                  ),
                )
              else if (state is ProfileLoaded)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    120, // Increased bottom padding for nav bar clearance
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final profiles = state.profiles;
                        final itemStart = (index * 0.1).clamp(0.0, 0.7);
                        final itemEnd = (itemStart + 0.4).clamp(0.0, 1.0);
                        final animation = CurvedAnimation(
                          parent: _listController,
                          curve: Interval(itemStart, itemEnd,
                              curve: Curves.easeOutCubic),
                        );

                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, 30 * (1.0 - animation.value)),
                              child: Opacity(
                                opacity: animation.value,
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
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
                          ),
                        );
                      },
                      childCount: state.profiles.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: _ModernBottomNavBar(
        onTap: _onItemTapped,
        colors: colors,
      ),
    );
  }
}

class _ModernBottomNavBar extends StatelessWidget {

  const _ModernBottomNavBar({
    required this.onTap,
    required this.colors,
  });
  final ValueChanged<int> onTap;
  final VitalGlyphColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassSurface,
        border: Border(
          top: BorderSide(
            color: colors.cardBorder,
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.qr_code_scanner_rounded,
                label: context.l10n.homeScan,
                onTap: () => onTap(0),
                cs: cs,
              ),
              _NavBarItem(
                icon: Icons.add_rounded,
                label: context.l10n.homeNewProfile,
                onTap: () => onTap(1),
                cs: cs,
                isAction: true,
              ),
              _NavBarItem(
                icon: Icons.settings_rounded,
                label: context.l10n.homeSettings,
                onTap: () => onTap(2),
                cs: cs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cs,
    this.isAction = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme cs;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    final color = cs.onSurfaceVariant.withValues(alpha: 0.5);
    
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAction)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: cs.onPrimary,
                    size: 28,
                  ),
                )
              else ...[
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
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
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            colors.shimmerBase.withValues(alpha: 0.5),
            colors.shimmerHighlight.withValues(alpha: 0.8),
            colors.shimmerBase.withValues(alpha: 0.5),
          ],
          transform: _SlidingGradientTransform(_animation.value),
        );

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _ShimmerSkeleton(gradient: gradient, colors: colors),
            const SizedBox(height: AppSpacing.lg),
            _ShimmerSkeleton(gradient: gradient, colors: colors),
          ],
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);
  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

class _ShimmerSkeleton extends StatelessWidget {

  const _ShimmerSkeleton({required this.gradient, required this.colors});
  final Gradient gradient;
  final VitalGlyphColors colors;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      enableBlur: false,
      backgroundColor: colors.glassSurface.withValues(alpha: 0.4),
      borderColor: colors.glassBorder.withValues(alpha: 0.2),
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: gradient.createShader,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {

  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<VitalGlyphColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: GlassContainer(
          padding: const EdgeInsets.all(AppSpacing.xl),
          backgroundColor: colors.glassSurface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: theme.colorScheme.error),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatefulWidget {

  const _EmptyState({required this.onAddProfile});
  final VoidCallback onAddProfile;

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: child,
              );
            },
            child: SizedBox(
              width: 140,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative pulsing dots
                  for (int i = 0; i < 3; i++)
                    _PulsingDot(index: i, colors: colors),
                  
                  Transform.rotate(
                    angle: -0.12,
                    child: Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: colors.cardBorder,
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: 0.08,
                    child: Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: cs.onPrimary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            context.l10n.homeEmptyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.homeEmptyDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: widget.onAddProfile,
            icon: const Icon(Icons.person_add_rounded),
            label: Text(context.l10n.homeAddProfile),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {

  const _PulsingDot({required this.index, required this.colors});
  final int index;
  final VitalGlyphColors colors;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    // Delay each dot
    Future.delayed(Duration(milliseconds: widget.index * 600), () {
      if (mounted) _controller.forward();
    });

    _animation = Tween<double>(begin: 0.3, end: 1).animate(
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
    final offsets = [
      const Offset(-60, -40),
      const Offset(60, -30),
      const Offset(40, 40),
    ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: offsets[widget.index],
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.colors.glowPrimary.withValues(alpha: _animation.value),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
