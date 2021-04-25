import 'package:json_annotation/json_annotation.dart';

part 'DevicePlatform.g.dart';

@JsonSerializable(explicitToJson: true)
class DevicePlatform {
  DevicePlatform(this.name, this.ver);

  String name;
  String ver;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory DevicePlatform.fromJson(Map<String, dynamic> json) =>
      _$DevicePlatformFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$DevicePlatformToJson`.
  Map<String, dynamic> toJson() => _$DevicePlatformToJson(this);
}
