import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/entry_model.dart';
import '../../provider/entry_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRequest extends StatefulWidget {
  const DeleteRequest({Key? key}) : super(key: key);

  @override
  State<DeleteRequest> createState() => _DeleteRequestState();
}

class _DeleteRequestState extends State<DeleteRequest> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> deleteRequests =
        context.watch<EntryProvider>().allRequestedDeleteEntries;

    return Container(
      color: const Color(0xFF090c12),
      child: StreamBuilder(
        stream: deleteRequests,
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
              child: Text("No request found."),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(
                16.0), // Adjust the padding value as needed
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                DailyEntry entry = DailyEntry.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>,
                    'delete');

                return Card(
                  color: const Color(0xFF222429),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: ListTile(
                        title: Text('Request ID: ${entry.entryId!}'),
                        trailing: SizedBox(
                          width:
                              90, // Adjust the width as per your requirements
                          height:
                              56, // Adjust the height as per your requirements
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    context.read<EntryProvider>().updateStatus(
                                        entry.entryRequestId!, 'Approved');
                                    // context.read<EntryProvider>().editRequest(
                                    //     entry, entry.entryRequestId!);
                                  },
                                  icon: const Icon(Icons.check),
                                  color: Colors.white,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    context.read<EntryProvider>().updateStatus(
                                        entry.entryRequestId!, 'Rejected');
                                    // context.read<EntryProvider>().editRequest(
                                    //     entry, entry.entryRequestId!);
                                  },
                                  icon: const Icon(Icons.close),
                                  color: Colors.white,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request Date: ${DateFormat('MM/dd/yyyy').format(entry.entryDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Reason for editing: ${entry.remarks}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
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
