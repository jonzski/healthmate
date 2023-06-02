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
  @override
  bool _isExpanded = false;
  double _expandedHeight = 160.0; // Set the desired expanded height
  double _collapsedHeight = 50.0; // Set the desired collapsed height
  Duration _animationDuration =
      Duration(milliseconds: 500); // Set the animation duration

  DateTime _selectedDate = DateTime.now();
  bool hasPickedDate = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        hasPickedDate = true;
      });
    }
  }

  void _toggleContainer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

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
              GestureDetector(
                onTap: _toggleContainer,
                child: AnimatedContainer(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF526bf2),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  duration: _animationDuration,
                  curve: Curves.easeInOut,
                  height: _isExpanded ? _expandedHeight : _collapsedHeight,
                  child: _isExpanded
                      ? Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              const Text(
                                'Filter By:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'SF-UI-Display', fontSize: 18),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Select Date: '),
                                          IconButton(
                                            onPressed: () =>
                                                _selectDate(context),
                                            icon: const Icon(
                                                Icons.calendar_month_outlined),
                                          ),
                                        ],
                                      ),
                                      const Text('Student No:')
                                    ],
                                  )),
                              hasPickedDate
                                  ? Text(
                                      _selectedDate.toString(),
                                    )
                                  : const SizedBox(height: 16.0)
                            ],
                          ))
                      : Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: const Text(
                            'Filter By:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'SF-UI-Display', fontSize: 18),
                          )),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Adjust the padding value as needed
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    UserDetails students = UserDetails.fromJson(
                        snapshot.data?.docs[index].data()
                            as Map<String, dynamic>,
                        0);
                    return Card(
                      color: const Color(0xFF222429),
                      child: ListTile(
                        title: Text(students.name),
                        subtitle: Text(students.studentNum!),
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

// class ExpandableContainerDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Expandable Container Demo'),
//       ),
//       body: Center(
//         child: ExpandableContainer(),
//       ),
//     );
//   }
// }
