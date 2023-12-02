import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/coupon_controller.dart';
import 'package:firebase_testing/models/coupon_model.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(leading: true, text: "Coupons"),
        body: GetBuilder<CouponController>(
            init: CouponController(),
            builder: (controller) {
              return ListView.builder(
                itemCount: controller.couponsList.length,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(12.w),
                itemBuilder: (context, index) {
                  return couponTile(details: controller.couponsList[index]);
                },
              );
            }));
  }

  Widget couponTile({required CouponModel details}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: amber),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              text: details.couponType.toLowerCase() == 'flat'
                  ? "FLAT ${details.flatAmount}  OFF"
                  : "${details.percentage} %  OFF",
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: customText(
                text:
                    "Place min ${details.minAmount} order and avail the Coupon Offer.",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            customText(
              text: details.couponType.toLowerCase() == 'flat'
                  ? " "
                  : "max Discount Amount is ${details.maxDiscount}",
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: bgColor)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: EdgeInsets.all(10.w),
                      child: customText(text: details.couponCode)),
                  IconButton(
                      onPressed: () {
                        Get.put(CouponController())
                            .selectCoupon(details.couponCode);
                        // customToast(context: context, text: "coupon copied");
                        Get.back();
                      },
                      icon: Icon(
                        Icons.copy_all,
                        color: secondary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
