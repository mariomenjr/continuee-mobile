import 'dart:io';

import 'package:continuee_mobile/extensions/Device.extension.dart';
import 'package:continuee_mobile/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanSync extends StatefulWidget {
  const ScanSync({Key? key}) : super(key: key);

  @override
  State<ScanSync> createState() => _ScanSyncState();
}

class _ScanSyncState extends State<ScanSync> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_ScanSync');

  QRViewController? qrvController;

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = MediaQuery.of(context).size.width * 0.9;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 5,
          borderLength: 50,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    var triesCount = 0;
    this.qrvController = controller;

    controller.scannedDataStream.listen((scanData) async {
      this.qrvController?.stopCamera();

      // TODO: Handle possible errors

      var device = await DeviceFactory.getLocal();
      var r = await Api().put("chain/joinChain", data: {
        "syncCode": "${scanData.code}",
        "device": device,
        "token": scanData.code
      });

      print("chain/joinChain: ${r.data}");

      Navigator.pop(this.context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Joined to ${r.data["chainName"]}")),
      );
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera permission granted')),
      );
    }
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) qrvController!.pauseCamera();
    qrvController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final scanCamera = Expanded(flex: 4, child: _buildQrView(context));

    return Scaffold(body: Column(children: <Widget>[scanCamera]));
  }

  @override
  void dispose() {
    this.qrvController?.dispose();
    super.dispose();
  }
}
