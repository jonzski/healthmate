import 'package:flutter/material.dart';

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
                Navigator.pushNamed(
                    context, '/UserDashboard'); // close the drawer
              },
            ),
            ListTile(
              title: const Text(
                'My Profile',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Profile'); // close the drawer
              },
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/'); // close the drawer
              },
            ),
          ],
        ));
  }
}
