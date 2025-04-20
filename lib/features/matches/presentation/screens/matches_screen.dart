import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _mockMatches = [
    {
      'name': 'Sarah',
      'age': 24,
      'imageUrl': 'https://picsum.photos/200/300?random=1',
      'lastMessage': 'Hey, how are you?',
      'lastMessageTime': '2m ago',
      'unreadCount': 2,
      'isOnline': true,
    },
    {
      'name': 'Emma',
      'age': 22,
      'imageUrl': 'https://picsum.photos/200/300?random=2',
      'lastMessage': 'Would you like to meet for coffee?',
      'lastMessageTime': '1h ago',
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'name': 'Lisa',
      'age': 25,
      'imageUrl': 'https://picsum.photos/200/300?random=3',
      'lastMessage': 'That sounds great!',
      'lastMessageTime': '3h ago',
      'unreadCount': 1,
      'isOnline': true,
    },
    {
      'name': 'Anna',
      'age': 23,
      'imageUrl': 'https://picsum.photos/200/300?random=4',
      'lastMessageTime': 'Yesterday',
      'isNewMatch': true,
    },
    {
      'name': 'Julia',
      'age': 26,
      'imageUrl': 'https://picsum.photos/200/300?random=5',
      'lastMessageTime': 'Yesterday',
      'isNewMatch': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Matches',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Messages'),
            Tab(text: 'Matches'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesTab(),
          _buildMatchesTab(),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    final activeChats = _mockMatches.where((match) => match['lastMessage'] != null).toList();
    
    return activeChats.isEmpty
        ? const Center(
            child: Text(
              'No messages yet.\nStart a conversation with your matches!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          )
        : ListView.builder(
            itemCount: activeChats.length,
            itemBuilder: (context, index) {
              final match = activeChats[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(match['imageUrl']),
                    ),
                    if (match['isOnline'] == true)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  '${match['name']}, ${match['age']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  match['lastMessage'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      match['lastMessageTime'],
                      style: TextStyle(
                        color: match['unreadCount'] > 0 ? AppTheme.primaryColor : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    if (match['unreadCount'] > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          match['unreadCount'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () {
                  // Navigate to chat screen
                },
              );
            },
          );
  }

  Widget _buildMatchesTab() {
    final newMatches = _mockMatches.where((match) => match['isNewMatch'] == true).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (newMatches.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'New Matches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: newMatches.length,
              itemBuilder: (context, index) {
                final match = newMatches[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: AppTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                match['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'All Matches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _mockMatches.length,
            itemBuilder: (context, index) {
              final match = _mockMatches[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to chat or profile
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(match['imageUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${match['name']}, ${match['age']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (match['lastMessage'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            match['lastMessageTime'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 