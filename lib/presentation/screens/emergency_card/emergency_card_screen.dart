import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/export_emergency_card.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';

class EmergencyCardScreen extends StatefulWidget {
  final Profile profile;
  final ExportEmergencyCard exportEmergencyCard;

  const EmergencyCardScreen({
    super.key,
    required this.profile,
    required this.exportEmergencyCard,
  });

  @override
  State<EmergencyCardScreen> createState() => _EmergencyCardScreenState();
}

class _EmergencyCardScreenState extends State<EmergencyCardScreen> {
  late Future<Uint8List> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _buildPdf();
  }

  Future<Uint8List> _buildPdf() async {
    final result = await widget.exportEmergencyCard(widget.profile);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (bytes) => bytes,
    );
  }

  String _pdfFileName() {
    final safeName = widget.profile.name
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .toLowerCase();
    return 'emergency_card_$safeName.pdf';
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(context.l10n.emergencyCardTitle(widget.profile.name)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<Uint8List>(
        future: _pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _LoadingSkeleton();
          }
          if (snapshot.hasError) {
            return _ErrorCard(
              message: snapshot.error.toString().replaceFirst('Exception: ', ''),
              onRetry: () => setState(() => _pdfFuture = _buildPdf()),
            );
          }
          final bytes = snapshot.data!;
          return PdfPreview(
            build: (_) async => bytes,
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            canChangeOrientation: false,
            pdfFileName: _pdfFileName(),
            initialPageFormat: PdfPageFormat(
              8.56 * PdfPageFormat.cm,
              5.398 * PdfPageFormat.cm,
            ),
          );
        },
      ),
    );
  }
}

class _LoadingSkeleton extends StatefulWidget {
  @override
  State<_LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<_LoadingSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            colors.glassBackground,
            colors.glassBackground.withValues(alpha: 0.2),
            colors.glassBackground,
          ],
          transform: _SlidingGradientTransform(_animation.value),
        );

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.emergencyCardGenerating,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              _SkeletonBlock(width: double.infinity, height: 32, gradient: gradient),
              const SizedBox(height: 16),
              _SkeletonBlock(width: 180, height: 20, gradient: gradient),
              const SizedBox(height: 32),
              _SkeletonBlock(width: double.infinity, height: 140, gradient: gradient),
              const SizedBox(height: 16),
              _SkeletonBlock(width: double.infinity, height: 100, gradient: gradient),
            ],
          ),
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

class _SkeletonBlock extends StatelessWidget {
  final double width;
  final double height;
  final Gradient gradient;

  const _SkeletonBlock({
    required this.width,
    required this.height,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    return GlassContainer(
      width: width,
      height: height,
      enableBlur: false,
      backgroundColor: colors.glassSurface.withValues(alpha: 0.3),
      borderColor: colors.glassBorder.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => gradient.createShader(bounds),
        child: Container(color: Colors.white),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassContainer(
          padding: const EdgeInsets.all(32),
          backgroundColor: colors.glassSurface,
          borderColor: colors.glassBorder,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 56, color: cs.error),
              const SizedBox(height: 24),
              Text(
                context.l10n.emergencyCardFailed,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.emergencyCardTryAgain),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
