import 'package:cmsc_23_project/provider/auth_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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

        String name = user?['name'];
        String studentNum = user?['studentNum'];
        String course = user?['course'];
        String college = user?['college'];
        String uid = user?['userId'];

        return Container(
            width: 500,
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
                        top: 20, bottom: 20, left: 40, right: 40),
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
                                  fontSize: 24,
                                  color: Colors.black),
                            ),
                            Text(
                              studentNum,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontSize: 24,
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
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                            Text(
                              college,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            "Scan QR Code",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'SF-UI-Display',
                                fontSize: 22,
                                color: Colors.black),
                          ),
                        ),
                        Center(
                            child: SizedBox(
                          width: 360,
                          height: 360,
                          child: CustomPaint(
                            painter:
                                MyCustomPainter(frameSFactor: .08, padding: 10),
                            child: Center(
                              child: QrImageView(
                                data: uid,
                                version: QrVersions.auto,
                                size: 260,
                                gapless: false,
                              ),
                            ),
                          ),
                        )),
                      ]),
                    )),
              ],
            )));
      },
    );
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
