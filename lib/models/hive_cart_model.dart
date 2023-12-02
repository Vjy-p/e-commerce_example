import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'hive_cart_model.g.dart';

@HiveType(typeId: 0)
class HiveCartModel {
  HiveCartModel({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
    required this.thumbnail,
    required this.quantity,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int price;

  @HiveField(3)
  double discountPercentage;

  @HiveField(4)
  double? rating;

  @HiveField(5)
  String brand;

  @HiveField(6)
  String thumbnail;

  @HiveField(7)
  int quantity;
}
