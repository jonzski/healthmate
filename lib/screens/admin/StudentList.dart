import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Reverted
class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allStudents =
        context.watch<UserProvider>().allStudents;

    return Container(
      color: const Color(0xFF090c12),
      child: StreamBuilder(
        stream: allStudents,
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
            return const Center(
              child: Text("No students found."),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'List of Students',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'SF-UI-Display', fontSize: 25),
                ),
              ),
              Expanded(
                  child: Padding(
                padding:
                    EdgeInsets.all(16.0), // Adjust the padding value as needed
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    UserDetails students = UserDetails.fromJson(
                        snapshot.data?.docs[index].data()
                            as Map<String, dynamic>,
                        0);
                    return Card(
                      color: const Color(0xFF222429),
                      child: ListTile(
                        title: Text(students.name),
                        subtitle: Text(students.studentNum!),
                      ),
                    );
                  }),
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}
