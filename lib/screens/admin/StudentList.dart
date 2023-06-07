import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/user_model.dart';
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Reverted
class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final String logo = 'assets/images/Logo.svg';

  final TextEditingController _searchController = TextEditingController();
  static final List<String> filterBy = ["Course", "College", "Student No"];
  String _filterByValue = filterBy.first;

  List<UserDetails> students = [];
  List<UserDetails> filteredStudents = [];

  bool startSearch = false;
  bool selectedAdmin = false;
  bool selectedMonitor = false;

  void search(String searchText) {
    setState(() {
      if (_filterByValue == "Course") {
        filteredStudents = students
            .where((item) =>
                item.course!.toLowerCase().startsWith(searchText.toLowerCase()))
            .where((element) => element.userType == 0)
            .toList();
      } else if (_filterByValue == "College") {
        filteredStudents = students
            .where((item) => item.college!
                .toLowerCase()
                .startsWith(searchText.toLowerCase()))
            .where((element) => element.userType == 0)
            .toList();
      } else {
        filteredStudents = students
            .where((item) => item.studentNum!.startsWith(searchText))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allStudents =
        context.watch<UserProvider>().allStudents;

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
                        "Students found!",
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

          List<UserDetails> temp = [];
          for (int index = 0; index < snapshot.data!.docs.length; index++) {
            UserDetails student = UserDetails.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>, 0);
            temp.add(student);
          }
          students = temp;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'List of Students',
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
                  // padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF526bf2),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Filter by",
                        style: TextStyle(
                            fontFamily: 'SF-UI-Display',
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      DropdownButton<String>(
                        // isExpanded: true,
                        value: _filterByValue,
                        onChanged: (String? value) {
                          setState(() {
                            _filterByValue = value!;
                          });
                        },
                        items: filterBy.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                      Container(
                          width: 150,
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextField(
                              onChanged: (value) {
                                search(value);
                                startSearch = true;
                              },
                              controller: _searchController,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display', fontSize: 16),
                              decoration: const InputDecoration(
                                labelText: 'Search',
                              )))
                    ],
                  ))),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Adjust the padding value as needed
                child: ListView.builder(
                  itemCount:
                      startSearch ? filteredStudents.length : students.length,
                  itemBuilder: ((context, index) {
                    return Card(
                        color: const Color(0xFF222429),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(
                                      0xFF222429), // Example color, choose a modern color
                                  title: const Text(
                                    'Student Info',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF526bf2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${startSearch ? filteredStudents[index].name : students[index].name}',
                                          style: const TextStyle(
                                            fontFamily: 'SF-UI-Display',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'Student Number: ${startSearch ? filteredStudents[index].studentNum : students[index].studentNum}',
                                          style: const TextStyle(
                                            fontFamily: 'SF-UI-Display',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'Course: ${startSearch ? filteredStudents[index].course : students[index].course}',
                                          style: const TextStyle(
                                            fontFamily: 'SF-UI-Display',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'College: ${startSearch ? filteredStudents[index].college : students[index].college}',
                                          style: const TextStyle(
                                            fontFamily: 'SF-UI-Display',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                      ),
                                      child: const Text(
                                        "Back",
                                        style: TextStyle(
                                          fontFamily: 'SF-UI-Display',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          title: Text(
                            startSearch
                                ? filteredStudents[index].name
                                : students[index].name,
                            style: const TextStyle(
                              fontFamily: 'SF-UI-Display',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                              startSearch
                                  ? filteredStudents[index].studentNum!
                                  : students[index].studentNum!,
                              style: const TextStyle(
                                fontFamily: 'SF-UI-Display',
                              )),
                          trailing: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xFF526bf2),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.trending_up_rounded),
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        title: const Text(
                                          'Elevate User Type',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'SF-UI-Display',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        content: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            height: 90,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      color: selectedAdmin
                                                          ? const Color(
                                                              0xFF52d9c3)
                                                          : Colors.white,
                                                      iconSize: 40,
                                                      icon: const Icon(
                                                        Icons
                                                            .admin_panel_settings_outlined,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedAdmin = true;
                                                          selectedMonitor =
                                                              false;
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      'Admin',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: selectedAdmin
                                                            ? const Color(
                                                                0xFF52d9c3)
                                                            : Colors.white,
                                                        fontFamily:
                                                            'SF-UI-Display',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      color: selectedMonitor
                                                          ? const Color(
                                                              0xFF52d9c3)
                                                          : Colors.white,
                                                      iconSize: 40,
                                                      icon: const Icon(
                                                        Icons.monitor,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedAdmin = false;
                                                          selectedMonitor =
                                                              true;
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      'Monitor',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: selectedMonitor
                                                            ? const Color(
                                                                0xFF52d9c3)
                                                            : Colors.white,
                                                        fontFamily:
                                                            'SF-UI-Display',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                        actions: [
                                          TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                overlayColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Confirm",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'SF-UI-Display',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                String uid = startSearch
                                                    ? filteredStudents[index]
                                                        .userId!
                                                    : students[index].userId!;
                                                String uname = startSearch
                                                    ? filteredStudents[index]
                                                        .name
                                                    : students[index].name;
                                                if (selectedAdmin &&
                                                    !selectedMonitor) {
                                                  context
                                                      .read<UserProvider>()
                                                      .elevateUserToAdminOrMonitor(
                                                          uid, 2);
                                                  startSearch
                                                      ? filteredStudents.remove(
                                                          filteredStudents[
                                                              index])
                                                      : students.remove(
                                                          students[index]);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Successfully elevated user $uname to Admin!')));
                                                } else if (!selectedAdmin &&
                                                    selectedMonitor) {
                                                  context
                                                      .read<UserProvider>()
                                                      .elevateUserToAdminOrMonitor(
                                                          uid, 3);
                                                  startSearch
                                                      ? filteredStudents.remove(
                                                          filteredStudents[
                                                              index])
                                                      : students.remove(
                                                          students[index]);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Successfully elevated user $uname to Monitor')));
                                                }

                                                selectedAdmin = false;
                                                selectedMonitor = false;
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    },
                                  );
                                },
                              )),
                        ));
                  }),
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}
