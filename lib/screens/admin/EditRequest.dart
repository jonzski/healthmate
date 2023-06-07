import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../model/entry_model.dart';
import '../../provider/entry_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class EditRequest extends StatefulWidget {
  const EditRequest({Key? key}) : super(key: key);

  @override
  State<EditRequest> createState() => _EditRequestState();
}

class _EditRequestState extends State<EditRequest> {
  final String logo = 'assets/images/Logo.svg';
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> editRequests =
        context.watch<EntryProvider>().allRequestedEditEntries;

    return Container(
      color: const Color(0xFF090c12),
      child: StreamBuilder(
        stream: editRequests,
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
                        "Entries found!",
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
                DailyEntry entry = DailyEntry.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>,
                    'edit');

                return Card(
                  color: const Color(0xFF222429),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListTile(
                        title: Text(
                          'Request ID: ${entry.entryRequestId!}',
                          style: const TextStyle(
                              fontFamily: 'SF-UI-Display', fontSize: 16),
                        ),
                        trailing: SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    context.read<EntryProvider>().editRequest(
                                          entry,
                                          entry.entryRequestId!,
                                          'Approved',
                                        );
                                  },
                                  icon: const Icon(Icons.check),
                                  color: Colors.white,
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
                                    context.read<EntryProvider>().editRequest(
                                          entry,
                                          entry.entryRequestId!,
                                          'Rejected',
                                        );
                                  },
                                  icon: const Icon(Icons.close),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Request Date: ${DateFormat('MM/dd/yyyy').format(entry.entryDate)}',
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display', fontSize: 12),
                            ),
                            Text(
                              'Reason for editing: ${entry.remarks}',
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display', fontSize: 12),
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
