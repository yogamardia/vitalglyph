import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';

/// A Scaffold wrapper with a gradient background.
class GradientScaffold extends StatelessWidget {

  const GradientScaffold({
    required this.body, super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.gradientStart,
                  colors.gradientEnd,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          SafeArea(
            top: !extendBodyBehindAppBar,
            child: body,
          ),
        ],
      ),
    );
  }
}
