import 'package:cmsc_23_project/screens/Profile.dart';
import 'package:flutter/material.dart';
import './screens/LoginPage.dart';
import './screens/UserDashboard.dart';
import './screens/AddEntry.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routing',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/UserDashboard': (context) => const UserDashboard(),
        '/AddEntry': (context) => const AddEntry(),
        '/Profile': (context) => const Profile()
      },
    );
  }
}
