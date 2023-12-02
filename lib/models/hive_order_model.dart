import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_testing/models/hive_cart_model.dart';

part 'hive_order_model.g.dart';

@HiveType(typeId: 1)
class HiveOrderModel {
  @HiveField(0)
  int orderID;

  @HiveField(1)
  int totalPrice;

  @HiveField(2)
  int totalItems;

  @HiveField(3)
  String bookedDate;

  @HiveField(4)
  String deliveryDate;

  @HiveField(5)
  String status;

  @HiveField(6)
  List<HiveCartModel> products;

  HiveOrderModel({
    required this.orderID,
    required this.bookedDate,
    required this.deliveryDate,
    required this.totalPrice,
    required this.totalItems,
    required this.status,
    required this.products,
  });
}
