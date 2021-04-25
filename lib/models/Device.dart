import 'package:json_annotation/json_annotation.dart';
import './DevicePlatform.dart';

part 'Device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device {
  Device(this.uid, this.manufacturer, this.brand, this.registrationToken,
      this.platform);

  String uid;
  String manufacturer;
  String brand;
  String registrationToken;
  DevicePlatform platform;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$DeviceToJson`.
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
