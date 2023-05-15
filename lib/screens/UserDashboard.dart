import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.teal.shade100,
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Homepage',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // close the drawer
              },
            ),
            ListTile(
              title: const Text(
                'My Profile',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // close the drawer
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          title: const Text('Health Monitoring'),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ]),
      body: homepage(),
    );
  }

  Widget homepage() {
    return Scaffold(
        backgroundColor: Colors.teal.shade50,
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
          color: Colors.white,
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
        color: Colors.white,
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
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.orange.shade200, Colors.orange.shade300]),
                // color: Colors.blue,
                border: Border.all(
                  color: Colors.orange.shade100,
                ),
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
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.pink.shade200, Colors.red.shade400]),
                // color: Colors.blue,
                border: Border.all(
                  color: Colors.red.shade100,
                ),
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
