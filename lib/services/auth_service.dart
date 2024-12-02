import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final GoTrueClient _auth = Supabase.instance.client.auth;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthService() {
    _auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        _isAuthenticated = true;
        notifyListeners();
      } else if (event == AuthChangeEvent.signedOut) {
        _isAuthenticated = false;
        notifyListeners();
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (error) {
      print('Error signing in: $error');
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (error) {
      print('Error signing up: $error');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _isAuthenticated = false;
      notifyListeners();
    } catch (error) {
      print('Error signing out: $error');
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;
}
