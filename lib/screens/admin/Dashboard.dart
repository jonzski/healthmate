import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
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
    return Container(
        color: const Color(0xFF090c12),
        child: ListView(children: [
          Row(
            children: [Expanded(child: header())],
          ),
          Row(
            children: [Expanded(child: title())],
          ),
          pieGraph(),
          Column(
            children: [cleared(), monitoring(), quarantine()],
          )
        ]));
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
        margin: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Center(
              child: Text(
                "Daily Status",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Center(
                child: Text("DailyStatus Underlineeeee",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.transparent,
                        decorationColor: Color(0xFF526bf2),
                        decoration: TextDecoration.underline,
                        decorationThickness: 6)))
          ],
        ));
  }

  Widget pieGraph() {
    int? quarantineCount = context.watch<UserProvider>().quarantineCount;
    int? monitoringCount = context.watch<UserProvider>().monitoringCount;
    int? clearedCount = context.watch<UserProvider>().clearedCount;
    return Container(
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 10),
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(35),
            shape: BoxShape.circle,
            border: Border.all(
              // color: Colors.white, // Set the color of the border line to white
              width: 0.5, // Set the thickness of the border line
            )),
        child: PieChart(
          dataMap: (quarantineCount != null &&
                  monitoringCount != null &&
                  clearedCount != null)
              ? {
                  "Cleared": clearedCount.toDouble(),
                  "Monitoring": monitoringCount.toDouble(),
                  "Quarantined": quarantineCount.toDouble(),
                }
              : {
                  "Cleared": 0,
                  "Monitoring": 0,
                  "Quarantined": 0,
                },
          colorList: const [Colors.green, Colors.orange, Colors.red],
          chartType: ChartType.disc, // Set the chartType to 'disc'
          legendOptions: const LegendOptions(
            showLegends: false,
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValues: false,
            showChartValueBackground: false,
          ),
        ));
  }

  Widget cleared() {
    Stream<QuerySnapshot> clearedStudents =
        context.watch<UserProvider>().allClearedStudent;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder(
            stream: clearedStudents,
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

              dataMap["Cleared"] = snapshot.data!.docs.length.toDouble();
              context
                  .read<UserProvider>()
                  .updateClearedCount(snapshot.data!.docs.length);

              return Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Text(
                    'Cleared\nStudents',
                    style: TextStyle(fontSize: 16, fontFamily: 'SF-UI-Display'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '${snapshot.data!.docs.length}',
                      style: const TextStyle(
                          fontSize: 22, fontFamily: 'SF-UI-Display'),
                    ),
                  )
                ],
              ));
            }));
  }

  Widget monitoring() {
    Stream<QuerySnapshot> monitoredStudents =
        context.watch<UserProvider>().allMonitoredStudents;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
        stream: monitoredStudents,
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
          dataMap["Monitoring"] = snapshot.data!.docs.length.toDouble();
          context
              .read<UserProvider>()
              .updateMonitoringCount(snapshot.data!.docs.length);
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
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
                const Text(
                  'Monitoring\nStudents',
                  style: TextStyle(fontSize: 16, fontFamily: 'SF-UI-Display'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${snapshot.data!.docs.length}',
                    style: const TextStyle(
                        fontSize: 22, fontFamily: 'SF-UI-Display'),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget quarantine() {
    Stream<QuerySnapshot> quarantinedStudents =
        context.watch<UserProvider>().allQuarantinedStudents;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
        stream: quarantinedStudents,
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
          dataMap["Quarantined"] = snapshot.data!.docs.length.toDouble();
          context
              .read<UserProvider>()
              .updateQuarantineCount(snapshot.data!.docs.length);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
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
              const Text(
                'Quarantined\nStudents',
                style: TextStyle(fontSize: 16, fontFamily: 'SF-UI-Display'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  '${snapshot.data!.docs.length}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'SF-UI-Display',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
