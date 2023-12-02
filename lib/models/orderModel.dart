import 'package:firebase_testing/models/CartModel.dart';

class OrderModel {
  int orderID;
  int totalPrice;
  int totalItems;
  String bookedDate;
  String deliveryDate;
  List<CartModel> products;
  OrderModel({
    required this.orderID,
    required this.bookedDate,
    required this.deliveryDate,
    required this.totalPrice,
    required this.totalItems,
    required this.products,
  });
}
