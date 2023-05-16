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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/UserDashboard': (context) => const UserDashboard(),
        '/AddEntry': (context) => const AddEntry(),
      },
    );
  }
}
