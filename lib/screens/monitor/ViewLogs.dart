import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../model/log_model.dart';
import '../../provider/auth_provider.dart';
import '../../provider/log_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Reverted
class ViewLogs extends StatefulWidget {
  const ViewLogs({Key? key}) : super(key: key);

  @override
  State<ViewLogs> createState() => _ViewLogsState();
}

class _ViewLogsState extends State<ViewLogs> {
  BuildContext? _initialContext;

  @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _initialContext = context;
  //     String currentUserUid =
  //         _initialContext!.read<AuthProvider>().currentUser.uid;
  //     _initialContext!.watch<LogProvider>().fetchAllLogs(currentUserUid);
  //   });
  // }

  final String logo = 'assets/images/Logo.svg';

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  static final List<String> _statuses = [
    "Cleared",
    "Under Monitoring",
    "Quarantine"
  ];

  String _statusValue = _statuses.first;
  List<MonitorLog> logs = [];
  List<MonitorLog> searchedLogs = [];

  bool startSearch = false;

  void search(String searchText) {
    setState(() {
      searchedLogs = logs
          .where((item) => item.studentName
              .toLowerCase()
              .startsWith(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? allStudents = context.watch<LogProvider>().allLogs;

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
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No",
                        style: TextStyle(
                          color: Color(0xFF526bf2),
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Logs found!",
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
          String userId = context.read<AuthProvider>().currentUser.uid;
          List<MonitorLog> temp = [];
          for (int index = 0; index < snapshot.data!.docs.length; index++) {
            MonitorLog log = MonitorLog.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>);
            if (log.uid == userId) {
              temp.add(log);
            }
          }
          logs = temp;

          return Column(children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'List of Logs',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'SF-UI-Display',
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
            ),
            Container(
                margin:
                    const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: const BoxDecoration(
                  color: Color(0xFF526bf2),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                    child: Container(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              search(value);
                              startSearch = true;
                            },
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              labelText: 'Search logs by student name',
                              labelStyle: TextStyle(height: 1),
                            ))))),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(
                  16.0), // Adjust the padding value as needed
              child: ListView.builder(
                itemCount: startSearch ? searchedLogs.length : logs.length,
                itemBuilder: ((context, index) {
                  String date = DateFormat('dd MMMM yyyy').format(startSearch
                      ? searchedLogs[index].date
                      : logs[index].date);

                  return Card(
                    color: const Color(0xFF222429),
                    child: ListTile(
                      title: Text(startSearch
                          ? searchedLogs[index].studentName
                          : logs[index].studentName),
                      trailing: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF526bf2),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFF222429),
                                      title: const Text('Edit logs'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextField(
                                            controller: _locationController,
                                            decoration: const InputDecoration(
                                              hintText: 'Location',
                                            ),
                                          ),
                                          DropdownButton<String>(
                                            isExpanded: true,
                                            value: _statusValue,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _statusValue = value!;
                                              });
                                            },
                                            items: _statuses
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Edit'),
                                          onPressed: () {
                                            String location =
                                                _locationController.text;

                                            context
                                                .read<LogProvider>()
                                                .updateLocation(
                                                    startSearch
                                                        ? searchedLogs[index]
                                                            .logId
                                                        : logs[index].logId,
                                                    location);

                                            context
                                                .read<LogProvider>()
                                                .updateStatus(
                                                    startSearch
                                                        ? searchedLogs[index]
                                                            .logId
                                                        : logs[index].logId,
                                                    startSearch
                                                        ? searchedLogs[index]
                                                            .studentId
                                                        : logs[index].studentId,
                                                    _statusValue);

                                            // Close the dialog
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      ),
                      subtitle: Text(
                          '$date | ${startSearch ? searchedLogs[index].location : logs[index].location}'),
                    ),
                  );
                }),
              ),
            ))
          ]);
        },
      ),
    );
  }
}
