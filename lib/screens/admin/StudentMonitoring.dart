import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/user_model.dart';
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentMonitoring extends StatefulWidget {
  const StudentMonitoring({Key? key}) : super(key: key);

  @override
  State<StudentMonitoring> createState() => _StudentMonitoringState();
}

class _StudentMonitoringState extends State<StudentMonitoring> {
  final String logo = 'assets/images/Logo.svg';
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> monitoredStudents =
        context.watch<UserProvider>().allMonitoredStudents;

    return Container(
      color: const Color(0xFF090c12),
      child: StreamBuilder(
        stream: monitoredStudents,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.1, // Set the desired opacity value (0.0 to 1.0)
                    child: SvgPicture.asset(
                      logo,
                      width: 250,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF526bf2),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "No",
                        style: TextStyle(
                          color: Color(0xFF526bf2),
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Students found!",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(
                16.0), // Adjust the padding value as needed
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                UserDetails students = UserDetails.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>,
                    0);
                return Card(
                  color: const Color(0xFF222429),
                  child: ListTile(
                    title: Text('Name: ${students.name}',
                        style: const TextStyle(
                          fontFamily: 'SF-UI-Display',
                          fontWeight: FontWeight.w700,
                        )),
                    subtitle: Text('Student Number: ${students.studentNum}',
                        style: const TextStyle(
                          fontFamily: 'SF-UI-Display',
                        )),
                    trailing: SizedBox(
                      width: 106,
                      // MediaQuery.of(context).size.width *
                      //     0.1, // Adjust the width as per your requirements
                      height: 56, // Adjust the height as per your requirements
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<UserProvider>()
                                    .endUserMonitoring(students.userId!);
                              },
                              icon: const Icon(Icons.mood),
                              color: Colors.white,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: IconButton(
                              onPressed: () {
                                DateTime now = DateTime.now();

                                context
                                    .read<UserProvider>()
                                    .addUserToQuarantine(students.userId!, now);
                              },
                              icon: const Icon(Icons.sick),
                              color: Colors.white,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
