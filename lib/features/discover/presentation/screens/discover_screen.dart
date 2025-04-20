import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../widgets/action_overlay.dart';
import '../widgets/profile_card.dart';
import '../../../../core/theme/app_theme.dart';
import 'dart:async';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String? _currentAction;
  final CardSwiperController _swiperController = CardSwiperController();
  
  // Add filter state variables
  RangeValues _ageRange = const RangeValues(18, 35);
  double _maxDistance = 50;
  String _selectedGender = 'All';

  // Add boost-related state variables
  bool _isBoostActive = false;
  int _remainingBoostSeconds = 0;
  Timer? _boostTimer;
  
  // Boost package options
  final List<Map<String, dynamic>> _boostPackages = [
    {
      'duration': 30,
      'price': 4.99,
      'description': '30 minutes boost',
      'multiplier': '5x',
    },
    {
      'duration': 60,
      'price': 8.99,
      'description': '1 hour boost',
      'multiplier': '8x',
      'popular': true,
    },
    {
      'duration': 120,
      'price': 14.99,
      'description': '2 hours boost',
      'multiplier': '10x',
    },
  ];

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

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Age Range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_ageRange.start.round()} - ${_ageRange.end.round()} years',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: _ageRange,
                min: 18,
                max: 100,
                divisions: 82,
                activeColor: AppTheme.primaryColor,
                labels: RangeLabels(
                  _ageRange.start.round().toString(),
                  _ageRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _ageRange = values;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Maximum Distance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_maxDistance.round()} km',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _maxDistance,
                min: 1,
                max: 100,
                divisions: 99,
                activeColor: AppTheme.primaryColor,
                label: '${_maxDistance.round()} km',
                onChanged: (double value) {
                  setState(() {
                    _maxDistance = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Show Me',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  'All',
                  'Women',
                  'Men',
                ].map((gender) => ChoiceChip(
                  label: Text(gender),
                  selected: _selectedGender == gender,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    }
                  },
                )).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Apply filters and close modal
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _boostTimer?.cancel();
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

  void _startBoostTimer(int durationInMinutes) {
    _remainingBoostSeconds = durationInMinutes * 60;
    _isBoostActive = true;
    _boostTimer?.cancel();
    
    _boostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingBoostSeconds > 0) {
          _remainingBoostSeconds--;
        } else {
          _isBoostActive = false;
          _boostTimer?.cancel();
        }
      });
    });
  }

  String _formatBoostTimeRemaining() {
    int minutes = _remainingBoostSeconds ~/ 60;
    int seconds = _remainingBoostSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _handleBoostPurchase(Map<String, dynamic> package) async {
    try {
      // TODO: Implement actual payment processing
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 2)); // Simulate payment processing
      
      Navigator.pop(context); // Close the boost modal
      _startBoostTimer(package['duration']);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your profile is now boosted for ${package['duration']} minutes!'),
          backgroundColor: Colors.purple,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to process payment. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBoostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Get a Boost',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flash_on,
                    color: Colors.purple,
                    size: 50,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Be seen by more people!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Get up to 10x more profile views and increase your chances of finding a match.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose Your Boost Package',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _boostPackages.length,
                  itemBuilder: (context, index) {
                    final package = _boostPackages[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: package['popular'] == true ? Colors.purple : Colors.grey.shade300,
                          width: package['popular'] == true ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _handleBoostPurchase(package),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.flash_on,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          package['description'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (package['popular'] == true) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.purple,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'POPULAR',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Up to ${package['multiplier']} more views',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${package['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            color: Colors.black87,
            onPressed: _showFilterModal,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.flash_on),
                color: _isBoostActive ? Colors.purple : Colors.black87,
                onPressed: _showBoostModal,
              ),
              if (_isBoostActive)
                Positioned(
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatBoostTimeRemaining(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
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