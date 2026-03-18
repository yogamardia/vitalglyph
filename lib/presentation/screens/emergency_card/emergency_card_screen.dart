import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/export_emergency_card.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.profile.name} — Emergency Card'),
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

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                const SizedBox(height: 16),
                Text(
                  'Generating emergency card…',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Skeleton shimmer blocks matching card layout
          _SkeletonBlock(width: double.infinity, height: 24),
          const SizedBox(height: 12),
          _SkeletonBlock(width: 160, height: 16),
          const SizedBox(height: 24),
          _SkeletonBlock(width: double.infinity, height: 120),
          const SizedBox(height: 12),
          _SkeletonBlock(width: double.infinity, height: 80),
        ],
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonBlock({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
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
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: cs.error),
                const SizedBox(height: 16),
                Text(
                  'Failed to generate emergency card',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.outline),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
