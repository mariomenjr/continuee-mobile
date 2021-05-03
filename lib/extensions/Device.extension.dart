import 'dart:io';

import 'package:continuee_mobile/models/DevicePlatform.dart';
import 'package:continuee_mobile/utils/messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:continuee_mobile/models/Device.dart';

extension DeviceFactory on Device {
  static Future<Device> getLocal() async {
    var device = await DeviceInfoPlugin().androidInfo;
    var token = await Messaging().fcm?.getToken();

    return new Device(
        device.androidId,
        device.manufacturer,
        device.model,
        token.toString(),
        new DevicePlatform(
            Platform.operatingSystem, Platform.operatingSystemVersion));
  }
}
