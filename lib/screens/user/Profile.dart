import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../model/entry_model.dart';
import '../../provider/auth_provider.dart';
import '../../provider/user_provider.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

class Profile extends StatefulWidget {
  String viewer;
  Profile({super.key, required this.viewer});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String viewer;
  bool generateQRcode = false;
  DailyEntry? entry;
  final qrKey = GlobalKey();

  @override
  void initState() {
    viewer = widget.viewer;
    super.initState();
    DateTime timeToday = DateTime.now();
    timeToday = DateTime(timeToday.year, timeToday.month, timeToday.day);
    StreamSubscription<QuerySnapshot> subscription = FirebaseFirestore.instance
        .collection("entry")
        .where('uid', isEqualTo: context.read<AuthProvider>().currentUser.uid)
        .where('entryDate', isGreaterThanOrEqualTo: timeToday.toLocal())
        .where('entryDate',
            isLessThan: timeToday.add(Duration(days: 1)).toLocal())
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = snapshot.docs[0];
        Map<String, dynamic> entryData =
            document.data() as Map<String, dynamic>;
        // Use the entryData map as needed
        entry = DailyEntry.fromJson(entryData, 'fetch');

        bool hasSymptoms = false;

        for (var val in entry!.symptoms.entries) {
          if (val.value == true) {
            hasSymptoms = true;
            break;
          }
        }

        context
            .read<UserProvider>()
            .viewSpecificStudent(context.read<AuthProvider>().currentUser.uid)
            .then((value) => {
                  if (value?['underQuarantine'] == false &&
                      value?['underMonitoring'] == false &&
                      entry?.canGenerateQR == true)
                    {
                      setState(() {
                        generateQRcode = true;
                      })
                    }
                });
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
        bool underQuarantine = (user?['underQuarantine'] != null)
            ? (user?['underQuarantine'])
            : false;
        // String status = user?['underMonitoring;']
        //     ? "Cleared";

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
                            SizedBox(
                              width: 100,
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontFamily: 'SF-UI-Display',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
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
                        entry != null ? qRcode(entry!.entryId!) : qRcode("")
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

  Widget qRcode(String eid) {
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
                child: RepaintBoundary(
                    key: qrKey,
                    child: QrImageView(
                      data: eid,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                      size: 210,
                      gapless: false,
                    )),
              )),
        ),
        ElevatedButton(
            onPressed: () {
              takeScreenShot(context, "Cleared");
            },
            child: Text("Save Qr Code")),
      ],
    ));
  }

  void takeScreenShot(BuildContext context, String status) async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increase the size of QR using pixel ratio
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // Getting the directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final fileName =
            '${DateTime.now().toString()}.png'; // Use the current timestamp as the file name

        // Show a loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Add the date created to the image
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);

        // Set background color to white
        canvas.drawColor(Colors.white, BlendMode.color);

        final imagePaint = Paint();
        imagePaint.isAntiAlias = true;
        final qrImage = await image.toByteData(format: ui.ImageByteFormat.png);
        final decodedImage =
            await decodeImageFromList(qrImage!.buffer.asUint8List());

        // Calculate the size and offset for the QR code
        final qrSize = Size(decodedImage.width.toDouble() * 0.5,
            decodedImage.height.toDouble() * 0.5);
        final qrOffset = Offset(
            (decodedImage.width.toDouble() - qrSize.width) / 2,
            (decodedImage.height.toDouble() - qrSize.height) / 2);

        canvas.drawImageRect(
          decodedImage,
          Rect.fromLTWH(0, 0, decodedImage.width.toDouble(),
              decodedImage.height.toDouble()),
          Rect.fromLTWH(qrOffset.dx, qrOffset.dy, qrSize.width, qrSize.height),
          imagePaint,
        );

        final textStyle = TextStyle(
          color: Colors.black,
          fontSize: 40.0, // Increase the font size
          fontWeight: FontWeight.bold,
        );

        final textStyle2 = TextStyle(
          color: Colors.black,
          fontSize: 20.0, // Increase the font size
          fontWeight: FontWeight.bold,
        );

        // Add healthmate at the center top
        final healthmateTextSpan = TextSpan(
          text: 'Healthmate',
          style: textStyle,
        );
        final healthmateTextPainter = TextPainter(
          text: healthmateTextSpan,
          textDirection: TextDirection.ltr,
        );
        healthmateTextPainter.layout();
        healthmateTextPainter.paint(
          canvas,
          Offset(
              (decodedImage.width.toDouble() - healthmateTextPainter.width) / 2,
              100), // Position at the center top with padding
        );

        // Add date created and status at the center bottom
        final dateStatusTextSpan = TextSpan(
          text: 'Date Created: ${DateTime.now()}\nStatus: $status',
          style: textStyle2,
        );
        final dateStatusTextPainter = TextPainter(
          text: dateStatusTextSpan,
          textDirection: TextDirection.ltr,
        );
        dateStatusTextPainter.layout();
        dateStatusTextPainter.paint(
          canvas,
          Offset(
              (decodedImage.width.toDouble() - dateStatusTextPainter.width) / 2,
              qrOffset.dy +
                  qrSize.height +
                  20), // Position at the center bottom with padding
        );

        // Save the modified image with the date created
        final modifiedImage = await recorder
            .endRecording()
            .toImage(decodedImage.width, decodedImage.height);
        final modifiedByteData =
            await modifiedImage.toByteData(format: ui.ImageByteFormat.png);
        final modifiedPngBytes = modifiedByteData!.buffer.asUint8List();

        final imgFile = File('$directory/$fileName');
        await imgFile.writeAsBytes(modifiedPngBytes);

        Navigator.pop(context); // Dismiss the loading indicator

        GallerySaver.saveImage(imgFile.path).then((success) async {
          if (success!) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image saved successfully'),
              ),
            );
          }
        });
      }
    }
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
      ..color = Colors.white
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
