import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> match;

  const ChatScreen({
    super.key,
    required this.match,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  
  // Mock messages for demonstration
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hey there! 👋',
      'isMe': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
    },
    {
      'text': 'Hi! How are you?',
      'isMe': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
    },
    {
      'text': 'I\'m good! Would you like to grab coffee sometime?',
      'isMe': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isRead': true,
    },
    {
      'text': 'That sounds great! When are you free?',
      'isMe': true,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isRead': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isMe': true,
        'timestamp': DateTime.now(),
        'isRead': false,
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showOptionsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Report User'),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete Chat',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User?'),
        content: Text(
          'Are you sure you want to block ${widget.match['name']}? You won\'t receive their messages anymore.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement block functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.match['name']} has been blocked'),
                ),
              );
              Navigator.pop(context); // Return to matches screen
            },
            child: const Text(
              'BLOCK',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why are you reporting this user?'),
            const SizedBox(height: 16),
            ...['Inappropriate Content', 'Harassment', 'Spam', 'Fake Profile', 'Other']
                .map((reason) => InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thank you for your report. We\'ll review it shortly.'),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(reason),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat?'),
        content: const Text(
          'Are you sure you want to delete this chat? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat deleted'),
                ),
              );
              Navigator.pop(context); // Return to matches screen
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.match['imageUrl']),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.match['name'],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isTyping)
                  const Text(
                    'typing...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: _showOptionsModal,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Implement loading more messages
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['isMe'] as bool;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: isMe 
                          ? MainAxisAlignment.end 
                          : MainAxisAlignment.start,
                      children: [
                        if (!isMe) ...[
                          CircleAvatar(
                            backgroundImage: NetworkImage(widget.match['imageUrl']),
                            radius: 16,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Column(
                          crossAxisAlignment: isMe 
                              ? CrossAxisAlignment.end 
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isMe 
                                    ? const Color(0xFF6C5CE7)  // Updated to match the screenshot
                                    : const Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(isMe ? 20 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 20),
                                ),
                              ),
                              child: Text(
                                message['text'] as String,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTimestamp(message['timestamp'] as DateTime),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    message['isRead'] as bool
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: 16,
                                    color: message['isRead'] as bool
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_outlined),
                    color: Colors.grey,
                    onPressed: () {
                      // Handle attachment
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _isTyping = value.isNotEmpty);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF6C5CE7),
                    ),
                    onPressed: _handleSendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 