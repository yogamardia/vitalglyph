import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/core/services/app_preferences.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/injection.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _PageData(
      icon: Icons.medical_information_outlined,
      companions: [Icons.water_drop_outlined, Icons.medication_outlined],
      title: 'Your Medical ID, Always Ready',
      body:
          'Store your critical medical information — blood type, allergies, medications, and emergency contacts — in one secure place.',
    ),
    _PageData(
      icon: Icons.qr_code_scanner_outlined,
      companions: [Icons.phone_android_outlined, Icons.local_hospital_outlined],
      title: 'Instant Access via QR Code',
      body:
          'First responders can scan your QR code to access your medical information in seconds, even without internet.',
    ),
    _PageData(
      icon: Icons.shield_outlined,
      companions: [Icons.lock_outline_rounded, Icons.wifi_off_outlined],
      title: 'Private & Offline by Design',
      body:
          'All data stays on your device. Nothing is sent to servers. You control who sees your information.',
    ),
  ];

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
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
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
                    'Skip',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) {
                  HapticFeedback.selectionClick();
                  setState(() => _currentPage = i);
                },
                itemBuilder: (context, i) => _OnboardingPageView(data: _pages[i]),
              ),
            ),

            // Thinner pill page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == i ? 32 : 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: SizedBox(
                width: double.infinity,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLast
                      ? FilledButton(
                          key: const ValueKey('get_started'),
                          onPressed: _finish,
                          child: const Text('Get Started'),
                        )
                      : FilledButton(
                          key: const ValueKey('next'),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          child: const Text('Next'),
                        ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final List<IconData> companions;
  final String title;
  final String body;

  const _PageData({
    required this.icon,
    required this.companions,
    required this.title,
    required this.body,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final _PageData data;

  const _OnboardingPageView({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Composed icon illustration
          SizedBox(
            width: 160,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Companion icons at angles
                Positioned(
                  left: 0,
                  top: 12,
                  child: _CompanionIcon(
                    icon: data.companions[0],
                    color: colorScheme.primaryContainer,
                    iconColor: colorScheme.primary.withValues(alpha: 0.6),
                    angle: -0.3,
                    size: 52,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 20,
                  child: _CompanionIcon(
                    icon: data.companions[1],
                    color: colorScheme.secondaryContainer,
                    iconColor: colorScheme.secondary.withValues(alpha: 0.6),
                    angle: 0.2,
                    size: 48,
                  ),
                ),
                // Central icon
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    size: 44,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            data.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompanionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final double angle;
  final double size;

  const _CompanionIcon({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.angle,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, size: size * 0.45, color: iconColor),
      ),
    );
  }
}
