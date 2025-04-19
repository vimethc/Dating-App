import 'package:flutter/material.dart';

class ActionOverlay extends StatelessWidget {
  final String action;

  const ActionOverlay({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    double rotation;

    switch (action.toLowerCase()) {
      case 'like':
        text = 'LIKE';
        color = const Color(0xFF2ECC71); // Green color
        rotation = -0.4; // Rotate counter-clockwise
        break;
      case 'dislike':
        text = 'NOPE';
        color = const Color(0xFFFF4D4F); // Red color
        rotation = 0.4; // Rotate clockwise
        break;
      case 'superlike':
        text = 'SUPER\nLIKE';
        color = const Color(0xFF47A6FF); // Blue color
        rotation = 0.0;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Transform.rotate(
          angle: rotation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                // Shadow text for 3D effect
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 8
                      ..color = Colors.black.withOpacity(0.2),
                  ),
                ),
                // Main text
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: color,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: color.withOpacity(0.3),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 