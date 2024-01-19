import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_testing/controller/cartController/cart_controller.dart';
import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/models/hive_order_model.dart';

class OrderController extends GetxController {
  RxList<HiveOrderModel> orderProducts = <HiveOrderModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
    
  }

  getData() async {
    isLoading(true);
    
    var orderDB = await Hive.openBox<HiveOrderModel>(orderStore);
    orderProducts = RxList.from(orderDB.values);
    debugPrint("\nordersLenght ${orderProducts.length}");
    isLoading(false);
    
    refresh();
   
  }

  addOrder(HiveOrderModel product) async {
    isLoading(true);
    
    var orderDB = await Hive.openBox<HiveOrderModel>(orderStore);

    if (orderDB.containsKey(product.orderID)) {
      updateOrder(order: product);
    } else {
      orderDB.put(product.orderID.toString(), product);
      getData();
      isLoading(false);
      
      debugPrint("\norder added $product");
    }
    isLoading(false);
   
    final cartController = Get.put(CartController());
    cartController.deleteCart();
    cartController.getData();

    refresh();
  }

  updateOrder({required HiveOrderModel order}) async {
    var orderDB = await Hive.openBox<HiveOrderModel>(orderStore);
    var index =
        orderProducts.indexWhere((element) => element.orderID == order.orderID);

    orderProducts[index] = order;

    orderDB.put(order.orderID.toString(), order);

    isLoading(false);
   
    refresh();
  }

  Future<HiveOrderModel> getOrderByID(id) async {
    var index = orderProducts.indexWhere((element) => element.orderID == id);

    return orderProducts[index];
  }
}
