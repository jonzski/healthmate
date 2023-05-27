import 'package:flutter/material.dart';
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
            return const Center(
              child: Text("No students found."),
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
                    title: Text(students.name),
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
