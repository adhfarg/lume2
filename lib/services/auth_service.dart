import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  String? _userId;
  String? _userEmail;

  bool get isAuthenticated => _userId != null;

  String? get currentUserId => _userId;
  String? get currentUserEmail => _userEmail;

  Future<bool> signIn(String email, String password) async {
    // Demo login
    if (email == 'Adam' && password == '1127') {
      _userId = 'demo_user_id';
      _userEmail = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  void signOut() {
    _userId = null;
    _userEmail = null;
    notifyListeners();
  }
}
