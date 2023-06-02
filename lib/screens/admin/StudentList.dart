import 'package:flutter/material.dart';
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
  final TextEditingController _searchController = TextEditingController();
  static final List<String> filterBy = ["Course", "College", "Student No"];
  String _filterByValue = filterBy.first;

  List<UserDetails> students = [];
  List<UserDetails> filteredStudents = [];

  bool startSearch = false;

  void search(String searchText) {
    print(filteredStudents.length);
    setState(() {
      if (_filterByValue == "Course") {
        filteredStudents = students
            .where((item) =>
                item.course!.toLowerCase().startsWith(searchText.toLowerCase()))
            .toList();
      } else if (_filterByValue == "College") {
        filteredStudents = students
            .where((item) => item.college!
                .toLowerCase()
                .startsWith(searchText.toLowerCase()))
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
            return const Center(
              child: Text("No students found."),
            );
          }

          List<UserDetails> temp = [];
          for (int index = 0; index < snapshot.data!.docs.length; index++) {
            UserDetails student = UserDetails.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>, 0);
            if (!students.contains(student)) {
              temp.add(student);
            }
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
                  style: TextStyle(fontFamily: 'SF-UI-Display', fontSize: 25),
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade800,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Filter by",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                labelText: 'Search',
                                labelStyle: TextStyle(height: 1),
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
                        title: Text(startSearch
                            ? filteredStudents[index].name
                            : students[index].name),
                        subtitle: Text(startSearch
                            ? filteredStudents[index].studentNum!
                            : students[index].studentNum!),
                      ),
                    );
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
