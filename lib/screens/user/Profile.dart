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

        Map<String, dynamic>? user = snapshot.data;

        String name = user?['name'];
        String studentNum = user?['studentNum'];
        String course = user?['course'];
        String college = user?['college'];

        return Container(
            width: 500,
            color: const Color(0xFF090c12),
            child: Center(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  child: const Center(
                      child: Text(
                    "MyProfile",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 40, right: 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
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
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
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
                              "Student Number: $studentNum",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "College: $college",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Course: $course",
                              style: const TextStyle(fontSize: 18),
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
                ),
              ],
            )));
      },
    );
  }
}
