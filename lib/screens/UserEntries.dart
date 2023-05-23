import 'package:flutter/material.dart';
import '../model/entry_model.dart';
import '../provider/auth_provider.dart';
import '../provider/entry_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './components/UserDrawer.dart';
import 'package:intl/intl.dart';

class UserEntries extends StatefulWidget {
  const UserEntries({super.key});

  @override
  State<UserEntries> createState() => _UserEntriesState();
}

class _UserEntriesState extends State<UserEntries> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> entriesStream =
        context.watch<EntryProvider>().allEntries;

    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        title: const Text('List of Daily Health Status'),
        backgroundColor: const Color(0xFF090c12),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: entriesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
              // ignore: prefer_is_empty
            } else if (snapshot.data?.docs.length == 0) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                    Text(
                      "No Entries Yet!\n",
                      style: TextStyle(fontSize: 16),
                    ),
                  ]));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    DailyEntry entry = DailyEntry.fromJson(
                        snapshot.data?.docs[index].data()
                            as Map<String, dynamic>);

                    String date =
                        DateFormat('dd MMMM yyyy').format(entry.entryDate);

                    if (entry.uid ==
                        context.read<AuthProvider>().currentUser.uid) {
                      return ListTile(
                        title: Text(date),
                        onTap: () {},
                      );
                    }
                  });
            }
          }),
    );
  }
}
