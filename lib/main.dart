import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  FirebaseMessaging _messaging;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    content: ListTile(
                      title: Text('${message.notification.title}'),
                      subtitle: Text('${message.notification.body}'),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ));
        }
      });

      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
      this._messaging = FirebaseMessaging.instance;
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Continuee"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  this._messaging.getToken().then((token) => http
                      .get(Uri.parse(
                          "http://10.0.2.2:3010/firebase/share?registrationToken=$token"))
                      // "http://192.168.0:3010/send-to-device?registrationToken=$token"))
                      // "https://continuee.mariomenjr.com/firebase/share?registrationToken=$token"))
                      .then((json) => print("Data: $json")));
                },
                child: Text("Share link"))
          ],
        ),
      ),
    );
  }
}
