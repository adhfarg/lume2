import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {
      'id': 'user1',
      'name': 'Alice',
      'lastMessage': 'Hey, how are you?',
      'time': '2m ago',
      'unread': true,
      'isOnline': true,
    },
    {
      'id': 'user2',
      'name': 'Bob',
      'lastMessage': 'Want to meet up?',
      'time': '1h ago',
      'unread': false,
      'isOnline': false,
    },
    {
      'id': 'user3',
      'name': 'Charlie',
      'lastMessage': 'That sounds great!',
      'time': '3h ago',
      'unread': true,
      'isOnline': true,
    },
    {
      'id': 'user4',
      'name': 'Diana',
      'lastMessage': 'See you tomorrow!',
      'time': '5h ago',
      'unread': false,
      'isOnline': false,
    },
    {
      'id': 'user5',
      'name': 'Ethan',
      'lastMessage': 'Thanks for the chat',
      'time': '1d ago',
      'unread': false,
      'isOnline': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    userId: message['id'],
                    userName: message['name'],
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFE8E6E1),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/${message['id']}.jpg',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (message['isOnline'])
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
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              message['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              message['time'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          message['lastMessage'],
                          style: TextStyle(
                            color:
                                message['unread'] ? Colors.black : Colors.grey,
                            fontWeight: message['unread']
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
