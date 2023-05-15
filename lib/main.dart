import 'package:cmsc_23_project/screens/AddEntry.dart';
import 'package:cmsc_23_project/screens/UserDashboard.dart';
import 'package:flutter/material.dart';
import './screens/LoginPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routing',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/UserDashboard': (context) => const UserDashboard(),
        '/AddEntry': (context) => const AddEntry(),
      },
    );
  }
}
