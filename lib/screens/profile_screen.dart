import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/auth_service.dart';
import 'health_certification_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final sandColor = Color(0xFFE8E6E1);
  final sandColorLight = Color(0xFFF5F3F0);
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  bool _isUpdatingProfile = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();

      setState(() {
        _userProfile = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfileImage() async {
    try {
      setState(() => _isUpdatingProfile = true);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image == null) {
        setState(() => _isUpdatingProfile = false);
        return;
      }

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Upload the file with a unique name
      final fileName =
          'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.${image.path.split('.').last}';
      final file = File(image.path);

      await _supabase.storage.from('avatars').upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get the public URL
      final avatarUrl =
          _supabase.storage.from('avatars').getPublicUrl(fileName);

      // Update the profile
      await _supabase.from('profiles').update({
        'avatar_url': avatarUrl,
      }).eq('id', userId);

      await _loadUserProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated successfully')),
      );
    } catch (e) {
      print('Error updating profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile picture. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUpdatingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = provider.Provider.of<AuthService>(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (_isUpdatingProfile)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: sandColorLight,
                    child: CircularProgressIndicator(),
                  )
                else
                  GestureDetector(
                    onTap: _updateProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: sandColorLight,
                      backgroundImage: _userProfile?['avatar_url'] != null
                          ? NetworkImage(_userProfile!['avatar_url'])
                          : AssetImage('assets/images/user1.jpg')
                              as ImageProvider,
                    ),
                  ),
                if (!_isUpdatingProfile)
                  Positioned(
                    bottom: 0,
                    right: 135,
                    child: GestureDetector(
                      onTap: _updateProfileImage,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Icon(Icons.camera_alt,
                            size: 20, color: Colors.grey[600]),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              _userProfile?['full_name'] ?? 'Adam',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
            Divider(color: sandColor),
            ListTile(
              leading: Icon(Icons.help, color: Colors.blue),
              title: Text('Help & Support'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpSupportScreen(),
                  ),
                );
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
