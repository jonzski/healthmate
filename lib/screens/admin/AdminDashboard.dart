import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pie_chart/pie_chart.dart';
import './StudentEntries.dart';
import './StudentQuarantine.dart';
import './StudentMonitoring.dart';
import './EntryRequest.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _pageIndex = 0;

  late PageController _pageController;
  GlobalKey _bottomNavigationKey = GlobalKey();

  final String logo = 'assets/images/Logo.svg';

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
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget bottomNavFunction() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _pageIndex = index;
        });
      },
      children: <Widget>[
        homepage(),
        const StudentEntries(),
        const StudentQuarantine(),
        const StudentMonitoring(),
        const EntryRequest(),
      ],
    );
  }

  void _swipeLeft() {
    if (_pageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _swipeRight() {
    if (_pageIndex < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 7.5),
                  child: SvgPicture.asset(
                    logo,
                    width: 40,
                    colorFilter: const ColorFilter.mode(
                        Color(0xFF526bf2), BlendMode.srcIn),
                  ),
                ),
                const Text(
                  "OHMS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'SF-UI-Display',
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const Text(
                  "Mobile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'SF-UI-Display',
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ]),
              backgroundColor: const Color(0xFF090c12),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              key: _bottomNavigationKey,
              backgroundColor: const Color(0xFF090c12),
              currentIndex: _pageIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _pageIndex = index;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Students',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sick),
                  label: 'Quarantined',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.safety_check),
                  label: 'Monitor',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_rounded),
                  label: 'Entry Request',
                ),
              ],
            ),
            body: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  _swipeRight();
                } else if (details.primaryVelocity! > 0) {
                  _swipeLeft();
                }
              },
              child: bottomNavFunction(),
            )));
  }

  Widget homepage() {
    return Center(
        child: Container(
            width: 600,
            // color: const Color(0xFF090c12),
            color: Colors.white70,
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
            ])));
  }

  Widget header() {
    return Container(
      margin:
          const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF526bf2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 80,
      child: Text(
        ('Welcome, Admin'),
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget title() {
    return Container(
        margin: const EdgeInsets.only(
            top: 10.0, left: 30.0, right: 30.0, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade400,
          borderRadius: BorderRadius.all(Radius.circular(15)),
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        // height: 300,
        child: Column(
          children: [
            const Text(
              'Number of Quarantined Students',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Container(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  minorGridLines: const MinorGridLines(width: 0),
                  labelStyle: const TextStyle(color: Colors.black),
                  title: AxisTitle(
                      text: 'Days', textStyle: TextStyle(color: Colors.black)),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: 300,
      child: Column(children: [
        const Text(
          'Daily Status',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        Container(
            margin: const EdgeInsets.only(top: 30),
            child: PieChart(
              dataMap: dataMap,
              colorList: const [Colors.green, Colors.orange, Colors.red],
              legendOptions: const LegendOptions(
                showLegends: false,
              ),
              chartValuesOptions: const ChartValuesOptions(
                  showChartValues: false, showChartValueBackground: false),
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
            // color: const Color(0xFF222429),
            color: const Color(0xFF3eb88b),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 90,
          width: 250,
          child: Column(children: [
            const Text(
              'Cleared Students',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 30, bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: const Color(0xFF222429),
            color:const Color(0xFFed832d),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 90,
          width: 250,
          child: Column(children: [
            const Text(
              'Monitoring Student',
              style: TextStyle(fontSize: 16, color: Colors.white), 
            ),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 30, bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: const Color(0xFF222429),
            color: Color(0xFFd62b1c),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 90,
          width: 250,
          child: Column(children: [
            const Text(
              'Quarantined Students',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
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
