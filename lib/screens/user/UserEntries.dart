import 'package:flutter/material.dart';
import '../../model/entry_model.dart';
import '../../provider/auth_provider.dart';
import '../../provider/entry_provider.dart';
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

    return Container(
      color: const Color(0xFF090c12),
      child: StreamBuilder(
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
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No entries found."),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'List of Entries',
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
                    DailyEntry entry = DailyEntry.fromJson(
                      snapshot.data?.docs[index].data() as Map<String, dynamic>,
                    );
                    String date =
                        DateFormat('dd MMMM yyyy').format(entry.entryDate);
                    String currentUserUid =
                        context.read<AuthProvider>().currentUser.uid;

                    if (entry.uid == currentUserUid) {
                      return Container(
                          margin: const EdgeInsets.only(
                              right: 40, left: 40, top: 10, bottom: 10),
                          padding: const EdgeInsets.all(5),
                          // height: 90,
                          decoration: const BoxDecoration(
                              color: Color(0xFF222429),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(130),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(190),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Center(child: Text('Date')),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child:
                                        const Center(child: Text('In Contact')),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child:
                                        const Center(child: Text('Symptoms')),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 5,
                                          right: 5),
                                      child: Center(
                                        child: Text(date),
                                      )),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 5, right: 5),
                                    child: Center(child: inContact(entry)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 5, right: 5),
                                    child: Center(child: symptoms(entry)),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    }
                  }),
                ),
              )),
            ],
          );
        },
      ),
    );
  }

  Text inContact(DailyEntry entry) {
    if (entry.closeContact) {
      return const Text('Yes');
    } else {
      return const Text('No');
    }
  }

  Text symptoms(DailyEntry entry) {
    String listOfSymptoms = '';
    for (var val in entry.symptoms.entries) {
      if (val.value == true) {
        listOfSymptoms += '${val.key} ';
      }
    }

    if (listOfSymptoms != '') {
      return Text(listOfSymptoms);
    } else {
      return const Text('No symptoms');
    }
  }
}
