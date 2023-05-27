import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: const Color(0xFF090c12),
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
    );
  }
}
