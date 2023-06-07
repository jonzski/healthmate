import 'package:cmsc_23_project/provider/auth_provider.dart';
import '../../provider/log_provider.dart';
import '../../provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;
    TextEditingController _locationController = TextEditingController();
    String _location = context.watch<LogProvider>().location;

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

        Map<String, dynamic>? monitor = snapshot.data;

        String empNo = "N/A";
        String position = "N/A";
        String homeUnit = "N/A";

        String name = monitor?['name'];
        if (monitor?['empNo'] == null) {
          empNo = monitor?['studentNum'];
        } else {
          empNo = monitor?['empNo'];
        }

        if (monitor?['position'] != null) {
          position = monitor?['position'];
        } else {
          position = "Student Monitor";
        }

        if (monitor?['homeUnit'] != null) {
          homeUnit = monitor?['homeUnit'];
        } else {
          homeUnit = monitor?['college'];
        }

        // position = monitor?['position'];
        // homeUnit = monitor?['homeUnit'];

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
                      "Position: $position",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Location: $_location",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: const Color(0xFF222429),
                                title: const Text('Enter current location'),
                                content:
                                    TextField(controller: _locationController),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Update'),
                                    onPressed: () {
                                      String location =
                                          _locationController.text;

                                      context
                                          .read<LogProvider>()
                                          .updateMonitorLocation(location);

                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: const Text(
                          'Update Location',
                          style: TextStyle(
                              fontFamily: 'SF-UI-Display',
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthProvider>().signOut();
                          Navigator.pushReplacementNamed(
                              context, '/admin-signin');
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
                    ],
                  ),
                ]),
              )),
        );
      },
    );
  }
}
