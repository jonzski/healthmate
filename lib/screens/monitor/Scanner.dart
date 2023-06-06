import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../provider/auth_provider.dart';
import '../../provider/log_provider.dart';
import '../../provider/entry_provider.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  Barcode? result;
  bool? isQrvalid;
  QRViewController? controller;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText = "Scan QR Code";
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 4, child: _buildQrView(context)),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    if (controller != null && mounted) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }

    String _location = context.read<LogProvider>().location;
    String currentUserUid = context.read<AuthProvider>().currentUser.uid;
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;

    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: const Color(0xFF526bf2),
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea,
            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          Center(
            child: (result != null)
                ? FutureBuilder(
                    future: context.read<EntryProvider>().validateQRCode(
                        result!.code!, currentUserUid, _location),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        controller!.pauseCamera();
                        return Center(
                          child: Text("Error encountered! ${snapshot.error}"),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        controller!.pauseCamera();
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData && snapshot.data == true) {
                        // Pop the screen
                        controller!.pauseCamera();
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          controller!.dispose();
                          Navigator.pop(context);
                        });
                        return Container();
                      } else {}
                      return Text(qrText);
                    },
                  )
                : Text(qrText),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller!.dispose();
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 50,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.flip_camera_android),
              onPressed: () {
                controller!.flipCamera();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
