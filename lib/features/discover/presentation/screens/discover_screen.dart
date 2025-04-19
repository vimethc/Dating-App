import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../widgets/action_overlay.dart';
import '../widgets/profile_card.dart';
import '../../../../core/theme/app_theme.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String? _currentAction;
  final CardSwiperController _swiperController = CardSwiperController();

  final List<Map<String, dynamic>> _mockProfiles = [
    {
      'name': 'Elisa',
      'age': 20,
      'imageUrl': 'https://picsum.photos/400/600?random=1',
      'tags': [
        {'icon': Icons.interests, 'label': 'Films'},
        {'icon': Icons.sports, 'label': 'Sports'},
      ],
      'bio': 'Prinzessin',
    },
    {
      'name': 'Sarah',
      'age': 24,
      'imageUrl': 'https://picsum.photos/400/600?random=2',
      'tags': [
        {'icon': Icons.music_note, 'label': 'Music lover'},
        {'icon': Icons.pets, 'label': 'Dog person'},
        {'icon': Icons.restaurant, 'label': 'Foodie'},
      ],
      'bio': 'Adventure seeker',
    },
    {
      'name': 'Emma',
      'age': 22,
      'imageUrl': 'https://picsum.photos/400/600?random=3',
      'tags': [
        {'icon': Icons.brush, 'label': 'Artist'},
        {'icon': Icons.coffee, 'label': 'Coffee addict'},
        {'icon': Icons.travel_explore, 'label': 'Love to travel'},
      ],
      'bio': 'Creative soul',
    },
    {
      'name': 'Sophie',
      'age': 25,
      'imageUrl': 'https://picsum.photos/400/600?random=4',
      'tags': [
        {'icon': Icons.sports_tennis, 'label': 'Tennis player'},
        {'icon': Icons.book, 'label': 'Bookworm'},
        {'icon': Icons.beach_access, 'label': 'Beach lover'},
      ],
      'bio': 'Living life to the fullest',
    },
  ];

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  void _showActionOverlay(String action) {
    setState(() => _currentAction = action);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _currentAction = null);
      }
    });
  }

  void _handleLike() {
    _showActionOverlay('like');
    _swiperController.swipeRight();
  }

  void _handleDislike() {
    _showActionOverlay('dislike');
    _swiperController.swipeLeft();
  }

  void _handleSuperLike() {
    _showActionOverlay('superlike');
    _swiperController.swipeTop();
  }

  void _handleRewind() {
    _swiperController.undo();
  }

  void _handleMessage() {
    // Handle message logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            color: Colors.black,
            onPressed: () {
              // Handle settings
            },
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            color: Colors.purple,
            onPressed: () {
              // Handle boost
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CardSwiper(
                  controller: _swiperController,
                  cardsCount: _mockProfiles.length,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    switch (direction) {
                      case CardSwiperDirection.right:
                        _showActionOverlay('like');
                        break;
                      case CardSwiperDirection.left:
                        _showActionOverlay('dislike');
                        break;
                      case CardSwiperDirection.top:
                        _showActionOverlay('superlike');
                        break;
                      default:
                        break;
                    }
                    return true;
                  },
                  cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) => ProfileCard(
                    profile: _mockProfiles[index],
                  ),
                ),
                if (_currentAction != null)
                  ActionOverlay(
                    action: _currentAction!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 