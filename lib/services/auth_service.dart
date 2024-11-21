import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;

  User({required this.uid, this.email, this.phoneNumber, this.displayName});
}

class AuthService with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<void> signIn(String email, String password) async {
    // TODO: Implement actual authentication logic
    // For now, we'll just simulate a successful login
    _currentUser = User(
      uid: '123',
      email: email,
      displayName: 'John Doe',
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    // TODO: Implement actual sign out logic
    _currentUser = null;
    notifyListeners();
  }
}
