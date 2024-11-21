import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchesScreen extends StatefulWidget {
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<Map<String, dynamic>> matches = [
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

  void _removeMatch(String id) {
    setState(() {
      matches.removeWhere((match) => match['id'] == id);
      // TODO: Also remove corresponding messages
    });
  }

  void _confirmMatch(String id) {
    // TODO: Implement confirmation logic
  }

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
        padding: EdgeInsets.fromLTRB(12, 12, 12, 80),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: 1.0,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            'assets/images/${match['id']}.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildActionButton(
                                  onTap: () => _removeMatch(match['id']),
                                  icon: Icons.close,
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  iconColor: Colors.red,
                                ),
                                SizedBox(width: 4),
                                _buildActionButton(
                                  onTap: () => _confirmMatch(match['id']),
                                  icon: Icons.favorite,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.1),
                                  iconColor: Colors.green,
                                ),
                              ],
                            ),
                          ],
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

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
      ),
    );
  }
}
