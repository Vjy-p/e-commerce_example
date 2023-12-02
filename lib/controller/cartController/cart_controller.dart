import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_testing/controller/coupon_controller.dart';
import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/models/hive_cart_model.dart';

class CartController extends GetxController {
  RxInt totalPrice = 0.obs;
  RxInt totalCount = 0.obs;
  List<HiveCartModel> cartProducts = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();

    refresh();
    update();
  }

  getData() async {
    isLoading(true);
    isLoading.refresh();
    var cartDB = await Hive.openBox<HiveCartModel>(cartStore);
    cartProducts = cartDB.values.toList();
    count();
    isLoading(false);
    isLoading.refresh();
    refresh();
    update();
  }

  addToCart(HiveCartModel product) async {
    isLoading(true);
    isLoading.refresh();
    var cartDB = await Hive.openBox<HiveCartModel>(cartStore);
    if (cartDB.containsKey(product.id.toString())) {
      updateToCart(product);
    } else {
      cartProducts.add(product);
      count();
      cartDB.put(product.id.toString(), product);

      isLoading(false);
      isLoading.refresh();

      refresh();
      update();
      debugPrint("\nproduct added $product");
    }
    isLoading(false);
    isLoading.refresh();
  }

  count() {
    totalPrice.value = 0;
    totalCount.value = 0;
    for (var i in cartProducts) {
      totalPrice.value += (i.quantity * i.price);
      totalCount.value += (i.quantity);
    }
    if (Get.put(CouponController()).couponapplied.value) {
      totalPrice.value -= Get.put(CouponController()).discountedPrice.value;
    }
    totalPrice.refresh();
    totalCount.refresh();

    debugPrint("\ntotal price: $totalPrice");
  }

  updateToCart(HiveCartModel product) async {
    isLoading(true);
    isLoading.refresh();
    var cartDB = await Hive.openBox<HiveCartModel>(cartStore);

    if (product.quantity <= 0) {
      cartProducts.removeWhere((element) => element.id == product.id);
      // int index =
      //     cartProducts.indexWhere((element) => element.id == product.id);
      // cartDB.deleteAt(index);
      count();
      cartDB.delete(product.id.toString());

      refresh();
      update();
      debugPrint("\nupdated : ${cartProducts}");
    } else {
      int index =
          cartProducts.indexWhere((element) => element.id == product.id);
      cartProducts[index] = product;
      refresh();
      count();
      cartDB.put(product.id.toString(), product);

      refresh();
      update();
      debugPrint("\nupdated : ${cartProducts.length}");
    }

    isLoading(false);
    isLoading.refresh();
  }

  deleteCart() async {
    var cartDB = await Hive.openBox<HiveCartModel>(cartStore);

    for (var product in cartDB.values) {
      cartDB.delete(product.id.toString());
    }
    cartProducts.clear();

    refresh();
    update();
    debugPrint("\ndeleted : ${cartProducts.length}");
  }
}
