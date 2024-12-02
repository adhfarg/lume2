import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class MatchingService extends ChangeNotifier {
  List<User> _demoUsers = [
    User(
      id: 'user1',
      name: 'Alice',
      email: 'alice@example.com',
      phoneNumber: '1234567890',
      lastBloodWorkDate: DateTime.now().subtract(Duration(days: 20)),
      isCertified: true,
      age: 28,
    ),
    User(
      id: 'user2',
      name: 'Bob',
      email: 'bob@example.com',
      phoneNumber: '2345678901',
      lastBloodWorkDate: DateTime.now().subtract(Duration(days: 15)),
      isCertified: true,
      age: 32,
    ),
    User(
      id: 'user3',
      name: 'Charlie',
      email: 'charlie@example.com',
      phoneNumber: '3456789012',
      lastBloodWorkDate: DateTime.now().subtract(Duration(days: 40)),
      isCertified: false,
      age: 25,
    ),
    User(
      id: 'user4',
      name: 'Diana',
      email: 'diana@example.com',
      phoneNumber: '4567890123',
      lastBloodWorkDate: DateTime.now().subtract(Duration(days: 10)),
      isCertified: true,
      age: 30,
    ),
    User(
      id: 'user5',
      name: 'Ethan',
      email: 'ethan@example.com',
      phoneNumber: '5678901234',
      lastBloodWorkDate: DateTime.now().subtract(Duration(days: 25)),
      isCertified: true,
      age: 27,
    ),
  ];

  List<User> get demoUsers => _demoUsers;

  Future<List<User>> getPotentialMatches() async {
    // Simulating a short delay
    await Future.delayed(Duration(milliseconds: 500));
    return _demoUsers;
  }

  void updateUser(User updatedUser) {
    final index = _demoUsers.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _demoUsers[index] = updatedUser;
      notifyListeners();
    }
  }

  void removeUser(String userId) {
    _demoUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
  }
}
