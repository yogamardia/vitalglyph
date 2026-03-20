import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/core/services/app_preferences.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/app_button.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  double _scrollOffset = 0;
  int _currentPage = 0;

  List<_PageData> _getPages(BuildContext context) {
    final l10n = context.l10n;
    return [
      _PageData(
        icon: Icons.medical_information_rounded,
        companions: [Icons.water_drop_rounded, Icons.medication_rounded],
        title: l10n.onboardingTitle1,
        body: l10n.onboardingBody1,
        gradient: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
        darkGradient: [Color(0xFF020617), Color(0xFF0F172A)],
      ),
      _PageData(
        icon: Icons.qr_code_scanner_rounded,
        companions: [Icons.phone_iphone_rounded, Icons.local_hospital_rounded],
        title: l10n.onboardingTitle2,
        body: l10n.onboardingBody2,
        gradient: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
        darkGradient: [Color(0xFF020617), Color(0xFF0F172A)],
      ),
      _PageData(
        icon: Icons.shield_rounded,
        companions: [Icons.lock_rounded, Icons.wifi_off_rounded],
        title: l10n.onboardingTitle3,
        body: l10n.onboardingBody3,
        gradient: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
        darkGradient: [Color(0xFF020617), Color(0xFF0F172A)],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _scrollOffset = _controller.page ?? 0;
      });
    });
  }

  Future<void> _finish() async {
    await sl<AppPreferences>().setOnboardingSeen();
    if (mounted) context.go(AppRouter.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPages(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isLast = _currentPage == pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradients
          for (int i = 0; i < pages.length; i++)
            Opacity(
              opacity: (1.0 - (_scrollOffset - i).abs()).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark ? pages[i].darkGradient : pages[i].gradient,
                  ),
                ),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    right: AppSpacing.md,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _finish,
                      child: Text(
                        context.l10n.onboardingSkip,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (i) {
                      HapticFeedback.selectionClick();
                      setState(() => _currentPage = i);
                    },
                    itemBuilder: (context, i) => _OnboardingPageView(data: pages[i]),
                  ),
                ),

                // Premium page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (i) {
                    final active = _currentPage == i;
                    return AnimatedContainer(
                      duration: AppDuration.medium,
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 32 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: active
                            ? cs.primary
                            : cs.onSurface.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          if (active)
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                    );
                  }),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Next / Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isLast
                        ? AppButton.primary(
                            key: const ValueKey('get_started'),
                            label: context.l10n.onboardingGetStarted,
                            onPressed: _finish,
                            fullWidth: true,
                          )
                        : AppButton.primary(
                            key: const ValueKey('next'),
                            label: context.l10n.onboardingNext,
                            onPressed: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutQuart,
                              );
                            },
                            fullWidth: true,
                          ),
                  ),
                ),

                // Medical disclaimer on last page
                AnimatedOpacity(
                  opacity: isLast ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.lg,
                      left: AppSpacing.xxl,
                      right: AppSpacing.xxl,
                    ),
                    child: Text(
                      context.l10n.disclaimerShort,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.4),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final List<IconData> companions;
  final String title;
  final String body;
  final List<Color> gradient;
  final List<Color> darkGradient;

  const _PageData({
    required this.icon,
    required this.companions,
    required this.title,
    required this.body,
    required this.gradient,
    required this.darkGradient,
  });
}

class _OnboardingPageView extends StatefulWidget {
  final _PageData data;

  const _OnboardingPageView({required this.data});

  @override
  State<_OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<_OnboardingPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -10).animate(
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Composed icon illustration with animations
          SizedBox(
            width: 200,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Companion icons with glass backgrounds and floating animations
                _FloatingCompanion(
                  icon: widget.data.companions[0],
                  offset: const Offset(-70, -30),
                  angle: -0.2,
                  delay: 0,
                  colors: colors,
                  cs: cs,
                ),
                _FloatingCompanion(
                  icon: widget.data.companions[1],
                  offset: const Offset(70, 20),
                  angle: 0.15,
                  delay: 1000,
                  colors: colors,
                  cs: cs,
                ),

                // Central icon with glow ring and floating animation
                AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.data.icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            widget.data.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.data.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FloatingCompanion extends StatefulWidget {
  final IconData icon;
  final Offset offset;
  final double angle;
  final int delay;
  final VitalGlyphColors colors;
  final ColorScheme cs;

  const _FloatingCompanion({
    required this.icon,
    required this.offset,
    required this.angle,
    required this.delay,
    required this.colors,
    required this.cs,
  });

  @override
  State<_FloatingCompanion> createState() => _FloatingCompanionState();
}

class _FloatingCompanionState extends State<_FloatingCompanion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });

    _animation = Tween<double>(begin: 0, end: -12).animate(
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: widget.offset + Offset(0, _animation.value),
          child: child,
        );
      },
      child: Transform.rotate(
        angle: widget.angle,
        child: GlassContainer(
          width: 56,
          height: 56,
          blurSigma: 10,
          backgroundColor: widget.colors.glassSurface.withValues(alpha: 0.8),
          borderColor: widget.colors.glassBorder,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Icon(
            widget.icon,
            size: 26,
            color: widget.cs.primary.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
