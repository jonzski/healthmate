import 'package:cmsc_23_project/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: const Color(0xFF090c12),
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ))),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Name: Goofy ahh lil jits",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Student Number: 2021-72769",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Course: BS Computer Science",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "College: College of Arts and Sciences",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                        fontFamily: 'SF-UI-Display',
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                )
              ]),
            )),
      ),
    );
  }
}
