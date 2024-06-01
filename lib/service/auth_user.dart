import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class AuthUser extends ChangeNotifier {
  bool _isAuthenticated = false;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    var box = Hive.box<User>('users');
    User? user;
    try {
      user = box.values.firstWhere(
            (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      user = null;
    }

    if (user != null) {
      _isAuthenticated = true;
      _currentUser = user;
    } else {
      _isAuthenticated = false;
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> register(String username, String email, String password, String noHp) async {
    var box = Hive.box<User>('users');
    User user = User(username: username, email: email, password: password, noHp: noHp);
    await box.add(user);
    _isAuthenticated = true;
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
