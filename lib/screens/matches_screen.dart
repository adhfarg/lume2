import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> matches = [
    {
      'id': 'user1',
      'name': 'Alice',
      'age': 28,
      'lastSeen': 'Online',
    },
    {
      'id': 'user2',
      'name': 'Bob',
      'age': 32,
      'lastSeen': '2h ago',
    },
    {
      'id': 'user3',
      'name': 'Charlie',
      'age': 25,
      'lastSeen': '1h ago',
    },
    {
      'id': 'user4',
      'name': 'Diana',
      'age': 30,
      'lastSeen': 'Online',
    },
    {
      'id': 'user5',
      'name': 'Ethan',
      'age': 27,
      'lastSeen': '30m ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Matches',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(
            12, 12, 12, 80), // Increased bottom padding to avoid overflow
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75, // Adjusted for better fit
          crossAxisSpacing: 12, // Reduced spacing
          mainAxisSpacing: 12, // Reduced spacing
        ),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      'assets/images/${match['id']}.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${match['name']}, ${match['age']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: match['lastSeen'] == 'Online'
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            match['lastSeen'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
