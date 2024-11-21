import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_swiper/card_swiper.dart';
import '../services/auth_service.dart';
import '../services/matching_service.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';
import 'health_certification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final SwiperController _swiperController = SwiperController();

  Widget _buildProfileCard(User user) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/${user.id}.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${user.name}, ${user.age}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  if (user.isCertified)
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.verified, color: Colors.blue, size: 24),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Health Certified',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            onTap: () => _swiperController.previous(),
            icon: Icons.refresh,
            color: Colors.amber,
          ),
          _buildActionButton(
            onTap: () => _swiperController.next(animation: true),
            icon: Icons.close,
            color: Colors.red,
            size: 35,
          ),
          _buildActionButton(
            onTap: () {},
            icon: Icons.star,
            color: Colors.blue,
          ),
          _buildActionButton(
            onTap: () => _swiperController.next(animation: true),
            icon: Icons.favorite,
            color: Colors.green,
            size: 35,
          ),
          _buildActionButton(
            onTap: () {},
            icon: Icons.flash_on,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
    double size = 25,
  }) {
    return Container(
      width: size * 2,
      height: size * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: size, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final matchingService = Provider.of<MatchingService>(context);

    final List<Widget> screens = [
      Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: FutureBuilder<List<User>>(
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
                  return Swiper(
                    controller: _swiperController,
                    itemBuilder: (context, index) =>
                        _buildProfileCard(snapshot.data![index]),
                    itemCount: snapshot.data!.length,
                    itemWidth: MediaQuery.of(context).size.width * 0.9,
                    itemHeight: MediaQuery.of(context).size.height * 0.7,
                    layout: SwiperLayout.STACK,
                  );
                },
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
      Center(child: Text('Matches Screen')),
      Center(child: Text('Messages Screen')),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/Lumé.png',
          height: 40,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.health_and_safety,
                  color: Colors.deepPurple, size: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HealthCertificationScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => setState(() => _currentIndex = 3),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Matches'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }
}
