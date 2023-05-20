import 'package:flutter/material.dart';
import '../components/UserDrawer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFF090c12),
        centerTitle: true,
      ),
      body: homepage(),
    );
  }

  Widget homepage() {
    return Scaffold(
        backgroundColor: const Color(0xFF090c12),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => setState(() => currentIndex = index),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'View Students'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ]),
        body: ListView(children: [
          Row(
            children: [Expanded(child: header())],
          ),
          Row(
            children: [Expanded(child: todaysEntry())],
          ),
          const Divider(),
          Row(
            children: [Expanded(child: listOfEntries())],
          ),
          Row(
            children: [Expanded(child: isUnderQuarantine())],
          ),
        ]));
  }

  Widget header() {
    return Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFF526bf2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Welcome, ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Your health deserves to be constantly checked.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )
          ],
        ));
  }

  Widget todaysEntry() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF222429),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 100,
      child: Column(children: [
        const Text(
          'Today\'s Entry',
          style: TextStyle(fontSize: 16),
        ),
        const Divider(),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddEntry');
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
                  onPressed: () {},
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
                  onPressed: () {},
                  child: const Text('Delete Entry'),
                )
              ],
            )
          ],
        )
      ]),
    );
  }

  Widget listOfEntries() {
    return GestureDetector(
        onTap: () {
          print("Container clicked");
        },
        child: Container(
            margin:
                const EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
            padding: const EdgeInsets.only(left: 40, right: 40),
            height: 70,
            decoration: BoxDecoration(
                color: Color(0xFF222429),
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.list_alt_rounded,
                  size: 40,
                  color: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'List of Health Status Entries',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'Number of Entries: 0',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                )
              ],
            )));
  }

  Widget isUnderQuarantine() {
    return GestureDetector(
        onTap: () {
          print("Container clicked");
        },
        child: Container(
            margin:
                const EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
            padding: const EdgeInsets.only(left: 50, right: 40),
            height: 70,
            decoration: BoxDecoration(
                color: Color(0xFF222429),
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.sick,
                  size: 40,
                  color: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Is under Quarantine?',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'No',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                )
              ],
            )));
  }
}
