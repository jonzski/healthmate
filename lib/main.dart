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
      initialRoute: '/LoginPage',
      routes: {
        '/LoginPage': (context) => const LoginPage(),
      },
    );
  }
}
