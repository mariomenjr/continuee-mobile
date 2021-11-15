import 'package:continuee_mobile/extensions/Device.extension.dart';
import 'package:continuee_mobile/pages/CreateChain.dart';
import 'package:continuee_mobile/pages/ScanSync.dart';
import 'package:continuee_mobile/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import 'package:continuee_mobile/utils/messaging.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  runApp(new MaterialApp(
      title: 'Continuee',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new MyApp()));
}

class MyApp extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  Messaging _messaging = Messaging();

  // Define an async function to initialize FlutterFire
  void initializeFirebase() async {
    try {} catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFirebase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // // Show error message if initialization failed
    if (_error) {
      print("Error $_error");
    }

    // // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      print("Loading...");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Continuee"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  var r = await Api().get("chain/generateSync");
                  print("chain/generateSync: ${r.data}");
                  // TODO: Consider encrypting r.data.sync or, even better..., all r.data.
                  // TODO: Catch possible errors

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => CreateChain(
                                syncCode: "${r.data["sync"]}",
                                chainName: "${r.data["name"]}",
                              )));
                },
                child: Text("Create Sync Chain")),
            TextButton(
                onPressed: () async {
                  // var device = await DeviceFactory.getLocal();
                  // var r = await Api().put("chain/joinChain",
                  //     data: {"deviceUid": "${device.uid}"});
                  // print("chain/joinChain: ${r.data}");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => ScanSync()));
                },
                child: Text("Join Chain")),
            TextButton(
                onPressed: () async {
                  var token = await this._messaging.fcm?.getToken();
                  var r = await Api()
                      .get("firebase/share?registrationToken=$token");
                  print("continuee-server: ${r.data}");
                },
                child: Text("Try Share"))
          ],
        ),
      ),
    );
  }
}
