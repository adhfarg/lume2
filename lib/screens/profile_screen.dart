import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'health_certification_screen.dart';

class ProfileScreen extends StatelessWidget {
  final sandColor = Color(0xFFE8E6E1);
  final sandColorLight = Color(0xFFF5F3F0);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: sandColorLight,
              child: Icon(
                Icons.person,
                size: 50,
                color: Color(0xFFE8E6E1),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Adam',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.health_and_safety, color: Colors.deepPurple),
              title: Text('Health Certification'),
              subtitle: Text('Manage your health verification'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthCertificationScreen(),
                  ),
                );
              },
            ),
            Divider(color: sandColor),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text('Settings'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement settings screen
              },
            ),
            Divider(color: sandColor),
            ListTile(
              leading: Icon(Icons.help, color: Colors.blue),
              title: Text('Help & Support'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement help & support
              },
            ),
            Divider(color: sandColor),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
