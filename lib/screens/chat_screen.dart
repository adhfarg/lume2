import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;

  ChatScreen({required this.userId, required this.userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'senderId': 'user1',
      'message': 'Hey, how are you?',
      'timestamp': '2:30 PM',
      'isMe': false,
    },
    {
      'senderId': 'currentUser',
      'message': 'I\'m good! How about you?',
      'timestamp': '2:31 PM',
      'isMe': true,
    },
    {
      'senderId': 'user1',
      'message': 'Doing great! Want to meet up later?',
      'timestamp': '2:32 PM',
      'isMe': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFE8E6E1),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/${widget.userId}.jpg',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 16,
                      left: message['isMe'] ? 64 : 0,
                      right: message['isMe'] ? 0 : 64,
                    ),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message['isMe'] ? Color(0xFFE8E6E1) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: message['isMe']
                          ? null
                          : Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          message['timestamp'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'senderId': 'currentUser',
                          'message': _messageController.text,
                          'timestamp':
                              '${DateTime.now().hour}:${DateTime.now().minute}',
                          'isMe': true,
                        });
                      });
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
