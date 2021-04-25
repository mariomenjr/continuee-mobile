import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class Messaging {
  static Messaging _instance;

  Messaging._internal() {
    this.initializeConnection();
    _instance = this;
  }

  factory Messaging() => _instance ?? Messaging._internal();

  FirebaseMessaging fcm;

  void initializeConnection() async {
    print(dotenv.env["continuee-server"]);

    await this.initializeFirebase();
    await this.initializeContinuee();
  }

  Future initializeFirebase() async {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          print('${message.notification.title}');
          // TODO: Show an alert (by a callback?)
          // showDialog(
          //     context: context,
          //     builder: (ctx) => AlertDialog(
          //           content: ListTile(
          //             title: Text('${message.notification.title}'),
          //             subtitle: Text('${message.notification.body}'),
          //           ),
          //           actions: <Widget>[
          //             FlatButton(
          //               child: Text('Ok'),
          //               onPressed: () => Navigator.of(context).pop(),
          //             ),
          //           ],
          //         ));
        }
      });

      await Firebase.initializeApp();
      this.fcm = FirebaseMessaging.instance;
    } catch (e) {}
  }

  Future initializeContinuee() async {
    var device = await DeviceInfoPlugin().androidInfo;
    var token = await this.fcm.getToken();
    var resp = await http.post(
        Uri.parse("${dotenv.env["continuee-server"]}/device/identify"),
        body: {
          'uid': device.androidId,
          'manufacturer': device.manufacturer,
          'brand': device.model,
          'registrationToken': token
        });

    print(resp.body);
  }
}
