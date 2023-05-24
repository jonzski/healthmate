import 'package:flutter/material.dart';
import '../model/entry_model.dart';
import '../provider/auth_provider.dart';
import '../provider/entry_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      // drawer: const UserDrawer(),
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
            } else {
              return dailyEntryStatus(snapshot);
            }
          }),
    );
  }

  dynamic dailyEntryStatus(AsyncSnapshot snapshot) {
    List<Container> entryStatus = [];

    for (int index = 0; index < snapshot.data?.docs.length; index++) {
      DailyEntry entry = DailyEntry.fromJson(
          snapshot.data?.docs[index].data() as Map<String, dynamic>);

      String date = DateFormat('dd MMMM yyyy').format(entry.entryDate);

      if (entry.uid == context.read<AuthProvider>().currentUser.uid) {
        entryStatus.add(Container(
            margin:
                const EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
            padding: const EdgeInsets.only(left: 40, right: 40),
            height: 70,
            decoration: const BoxDecoration(
                color: Color(0xFF222429),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.monitor_heart_rounded,
                  size: 40,
                  color: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                )
              ],
            )));
      }
    }

    if (entryStatus.isEmpty) {
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
    }

    return Column(children: entryStatus);
  }
}
