import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryRequest extends StatefulWidget {
  const EntryRequest({Key? key}) : super(key: key);

  @override
  State<EntryRequest> createState() => _EntryRequestState();
}

class _EntryRequestState extends State<EntryRequest> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allstudents =
        context.watch<UserProvider>().allStudents;

    return StreamBuilder(
      stream: allstudents,
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
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: ((context, index) {
            print(index);
          }),
        );
      },
    );
  }
}
