import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  // Mock messages data with grouping
  final Map<String, List<Map<String, dynamic>>> _groupedMessages = {
    'Today': [
      {
        'id': '1',
        'name': 'Sarah',
        'age': 24,
        'imageUrl': 'https://picsum.photos/400/600?random=1',
        'lastMessage': 'Hey, how are you?',
        'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 2)),
        'unreadCount': 2,
        'isOnline': true,
        'typing': false,
        'isArchived': false,
        'isMuted': false,
      },
      {
        'id': '2',
        'name': 'Emma',
        'age': 22,
        'imageUrl': 'https://picsum.photos/400/600?random=2',
        'lastMessage': 'Would you like to meet for coffee?',
        'lastMessageTime': DateTime.now().subtract(const Duration(hours: 1)),
        'unreadCount': 0,
        'isOnline': false,
        'typing': true,
        'isArchived': false,
        'isMuted': false,
      },
    ],
    'Yesterday': [
      {
        'id': '3',
        'name': 'Lisa',
        'age': 25,
        'imageUrl': 'https://picsum.photos/400/600?random=3',
        'lastMessage': 'That sounds great!',
        'lastMessageTime': DateTime.now().subtract(const Duration(hours: 25)),
        'unreadCount': 1,
        'isOnline': true,
        'typing': false,
        'isArchived': false,
        'isMuted': true,
      },
    ],
    'This Week': [
      {
        'id': '4',
        'name': 'Jessica',
        'age': 23,
        'imageUrl': 'https://picsum.photos/400/600?random=4',
        'lastMessage': 'Looking forward to our date!',
        'lastMessageTime': DateTime.now().subtract(const Duration(days: 3)),
        'unreadCount': 0,
        'isOnline': false,
        'typing': false,
        'isArchived': false,
        'isMuted': false,
      },
    ],
    'Archived': [],
  };

  List<MapEntry<String, List<Map<String, dynamic>>>> get _filteredGroups {
    if (_searchQuery.isEmpty) {
      return _groupedMessages.entries.where((group) {
        return group.value.isNotEmpty;
      }).toList();
    }
    
    Map<String, List<Map<String, dynamic>>> filtered = {};
    _groupedMessages.forEach((key, messages) {
      final filteredMessages = messages.where((message) {
        return message['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
      if (filteredMessages.isNotEmpty) {
        filtered[key] = filteredMessages;
      }
    });
    return filtered.entries.toList();
  }

  // Helper method to determine which group a message belongs to
  String _getMessageGroup(DateTime messageTime) {
    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inHours < 24) {
      return 'Today';
    } else if (difference.inHours < 48) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return 'This Week';
    } else {
      return 'This Week'; // Default to This Week for older messages
    }
  }

  void _handleArchive(Map<String, dynamic> message, String currentGroup) {
    setState(() {
      // Remove from current group
      _groupedMessages[currentGroup]!.removeWhere((m) => m['id'] == message['id']);
      
      // Update message status
      message['isArchived'] = true;
      
      // Add to archived group
      _groupedMessages['Archived']!.insert(0, message);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => _handleUnarchive(message),
        ),
      ),
    );
  }

  void _handleUnarchive(Map<String, dynamic> message) {
    setState(() {
      // Remove from archived group
      _groupedMessages['Archived']!.removeWhere((m) => m['id'] == message['id']);
      
      // Update message status
      message['isArchived'] = false;
      
      // Determine the appropriate group based on message time
      final group = _getMessageGroup(message['lastMessageTime']);
      
      // Add to appropriate group
      _groupedMessages[group]!.insert(0, message);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message unarchived')),
    );
  }

  void _handleDelete(Map<String, dynamic> message, String currentGroup) {
    setState(() {
      _groupedMessages[currentGroup]!.removeWhere((m) => m['id'] == message['id']);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _groupedMessages[currentGroup]!.insert(0, message);
            });
          },
        ),
      ),
    );
  }

  void _handleMute(Map<String, dynamic> message) {
    setState(() {
      message['isMuted'] = !message['isMuted'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message['isMuted'] ? 'Conversation muted' : 'Conversation unmuted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              message['isMuted'] = !message['isMuted'];
            });
          },
        ),
      ),
    );
  }

  String _getTimeString(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontSize: 20,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              )
            : const Text(
                'Messages',
                style: TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: _filteredGroups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start matching to begin conversations',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredGroups.length,
              itemBuilder: (context, groupIndex) {
                final group = _filteredGroups[groupIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            group.key,
                            style: const TextStyle(
                              color: Color(0xFF6C5CE7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (group.key == 'Archived')
                            Text(
                              ' (${group.value.length})',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ...group.value.map((message) => Slidable(
                      key: ValueKey(message['id']),
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          if (message['isArchived'])
                            SlidableAction(
                              onPressed: (_) => _handleUnarchive(message),
                              backgroundColor: const Color(0xFF6C5CE7),
                              foregroundColor: Colors.white,
                              icon: Icons.unarchive,
                              label: 'Unarchive',
                            )
                          else
                            SlidableAction(
                              onPressed: (_) => _handleArchive(message, group.key),
                              backgroundColor: const Color(0xFF6C5CE7),
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: 'Archive',
                            ),
                          SlidableAction(
                            onPressed: (_) => _handleMute(message),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            icon: message['isMuted'] ? Icons.volume_up : Icons.volume_off,
                            label: message['isMuted'] ? 'Unmute' : 'Mute',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _handleDelete(message, group.key),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(match: message),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: message['unreadCount'] > 0
                                          ? Border.all(
                                              color: const Color(0xFF6C5CE7),
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        message['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (message['isOnline'])
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 16,
                                        height: 16,
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
                                  if (message['isMuted'])
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.volume_off,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${message['name']}, ${message['age']}',
                                          style: TextStyle(
                                            fontWeight: message['unreadCount'] > 0
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          _getTimeString(message['lastMessageTime']),
                                          style: TextStyle(
                                            color: message['unreadCount'] > 0
                                                ? const Color(0xFF6C5CE7)
                                                : Colors.grey.shade600,
                                            fontSize: 12,
                                            fontWeight: message['unreadCount'] > 0
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: message['typing']
                                              ? Row(
                                                  children: [
                                                    const Text(
                                                      'typing',
                                                      style: TextStyle(
                                                        color: Color(0xFF6C5CE7),
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    _buildTypingIndicator(),
                                                  ],
                                                )
                                              : Text(
                                                  message['lastMessage'],
                                                  style: TextStyle(
                                                    color: message['unreadCount'] > 0
                                                        ? Colors.black87
                                                        : Colors.grey.shade600,
                                                    fontWeight: message['unreadCount'] > 0
                                                        ? FontWeight.w500
                                                        : FontWeight.normal,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                        ),
                                        if (message['unreadCount'] > 0) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF6C5CE7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              message['unreadCount'].toString(),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildTypingIndicator() {
    return SizedBox(
      width: 20,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (index) => _buildDot(index),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(
              (value + index / 3) % 1,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
} 