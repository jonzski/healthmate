import 'package:flutter/material.dart';
import './StudentQuarantine.dart';
import './StudentMonitoring.dart';
import 'StudentCleared.dart';

class StudentEntries extends StatefulWidget {
  const StudentEntries({Key? key}) : super(key: key);

  @override
  State<StudentEntries> createState() => _StudentEntriesState();
}

class _StudentEntriesState extends State<StudentEntries> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF090c12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Quarantine and Monitor Students',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'SF-UI-Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ),
          Expanded(
            // Wrap the Column with Expanded widget
            child: DefaultTabController(
              length: 3, // length of tabs
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: const TabBar(
                      labelColor: Color(0xFF526bf2),
                      unselectedLabelColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text(
                            'Monitor',
                            style: TextStyle(
                                fontFamily: 'SF-UI-Display', fontSize: 16.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Quarantine',
                            style: TextStyle(
                                fontFamily: 'SF-UI-Display', fontSize: 16.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Cleared',
                            style: TextStyle(
                                fontFamily: 'SF-UI-Display', fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // Wrap TabBarView with Expanded widget
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: const TabBarView(
                        children: <Widget>[
                          StudentMonitoring(),
                          StudentQuarantine(),
                          StudentClearing(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
