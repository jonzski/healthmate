import 'package:flutter/material.dart';
import './components/UserDrawer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFF090c12),
        centerTitle: true,
      ),
      body: profile(),
    );
  }

  Widget profile() {
    return Scaffold(
        backgroundColor: const Color(0xFF090c12),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF222429),
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person), label: 'Profile'),
            ]),
        body: Center(
          child: Container(
            color: const Color(0xFF222429),
            height: 450,
            width: 400,
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: ListView(shrinkWrap: true, children: const <Widget>[
                    Center(
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ))),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Name: Goofy ahh lil jits",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Student Number: 2021-72769",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Course: BS Computer Science",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "College: College of Arts and Sciences",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ]),
                )),
          ),
        ));
  }
}
