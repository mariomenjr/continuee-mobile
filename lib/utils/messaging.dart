import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:continuee_mobile/extensions/Device.extension.dart';
import 'package:continuee_mobile/utils/api.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class Messaging {
  static Messaging? _instance;

  factory Messaging() => _instance ?? Messaging._();

  Messaging._() {
    this.initialize();
    _instance = this;
  }

  void initialize() async {
    await this.initializeFirebase();
    await this.initializeContinuee();
  }

  FirebaseMessaging? fcm;

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
    var resp = await Api()
        .post("device/identify", data: await DeviceFactory.getLocal());
    print(resp.data);

    // TODO: What will happen if it fails?
  }
}
