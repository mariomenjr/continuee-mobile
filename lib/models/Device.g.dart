// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) {
  return Device(
    json['uid'] as String,
    json['manufacturer'] as String,
    json['brand'] as String,
    json['registrationToken'] as String,
    DevicePlatform.fromJson(json['platform'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'uid': instance.uid,
      'manufacturer': instance.manufacturer,
      'brand': instance.brand,
      'registrationToken': instance.registrationToken,
      'platform': instance.platform.toJson(),
    };
