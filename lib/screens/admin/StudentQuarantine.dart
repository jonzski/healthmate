import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/user_model.dart';
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentQuarantine extends StatefulWidget {
  const StudentQuarantine({Key? key}) : super(key: key);

  @override
  State<StudentQuarantine> createState() => _StudentQuarantineState();
}

class _StudentQuarantineState extends State<StudentQuarantine> {
  final String logo = 'assets/images/Logo.svg';
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> quarantinedStudents =
        context.watch<UserProvider>().allQuarantinedStudents;

    return StreamBuilder(
      stream: quarantinedStudents,
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
          padding:
              const EdgeInsets.all(16.0), // Adjust the padding value as needed
          child: ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              UserDetails students = UserDetails.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>, 0);
              print(snapshot.data?.docs.length);
              return Card(
                color: const Color(0xFF222429),
                child: ListTile(
                  title: Text('Name: ${students.name}',
                      style: const TextStyle(
                        fontFamily: 'SF-UI-Display',
                        fontWeight: FontWeight.w700,
                      )),
                  subtitle: Text('Student Number: ${students.studentNum}',
                      style: const TextStyle(fontFamily: 'SF-UI-Display')),
                  trailing: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: IconButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        DateTime futureDate = now.add(const Duration(days: 7));
                        context.read<UserProvider>().finishStudentQuarantine(
                            students.userId!, futureDate);
                      },
                      icon: const Icon(Icons.mood),
                      color: Colors.white,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
