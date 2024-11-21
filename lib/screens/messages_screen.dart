import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {
      'id': 'user1',
      'name': 'Alice',
      'lastMessage': 'Hey, how are you?',
      'time': '2m ago',
      'unread': true,
    },
    {
      'id': 'user2',
      'name': 'Bob',
      'lastMessage': 'Want to meet up?',
      'time': '1h ago',
      'unread': false,
    },
    {
      'id': 'user3',
      'name': 'Charlie',
      'lastMessage': 'That sounds great!',
      'time': '3h ago',
      'unread': true,
    },
    {
      'id': 'user4',
      'name': 'Diana',
      'lastMessage': 'See you tomorrow!',
      'time': '5h ago',
      'unread': false,
    },
    {
      'id': 'user5',
      'name': 'Ethan',
      'lastMessage': 'Thanks for the chat',
      'time': '1d ago',
      'unread': false,
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
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
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
            title: Row(
              children: [
                Text(
                  message['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  message['time'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              message['lastMessage'],
              style: TextStyle(
                color: message['unread'] ? Colors.black : Colors.grey,
                fontWeight:
                    message['unread'] ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            trailing: message['unread']
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8E6E1),
                    ),
                  )
                : null,
            onTap: () {
              // TODO: Implement chat screen navigation
            },
          );
        },
      ),
    );
  }
}
