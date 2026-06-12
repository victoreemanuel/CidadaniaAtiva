import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool dark;
  final double opacity;

  const AppBackground({
    super.key,
    required this.child,
    this.dark = true,
    this.opacity = 0.48,
  });

  @override
  Widget build(BuildContext context) {
    final Color overlayColor = dark
        ? Colors.black.withOpacity(opacity)
        : Colors.white.withOpacity(opacity);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/catedral.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        Container(color: overlayColor),
        child,
      ],
    );
  }
}
