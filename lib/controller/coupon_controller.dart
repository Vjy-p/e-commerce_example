import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/cartController/cart_controller.dart';
import 'package:firebase_testing/models/coupon_model.dart';

class CouponController extends GetxController {
  RxString couponCode = ''.obs;
  RxString errorText = ''.obs;
  RxInt discountedPrice = 0.obs;
  RxBool couponapplied = false.obs;

  List<CouponModel> couponsList = [
    CouponModel(
        couponType: "percentage",
        couponCode: "10PERC",
        percentage: 10,
        minAmount: 150,
        maxDiscount: 100),
    CouponModel(
        couponType: "flat",
        couponCode: "50FLAT",
        minAmount: 400,
        flatAmount: 50),
    CouponModel(
        couponType: "flat",
        couponCode: "100FLAT",
        minAmount: 1000,
        flatAmount: 100),
    CouponModel(
        couponType: "percentage",
        couponCode: "25PERC",
        percentage: 25,
        minAmount: 300,
        maxDiscount: 150),
  ];

  selectCoupon(code) {
    // Clipboard.setData(ClipboardData(text: code));
    clearCoupon();
    couponCode.value = code;
    debugPrint("\ncoupon selected: ${couponCode.value}");
    couponapplied.value = true;
    couponapplied.refresh();
    couponCode.refresh();
    validate(Get.put(CartController()).totalPrice.value);
    refresh();
    update();
  }

  // getCoupon() async {
  //   // ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
  //   // couponCode.value.text = data!.text!;
  //   debugPrint("\nselected coupon: ${couponCode.value}");
  // }

  validate(int amount) {
    debugPrint("\nprice: $amount");
    var min = couponsList
        .firstWhere((element) => element.couponCode == couponCode.value);

    if (min == null) {
      errorText.value = "Not Valid Coupon";

      refresh();
      update();
    } else if (amount < min.minAmount) {
      errorText.value = 'Amount Should be Greater Than ${min.minAmount}';

      refresh();
      update();
    } else {
      if (min.couponType.toLowerCase() == 'flat') {
        discountedPrice.value = min.flatAmount!;

        discountedPrice.refresh();
        Get.put(CartController()).count();
        refresh();
        update();
        debugPrint("\nflat amount : ${discountedPrice.value}");
      } else {
        int n = ((min.percentage! * amount) / 100).round();
        if (n > min.maxDiscount!.toInt()) {
          discountedPrice.value = min.maxDiscount!;
          discountedPrice.refresh();
          Get.put(CartController()).count();
          refresh();
          update();
          debugPrint("\ndiscount amount : ${discountedPrice.value}");
        } else {
          discountedPrice.value = n;
          discountedPrice.refresh();
          Get.put(CartController()).count();
          refresh();
          update();
          debugPrint("\ndiscount amount : ${discountedPrice.value}");
        }
      }

      refresh();
      update();
    }
  }

  clearCoupon() {
    errorText.value = '';
    couponCode.value = '';
    discountedPrice.value = 0;
    couponapplied.value = false;
    Get.put(CartController()).count();
    errorText.refresh();
    refresh();
    update();
  }
}
