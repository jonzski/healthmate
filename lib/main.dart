import 'package:cmsc_23_project/screens/UserEntries.dart';
import 'package:flutter/material.dart';
import './screens/LoginPage.dart';
import './screens/SignupPage.dart';
import './screens/UserDashboard.dart';
import './screens/Profile.dart';
import './screens/AddEntry.dart';
import 'screens/EditEntry.dart';

import './screens/SwitchUserType.dart';

import './screens/admin/AdminDashboard.dart';
import './screens/admin/AdminSignInPage.dart';
import './screens/admin/AdminSignUpPage.dart';

import './screens/monitor/MonitorDashboard.dart';
import './screens/monitor/MonitorSignInPage.dart';
import './screens/monitor/MonitorSignUpPage.dart';

import './provider/auth_provider.dart';
import './provider/entry_provider.dart';
import './provider/user_provider.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => EntryProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => UserProvider())),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routing',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/': (context) => const UserDashboard(),
        '/add-entry': (context) => const AddEntry(),
        '/edit-entry': (context) => const EditEntry(),
        '/user-entries': (context) => const UserEntries(),
        '/profile': (context) => const Profile(),
        '/switch-user-type': (context) => const SwitchUserType(),
        '/admin-signin': (context) => const AdminSignInPage(),
        '/admin-signup': (context) => const AdminSignUpPage(),
        '/admin': (context) => const AdminDashboard(),
        '/monitor-signin': (context) => const MonitorSignInPage(),
        '/monitor-signup': (context) => const MonitorSignUpPage(),
        '/monitor': (context) => const MonitorDashboard()
      },
    );
  }
}
