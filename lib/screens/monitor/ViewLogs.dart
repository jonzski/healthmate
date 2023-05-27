import 'package:flutter/material.dart';
import '../../model/log_model.dart';
import '../../provider/log_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewLogs extends StatefulWidget {
  const ViewLogs({Key? key}) : super(key: key);

  @override
  State<ViewLogs> createState() => _ViewLogsState();
}

class _ViewLogsState extends State<ViewLogs> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allStudents = context.watch<LogProvider>().allLogs;

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

          return Padding(
            padding: EdgeInsets.all(16.0), // Adjust the padding value as needed
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                MonitorLog logs = MonitorLog.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>,
                );
                return Card(
                  color: const Color(0xFF222429),
                  child: ListTile(
                    title: Text(logs.studentId!),
                    subtitle: Text(logs.date.toString()),
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
