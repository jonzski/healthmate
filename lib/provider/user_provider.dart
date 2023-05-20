import 'package:flutter/material.dart';
import '../model/test.dart';

class UserProvider with ChangeNotifier {
  // Create User Class
  User _user = User(name: "JR", email: "JR@gmail.com", password: "1234");

  User get user => _user;

  // Update User Class
  set updateUser(User user) {
    _user = user;
    notifyListeners();
  }
}
