import 'package:flutter/material.dart';

import 'package:firebase_testing/models/CartModel.dart';
import 'package:firebase_testing/models/orderModel.dart';

class CartProvider {
  int totalPrice = 0;
  int totalCount = 0;
  bool isLoadiing = false;
  bool errorLoading = false;
  List<CartModel> cartProducts = [];
  List<OrderModel> orders = [];

  init() {
    // debugPrint("\nstorage keys: ${box.getValues()}");
    // if (box.read('orders') != null) {
    //   orders = List.from(box.read('orders'));
    //   debugPrint("\nstorage orders: ${box.getValues()}");
    // }
    // if (box.read('carts') != null) {
    //   cartProducts = List.from(box.read('carts'));
    //   debugPrint("\nstorage carts: ${box.getValues()}");
    // }
  }

  addToCart(CartModel product) {
    isLoadiing = true;

    if (cartProducts.where((element) => element.id == product.id) == true) {
      updateToCart(product);
    } else {
      cartProducts.add(product);
      debugPrint("\nproduct added");
      count();

      isLoadiing = false;
    }
  }

  count() {
    totalPrice = 0;
    totalCount = 0;
    for (var i in cartProducts) {
      totalPrice += (i.quantity * i.price);
      totalCount += (i.quantity);
      debugPrint("\ntotal price: $totalPrice");
    }
  }

  updateToCart(CartModel product) {
    if (product.quantity <= 0) {
      cartProducts.removeWhere((element) => element.id == product.id);
      count();
    } else {
      int index =
          cartProducts.indexWhere((element) => element.id == product.id);
      cartProducts[index] = product;
      count();
    }
  }

  addOrder(OrderModel order) {
    orders.add(order);
    // box.write('carts', List.from(cartProducts));
    // box.write('orders', orders);
    // debugPrint("\nstorage order: ${box.read('orders')}");
  }
}
