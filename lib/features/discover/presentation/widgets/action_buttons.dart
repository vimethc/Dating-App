import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ActionButtons extends StatefulWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;

  const ActionButtons({
    super.key,
    required this.onLike,
    required this.onDislike,
    required this.onSuperLike,
  });

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String? _activeButton;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleButtonPress(String button, VoidCallback action) {
    setState(() => _activeButton = button);
    _animationController.forward().then((_) {
      action();
      _animationController.reverse().then((_) {
        setState(() => _activeButton = null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            'dislike',
            Icons.close,
            Colors.red,
            60,
            widget.onDislike,
          ),
          _buildActionButton(
            'superlike',
            Icons.star,
            Colors.blue,
            45,
            widget.onSuperLike,
          ),
          _buildActionButton(
            'like',
            Icons.favorite,
            AppTheme.primaryColor,
            60,
            widget.onLike,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String id,
    IconData icon,
    Color color,
    double size,
    VoidCallback onTap,
  ) {
    final bool isActive = _activeButton == id;
    final Animation<double> scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: isActive ? scaleAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleButtonPress(id, onTap),
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(size * 0.25),
                  child: Icon(
                    icon,
                    size: size * 0.5,
                    color: isActive ? color.withOpacity(0.8) : color,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 