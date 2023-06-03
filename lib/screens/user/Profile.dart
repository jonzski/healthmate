import 'dart:async';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../model/entry_model.dart';
import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';

class Profile extends StatefulWidget {
  String viewer;
  Profile({super.key, required this.viewer});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String viewer;
  bool generateQRcode = false;

  void initState() {
    viewer = widget.viewer;
    super.initState();
    DateTime timeToday = DateTime.now();
    timeToday = DateTime(timeToday.year, timeToday.month, timeToday.day);
    StreamSubscription<QuerySnapshot> subscription = FirebaseFirestore.instance
        .collection("entry")
        .where('uid', isEqualTo: context.read<AuthProvider>().currentUser.uid)
        .where('entryDate', isEqualTo: timeToday)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = snapshot.docs[0];
        Map<String, dynamic> entryData =
            document.data() as Map<String, dynamic>;
        // Use the entryData map as needed
        DailyEntry entry = DailyEntry.fromJson(entryData, 'fetch');

        bool hasSymptoms = false;

        for (var val in entry.symptoms.entries) {
          if (val.value == true) {
            hasSymptoms = true;
            break;
          }
        }

        if (hasSymptoms == false) {
          setState(() {
            generateQRcode = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;

    return FutureBuilder<Map<String, dynamic>?>(
      future: context.read<UserProvider>().viewSpecificStudent(currentUserUid),
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

        Map<String, dynamic>? user = snapshot.data;

        String name =
            viewer == 'Admin' || viewer == 'Monitor' ? 'Name' : user?['name'];
        String studentNum = viewer == 'Admin' || viewer == 'Monitor'
            ? 'Student No'
            : user?['studentNum'];
        String course = viewer == 'Admin' || viewer == 'Monitor'
            ? 'Course'
            : user?['course'];
        String college = viewer == 'Admin' || viewer == 'Monitor'
            ? 'College'
            : user?['college'];
        String uid = user?['userId'];
        bool underQuarantine = user?['underQuarantine'];

        if (underQuarantine) {
          generateQRcode = false;
        }

        return Container(
            color: const Color(0xFF090c12),
            child: Center(
                child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "MyProfile",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
                ),
                Container(
                    padding: const EdgeInsets.all(35),
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 40, right: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Text(
                              studentNum,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              course,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Text(
                              college,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        qRcode(uid)
                      ]),
                    )),
                TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                        fontFamily: 'SF-UI-Display',
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
              ],
            )));
      },
    );
  }

  Widget qRcode(String uid) {
    if (generateQRcode == false) {
      return const SizedBox(
        width: 260,
        height: 260,
        child: Center(
            child: Text(
          'No generated QR code',
          style: TextStyle(
              fontFamily: 'SF-UI-Display',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black),
        )),
      );
    }
    return Center(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            "Scan QR Code",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'SF-UI-Display',
                fontSize: 22,
                color: Colors.indigoAccent),
          ),
        ),
        SizedBox(
          width: 280,
          height: 260,
          child: CustomPaint(
              painter: MyCustomPainter(frameSFactor: .08, padding: 2),
              child: Center(
                child: QrImageView(
                  data: uid,
                  version: QrVersions.auto,
                  size: 210,
                  gapless: false,
                ),
              )),
        ),
      ],
    ));
  }
}

class MyCustomPainter extends CustomPainter {
  final double padding;
  final double frameSFactor;

  MyCustomPainter({
    required this.padding,
    required this.frameSFactor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final frameHWidth = size.width * frameSFactor;

    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    /// top left
    canvas.drawLine(
      Offset(0 + padding, padding),
      Offset(
        padding + frameHWidth,
        padding,
      ),
      paint..color = Colors.indigo,
    );

    canvas.drawLine(
      Offset(0 + padding, padding),
      Offset(
        padding,
        padding + frameHWidth,
      ),
      paint..color = Colors.indigo,
    );

    /// top Right
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(size.width - padding - frameHWidth, padding),
      paint..color = Colors.indigo,
    );
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(size.width - padding, padding + frameHWidth),
      paint..color = Colors.indigo,
    );

    /// Bottom Right
    canvas.drawLine(
      Offset(size.width - padding, size.height - padding),
      Offset(size.width - padding - frameHWidth, size.height - padding),
      paint..color = Colors.indigo,
    );
    canvas.drawLine(
      Offset(size.width - padding, size.height - padding),
      Offset(size.width - padding, size.height - padding - frameHWidth),
      paint..color = Colors.indigo,
    );

    /// Bottom Left
    canvas.drawLine(
      Offset(0 + padding, size.height - padding),
      Offset(0 + padding + frameHWidth, size.height - padding),
      paint..color = Colors.indigo,
    );
    canvas.drawLine(
      Offset(0 + padding, size.height - padding),
      Offset(0 + padding, size.height - padding - frameHWidth),
      paint..color = Colors.indigo,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      true; //based on your use-cases
}
