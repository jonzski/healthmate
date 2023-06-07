import 'package:flutter/material.dart';

class SwitchUserType extends StatefulWidget {
  const SwitchUserType({super.key});

  @override
  State<SwitchUserType> createState() => _SwitchUserTypeState();
}

class _SwitchUserTypeState extends State<SwitchUserType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF090c12),
        body: Center(
          child: Container(
            height: 350,
            margin: const EdgeInsets.only(right: 100, left: 100),
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const Text(
                  'Log in as',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 25),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF526bf2)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin-signin');
                  },
                  child: const Text('Admin'),
                ),
                const SizedBox(height: 20), //space between buttons
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF526bf2)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/monitor-signin');
                  },
                  child: const Text('Entrance Monitor'),
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Center(
                    child: Text('Back'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
