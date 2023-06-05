// Firebase credential and packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// User Screens
import 'screens/user/UserView.dart';
import 'screens/user/Profile.dart';
import 'screens/user/AddEntry.dart';
import 'screens/user/EditEntry.dart';

// Auth Screens
import 'screens/auth/SwitchUserType.dart';
import 'screens/auth/LoginPage.dart';
import 'screens/auth/SignupPage.dart';
import 'screens/auth/MonitorSignInPage.dart';
import 'screens/auth/MonitorSignUpPage.dart';
import 'screens/auth/AdminSignInPage.dart';
import 'screens/auth/AdminSignUpPage.dart';

// Admin Screen
import 'screens/admin/Admin.dart';

// Monitor Screen
import 'screens/monitor/Monitor.dart';
import 'screens/monitor/Scanner.dart';

// Proviers
import 'provider/auth_provider.dart';
import 'provider/entry_provider.dart';
import 'provider/user_provider.dart';
import 'provider/log_provider.dart';

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
        ChangeNotifierProvider(create: ((context) => LogProvider())),
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
      title: 'OHMSMobile',
      theme: ThemeData.dark(),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/add-entry': (context) => const AddEntry(),
        '/edit-entry': (context) => const EditEntry(),
        '/switch-user-type': (context) => const SwitchUserType(),
        '/admin-signin': (context) => const AdminSignInPage(),
        '/admin-signup': (context) => const AdminSignUpPage(),
        '/admin': (context) => const Admin(),
        '/monitor-signin': (context) => const MonitorSignInPage(),
        '/monitor-signup': (context) => const MonitorSignUpPage(),
        '/monitor': (context) => const Monitor(),
        '/scanner': (context) => const Scanner(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/user') {
          final args = settings.arguments as UserView;
          return MaterialPageRoute(builder: (context) {
            return UserView(viewer: args.viewer);
          });
        } else if (settings.name == '/profile') {
          final args = settings.arguments as Profile;
          return MaterialPageRoute(builder: (context) {
            return Profile(viewer: args.viewer);
          });
        }
        return null;
      },
    );
  }
}
