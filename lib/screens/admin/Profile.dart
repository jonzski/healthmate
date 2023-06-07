import 'package:cmsc_23_project/provider/auth_provider.dart';
import '../../provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;

    return FutureBuilder<Map<String, dynamic>?>(
      future: context.read<UserProvider>().viewSpecificStudent(currentUserUid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map<String, dynamic>? admin = snapshot.data;
        String empNo = "N/A";
        String position = "N/A";
        String homeUnit = "N/A";

        String name = admin?['name'];
        if (admin?['empNo'] == null) {
          empNo = admin?['studentNum'];
        } else {
          empNo = admin?['empNo'];
        }

        if (admin?['position'] != null) {
          position = admin?['position'];
        } else {
          position = "Student Admin";
        }

        if (admin?['homeUnit'] != null) {
          homeUnit = admin?['homeUnit'];
        } else {
          homeUnit = admin?['college'];
        }

        return Container(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Name: $name",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Employee Number: $empNo",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Positiion: $position",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Home Unit: $homeUnit",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthProvider>().signOut();
                      Navigator.pushReplacementNamed(context, '/admin-signin');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
        );
      },
    );
  }
}
