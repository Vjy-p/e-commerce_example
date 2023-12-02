import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'hive_address_model.g.dart';

@HiveType(typeId: 3)
class HiveAddressModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String flatNumber;

  @HiveField(2)
  String optional;

  @HiveField(3)
  String buildingName;

  @HiveField(4)
  String colonyRoadName;

  @HiveField(5)
  String landmark;

  @HiveField(6)
  String area;

  @HiveField(7)
  String pincode;

  HiveAddressModel(
      {required this.id,
      required this.flatNumber,
      required this.optional,
      required this.buildingName,
      required this.colonyRoadName,
      required this.landmark,
      required this.area,
      required this.pincode});
}
