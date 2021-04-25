import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:continuee_mobile/models/Device.dart';
import 'package:continuee_mobile/models/DevicePlatform.dart';
import 'package:continuee_mobile/utils/api.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class Messaging {
  static Messaging? _instance;

  Messaging._internal() {
    this.initializeConnection();
    _instance = this;
  }

  factory Messaging() => _instance ?? Messaging._internal();

  FirebaseMessaging? fcm;

  void initializeConnection() async {
    await this.initializeFirebase();
    await this.initializeContinuee();
  }

  Future initializeFirebase() async {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          print('${message.notification?.title}');
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
    var token = await this.fcm?.getToken();

    var resp = await Api().post("device/identify",
        data: new Device(
            device.androidId,
            device.manufacturer,
            device.model,
            token.toString(),
            new DevicePlatform(
                Platform.operatingSystem, Platform.operatingSystemVersion)));
    print(Device.fromJson(resp.data));
  }
}
