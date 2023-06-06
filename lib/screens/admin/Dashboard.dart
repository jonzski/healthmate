import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../model/user_model.dart';
import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, double> dataMap = {
    "Cleared": 0,
    "Monitoring": 0,
    "Quarantined": 0,
  };

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
              }

              Map<String, double> temp = {
                "Cleared": 0,
                "Monitoring": 0,
                "Quarantined": 0,
              };

              for (int index = 0; index < snapshot.data!.docs.length; index++) {
                UserDetails student = UserDetails.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>,
                    0);
                if (student.userType == 0) {
                  if (!student.underMonitoring! && !student.underQuarantine!) {
                    temp["Cleared"] = (temp["Cleared"]! + 1);
                  } else if (student.underMonitoring!) {
                    temp["Monitoring"] = (temp["Monitoring"]! + 1);
                  } else if (student.underQuarantine!) {
                    temp["Quarantined"] = (temp["Quarantined"]! + 1);
                  }
                }
              }

              dataMap = temp;

              return Container(
                  color: const Color(0xFF090c12),
                  child: ListView(children: [
                    Row(
                      children: [Expanded(child: header())],
                    ),
                    Row(
                      children: [Expanded(child: title())],
                    ),
                    pieGraph()
                  ]));
            }));
  }

  Widget header() {
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

          Map<String, dynamic>? admin = snapshot.data;

          String name = admin?['name'];

          return Container(
            margin: const EdgeInsets.only(
                top: 30.0, left: 30.0, right: 30.0, bottom: 15),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF526bf2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ('Welcome, Admin $name !'),
                  style: const TextStyle(
                    fontFamily: 'SF-UI-Display',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Your student's health deserves to be constantly checked.",
                    style: TextStyle(
                        fontFamily: 'SF-UI-Display',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget title() {
    return Container(
        margin: const EdgeInsets.only(
            top: 10.0, left: 30.0, right: 30.0, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade400,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(
              child: Text(
                "Online Report",
                style: TextStyle(
                    fontSize: 20,
                    // color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ));
  }

  Widget pieGraph() {
    return Container(
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Daily Status',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'SF-UI-Display'),
                      ),
                      Container(
                          constraints: const BoxConstraints(
                            maxHeight: 200,
                          ),
                          padding: const EdgeInsets.all(25),
                          child: PieChart(
                            dataMap: dataMap,
                            colorList: const [
                              Colors.green,
                              Colors.orange,
                              Colors.red
                            ],
                            chartType:
                                ChartType.disc, // Set the chartType to 'disc'
                            legendOptions: const LegendOptions(
                              showLegends: false,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValues: false,
                              showChartValueBackground: false,
                            ),
                          ))
                    ])),
            Expanded(flex: 1, child: dataNumbers())
          ],
        ));
  }

  Widget dataNumbers() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 30, top: 5),
          height: 70,
          child: Column(children: [
            const Text(
              'Cleared Students',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'SF-UI-Display'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 50, right: 20),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: const Icon(
                    Icons.mood,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  '${dataMap["Cleared"]}',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: 'SF-UI-Display'),
                ),
              ],
            )
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 30, top: 5),
          height: 70,
          child: Column(children: [
            const Text(
              'Monitoring Students',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'SF-UI-Display'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 50, right: 20),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: const Icon(
                    Icons.monitor_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  '${dataMap["Monitoring"]}',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: 'SF-UI-Display'),
                ),
              ],
            )
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          height: 70,
          child: Column(children: [
            const Text(
              'Quarantined Students',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'SF-UI-Display'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 50, right: 20),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: const Icon(
                    Icons.sick,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  '${dataMap["Quarantined"]}',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: 'SF-UI-Display'),
                ),
              ],
            )
          ]),
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.day, this.numOfQuar);
  final int day;
  final int numOfQuar;
}
