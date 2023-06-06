import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<ChartData> chartData = [
    ChartData(1, 10),
    ChartData(2, 18),
    ChartData(3, 14),
    ChartData(4, 32),
    ChartData(5, 40),
    ChartData(6, 35),
    ChartData(7, 28),
    ChartData(8, 34),
    ChartData(9, 32),
    ChartData(10, 40)
  ];

  Map<String, double> dataMap = {
    "Cleared": 10,
    "Monitoring": 3,
    "Quarantined": 2,
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
          Row(
            children: [Expanded(child: lineGraph())],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(flex: 1, child: pieGraph()),
              Expanded(flex: 1, child: dataNumbers())
            ],
          ),
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

          Map<String, dynamic>? monitor = snapshot.data;

          String name = monitor?['name'];

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
                  ('Welcome, Monitor $name !'),
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

  Widget lineGraph() {
    return Container(
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        padding:
            const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 10),
        decoration: BoxDecoration(
          // color: const Color(0xFF222429),
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        // height: 300,
        child: Column(
          children: [
            const Text(
              'Number of Quarantined Students',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  minorGridLines: const MinorGridLines(width: 0),
                  labelStyle: const TextStyle(color: Colors.black),
                  title: AxisTitle(
                      text: 'Days',
                      textStyle: const TextStyle(color: Colors.black)),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  minorGridLines: const MinorGridLines(width: 0),
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<ChartData, int>(
                      color: Colors.amber.shade800,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.day,
                      yValueMapper: (ChartData data, _) => data.numOfQuar)
                ],
                plotAreaBorderColor: Colors.transparent,
                borderWidth: 0,
              ),
            )
          ],
        ));
  }

  Widget pieGraph() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 10, bottom: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        // color: const Color(0xFF222429),
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
      ),
      height: 300,
      child: Column(children: [
        const Text(
          'Daily Status',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        Container(
            margin: const EdgeInsets.only(top: 10),
            child: PieChart(
              dataMap: dataMap,
              colorList: const [Colors.green, Colors.orange, Colors.red],
              chartType: ChartType.disc, // Set the chartType to 'disc'
              legendOptions: const LegendOptions(
                showLegends: false,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: false,
                showChartValueBackground: false,
              ),
            ))
      ]),
    );
  }

  Widget dataNumbers() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 30, bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF55d993),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(children: [
            const Text(
              'Cleared Students',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.emoji_emotions,
                ),
                Text(
                  '${dataMap["Cleared"]}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            )
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 30, bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFfca562),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(children: [
            const Text(
              'Monitoring Student',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.monitor_rounded,
                ),
                Text(
                  '${dataMap["Monitoring"]}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            )
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 30, bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFfc6265),
            borderRadius: BorderRadius.circular(25),
          ),
          width: 250,
          child: Column(children: [
            const Text(
              'Quarantined Students',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.sick,
                  size: 40,
                ),
                Text(
                  '${dataMap["Quarantined"]}',
                  style: const TextStyle(fontSize: 32, color: Colors.white),
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
