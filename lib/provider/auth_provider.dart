import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;

  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;
  User get currentUser => authService.currentUser;

  void fetchAuthentication() {
    uStream = authService.getUser;

    notifyListeners();
  }

  Future<void> signUp(String email, String password, int userType, String name,
      Map<String, dynamic> userInfo) async {
    await authService.signUp(email, password, userType, name, userInfo);
    notifyListeners();
  }

  Future<UserCredential?> signIn(
      String email, String password, int userType) async {
    UserCredential? credential =
        await authService.signIn(email, password, userType);
    notifyListeners();
    return credential;
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}
