import 'dart:math';

import 'package:cmsc_23_project/provider/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../provider/log_provider.dart';
import '../../provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  final String logo = 'assets/images/Logo.svg';

  @override
  Widget build(BuildContext context) {
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;
    TextEditingController _locationController = TextEditingController();
    String _location = context.watch<LogProvider>().location;

    List<String> quotes = [
      "Health: A responsibility in the face of COVID-19.",
      "Commit to daily well-being; fight COVID-19.",
      "Anchor in health amidst pandemic chaos.",
      "Prioritize health: Invest in protection against COVID-19.",
      "Cherish health; protect against COVID-19.",
      "Health: Ally in uncertain times; fortify against COVID-19.",
      "Collective health: Embrace distancing, hygiene, care amidst COVID-19."
    ];

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

        String name = monitor?['name'];
        String empNo = monitor?['empNo'];
        String position = monitor?['position'];
        String homeUnit = monitor?['homeUnit'];

        Random random = Random();
        int randomIndex = random.nextInt(quotes.length);

        return Container(
            color: const Color(0xFF090c12),
            child: Center(
                child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "MyProfile",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
                ),
                Container(
                    padding: const EdgeInsets.all(35),
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 40, right: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontFamily: 'SF-UI-Display',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                            Text(
                              empNo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              homeUnit,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Text(
                              position,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity:
                                  0.1, // Set the desired opacity value (0.0 to 1.0)
                              child: SvgPicture.asset(
                                logo,
                                width: 250,
                                colorFilter: const ColorFilter.mode(
                                  Color.fromARGB(255, 0, 0, 0),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Monitor",
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  quotes[randomIndex],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    )),
                TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().signOut();
                    Navigator.pushReplacementNamed(context, '/monitor-sigin');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                        fontFamily: 'SF-UI-Display',
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
              ],
            )));

        // return Container(
        //   color: const Color(0xFF090c12),
        //   child: Padding(
        //       padding: const EdgeInsets.all(30),
        //       child: Center(
        //         child: ListView(shrinkWrap: true, children: <Widget>[
        //           const Center(
        //               child: Padding(
        //                   padding: EdgeInsets.all(15),
        //                   child: Text(
        //                     "Profile",
        //                     style: TextStyle(
        //                         fontSize: 30, fontWeight: FontWeight.bold),
        //                   ))),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 5),
        //             child: Text(
        //               "Name: $name",
        //               style: TextStyle(fontSize: 18),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 5),
        //             child: Text(
        //               "Employee Number: $empNo",
        //               style: const TextStyle(fontSize: 18),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 5),
        //             child: Text(
        //               "Positiion: $position",
        //               style: TextStyle(fontSize: 18),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 5),
        //             child: Text(
        //               "Home Unit: $homeUnit",
        //               style: const TextStyle(fontSize: 18),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 5),
        //             child: Text(
        //               "Location: $_location",
        //               style: const TextStyle(fontSize: 18),
        //             ),
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               TextButton(
        //                 onPressed: () {
        //                   showDialog(
        //                     context: context,
        //                     builder: (BuildContext context) {
        //                       return AlertDialog(
        //                         backgroundColor: const Color(0xFF222429),
        //                         title: const Text('Enter current location'),
        //                         content:
        //                             TextField(controller: _locationController),
        //                         actions: <Widget>[
        //                           TextButton(
        //                             child: const Text('Update'),
        //                             onPressed: () {
        //                               String location =
        //                                   _locationController.text;

        //                               context
        //                                   .read<LogProvider>()
        //                                   .updateMonitorLocation(location);

        //                               // Close the dialog
        //                               Navigator.of(context).pop();
        //                             },
        //                           ),
        //                           TextButton(
        //                             child: const Text('Cancel'),
        //                             onPressed: () {
        //                               Navigator.of(context).pop();
        //                             },
        //                           ),
        //                         ],
        //                       );
        //                     },
        //                   );
        //                 },
        //                 style: ButtonStyle(
        //                   backgroundColor:
        //                       MaterialStateProperty.all(Colors.transparent),
        //                   overlayColor:
        //                       MaterialStateProperty.all(Colors.transparent),
        //                 ),
        //                 child: const Text(
        //                   'Update Location',
        //                   style: TextStyle(
        //                       fontFamily: 'SF-UI-Display',
        //                       fontWeight: FontWeight.w700,
        //                       fontSize: 15),
        //                 ),
        //               ),
        //               TextButton(
        //                 onPressed: () {
        //                   context.read<AuthProvider>().signOut();
        //                   Navigator.pushReplacementNamed(
        //                       context, '/admin-signin');
        //                 },
        //                 style: ButtonStyle(
        //                   backgroundColor:
        //                       MaterialStateProperty.all(Colors.transparent),
        //                   overlayColor:
        //                       MaterialStateProperty.all(Colors.transparent),
        //                 ),
        //                 child: const Text(
        //                   'Logout',
        //                   style: TextStyle(
        //                       fontFamily: 'SF-UI-Display',
        //                       fontWeight: FontWeight.w700,
        //                       fontSize: 15),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ]),
        //       )),
        // );
      },
    );
  }
}
