import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color(0xFF222429),
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Homepage',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin');
              },
            ),
            ListTile(
              title: const Text(
                'My Profile',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile'); // close the drawer
              },
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                context.read<AuthProvider>().signOut();

                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/admin-login');
                }
              },
            ),
          ],
        ));
  }
}
