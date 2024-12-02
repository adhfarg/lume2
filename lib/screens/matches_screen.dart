import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/matching_service.dart';
import '../models/user_model.dart';

class MatchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final matchingService =
        Provider.of<MatchingService>(context, listen: false);

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
      body: FutureBuilder<List<User>>(
        future: matchingService.getPotentialMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No matches found'));
          }

          final matches = snapshot.data!;

          return GridView.builder(
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                'assets/images/${match.id}.jpg',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${match.name}, ${match.age}',
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
                                              color: match.isCertified
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            match.isCertified
                                                ? 'Certified'
                                                : 'Not Certified',
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
                                      onTap: () =>
                                          _removeMatch(context, match.id),
                                      icon: Icons.close,
                                      backgroundColor:
                                          Colors.red.withOpacity(0.1),
                                      iconColor: Colors.red,
                                    ),
                                    SizedBox(width: 4),
                                    _buildActionButton(
                                      onTap: () =>
                                          _confirmMatch(context, match.id),
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

  void _removeMatch(BuildContext context, String id) {
    // TODO: Implement remove match logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed match with ID: $id')),
    );
  }

  void _confirmMatch(BuildContext context, String id) {
    // TODO: Implement confirm match logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Confirmed match with ID: $id')),
    );
  }
}
