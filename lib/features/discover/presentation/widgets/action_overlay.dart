import 'package:flutter/material.dart';

class ActionOverlay extends StatelessWidget {
  final String action;

  const ActionOverlay({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String text;

    switch (action.toLowerCase()) {
      case 'like':
        icon = Icons.favorite;
        color = Colors.green;
        text = 'LIKE';
        break;
      case 'dislike':
        icon = Icons.close;
        color = Colors.red;
        text = 'NOPE';
        break;
      case 'superlike':
        icon = Icons.star;
        color = Colors.blue;
        text = 'SUPER LIKE';
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
        text = 'UNKNOWN';
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 