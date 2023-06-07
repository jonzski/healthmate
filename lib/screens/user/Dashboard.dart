import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/entry_model.dart';
import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';
import '../../provider/entry_provider.dart';

class Dashboard extends StatefulWidget {
  String viewer;
  Dashboard({Key? key, required this.viewer}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String viewer;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _remarkController = TextEditingController();

  void initState() {
    viewer = widget.viewer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF090c12),
        child: ListView(children: [
          Row(
            children: [Expanded(child: header())],
          ),
          Row(
            children: [Expanded(child: todaysEntry())],
          ),
          const Divider(),
          Row(
            children: [Expanded(child: isUnderQuarantine())],
          ),
          Row(
            children: [Expanded(child: isUnderMonitoring())],
          ),
        ]));
  }

  Widget header() {
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;

    return FutureBuilder<Map<String, dynamic>?>(
      future: context.read<UserProvider>().viewSpecificStudent(currentUserUid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map<String, dynamic>? student = snapshot.data;

        String name = viewer == 'Admin' || viewer == 'Monitor'
            ? viewer
            : student?['name'];

        return Container(
          margin:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 15),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFF526bf2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ('Welcome, ${name} !'),
                style: const TextStyle(
                  fontFamily: 'SF-UI-Display',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Your health deserves to be constantly checked.',
                  style: TextStyle(
                      fontFamily: 'SF-UI-Display',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget todaysEntry() {
    final entryProvider = context.read<EntryProvider>();
    DateTime timeToday = DateTime.now();
    timeToday = DateTime(timeToday.year, timeToday.month, timeToday.day);
    User user = context.read<AuthProvider>().currentUser;
    context.read<EntryProvider>().getTodayEntry(user);
    DailyEntry? entry = context.read<EntryProvider>().entryToday;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 8),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF222429),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(children: [
        const Text(
          'Today\'s Entry',
          style: TextStyle(
              fontFamily: 'SF-UI-Display',
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(
                  Icons.add_box_rounded,
                  color: Colors.green.shade700,
                ),
                TextButton(
                  onPressed: () async {
                    bool isAdded = await entryProvider.checkIfAddedEntry(
                        user.uid, user, timeToday);

                    if (isAdded) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "You have already added an entry for today")));
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/add-entry');
                    }
                  },
                  child: const Text('Add Entry'),
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.blue.shade900,
                ),
                TextButton(
                  onPressed: () async {
                    bool isAdded = await entryProvider.checkIfAddedEntry(
                        user.uid, user, timeToday);

                    if (!isAdded) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("You have not added an entry for today")));
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/edit-entry');
                    }
                  },
                  child: const Text('Edit Entry'),
                )
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                TextButton(
                  onPressed: () async {
                    bool isAdded = await entryProvider.checkIfAddedEntry(
                        user.uid, user, timeToday);

                    if (!isAdded) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("You have not added an entry for today")));
                    } else {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: const Text('Delete Today\'s Entry'),
                            content: Form(
                              key: formKey,
                              child: TextFormField(
                                  controller: _remarkController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a remark';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Reason for deleting entry',
                                  ),
                                  onChanged: (String value) {
                                    entry!.remarks = value;
                                  }),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    child: const Text('Submit'),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        final entryProvider =
                                            context.read<EntryProvider>();
                                        // entry.entryId causes error (returns null value)
                                        entryProvider.entryDeleteRequest(
                                            entry!.entryId!, entry);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Successfully requested for deleting entry!')));
                                        setState(() {
                                          _remarkController.clear();
                                        });

                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Delete Entry'),
                )
              ],
            )
          ],
        )
      ]),
    );
  }

  Widget isUnderQuarantine() {
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;

    return FutureBuilder<Map<String, dynamic>?>(
        future:
            context.read<UserProvider>().viewSpecificStudent(currentUserUid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic>? student = snapshot.data;

          bool isQuarantine = student?['underQuarantine'] != null
              ? (student?['underQuarantine'])
              : false;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF222429),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.sick,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Is under quarantine?',
                      style: TextStyle(
                        fontFamily: 'SF-UI-Display',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isQuarantine ? 'Yes' : 'No',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget isUnderMonitoring() {
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;

    return FutureBuilder<Map<String, dynamic>?>(
      future: context.read<UserProvider>().viewSpecificStudent(currentUserUid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map<String, dynamic>? student = snapshot.data;

        bool isQuarantine = student?['underMonitoring'] != null
            ? (student?['underMonitoring'])
            : false;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF222429),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.monitor,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Is under monitoring?',
                    style: TextStyle(
                      fontFamily: 'SF-UI-Display',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isQuarantine ? 'Yes' : 'No',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
