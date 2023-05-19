import 'package:flutter/material.dart';
import './screens/LoginPage.dart';
import './screens/SignupPage.dart';
import './screens/UserDashboard.dart';
import './screens/Profile.dart';
import './screens/AddEntry.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routing',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/Signup': (context) => const SignupPage(),
        '/UserDashboard': (context) => const UserDashboard(),
        '/AddEntry': (context) => const AddEntry(),
        '/Profile': (context) => const Profile()
      },
    );
  }
}
