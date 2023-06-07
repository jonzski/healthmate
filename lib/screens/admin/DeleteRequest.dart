import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final String logo = 'assets/images/Logo.svg';
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
                    'delete');

                return Card(
                  color: const Color(0xFF222429),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListTile(
                        title: Text('Request ID: ${entry.entryId!}',
                            style: const TextStyle(
                                fontFamily: 'SF-UI-Display', fontSize: 16)),
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
                                    context.read<EntryProvider>().deleteRequest(
                                        entry,
                                        entry.entryRequestId!,
                                        'Approved');
                                  },
                                  icon: const Icon(Icons.check),
                                  color: Colors.white,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
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
                                    context.read<EntryProvider>().deleteRequest(
                                        entry,
                                        entry.entryRequestId!,
                                        'Rejected');
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
