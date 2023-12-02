import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:firebase_testing/controller/cartController/cart_controller.dart';
import 'package:firebase_testing/controller/coupon_controller.dart';
import 'package:firebase_testing/controller/orderController/order_controller.dart';
import 'package:firebase_testing/models/hive_order_model.dart';
import 'package:firebase_testing/models/payment_model.dart';
import 'package:firebase_testing/screens/coupon/coupons_screen.dart';
import 'package:firebase_testing/screens/homepage/homepage.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customTextField.dart';
import 'package:firebase_testing/utils/customToast.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ScrollController scrollController = ScrollController();
  final paymentKey = GlobalKey<FormState>();
  var selectedPayment = '';

  List<PaymentModel> upiList = [
    // PaymentModel(icon: "assets/images/freecharge.png", title: "freecharge"),
    PaymentModel(icon: "assets/images/upi.png", title: "BHIM UPI"),
    PaymentModel(icon: "assets/images/Paytm.png", title: "Paytm"),
    PaymentModel(icon: "assets/images/amazonpay.png", title: "Amazon Pay"),
    PaymentModel(icon: "assets/images/phonepay.png", title: "Phone Pay"),
    PaymentModel(icon: "assets/images/gpay.png", title: "Google Pay"),
    PaymentModel(icon: "assets/images/cred.png", title: "Cred"),
  ];

  List<PaymentModel> cardList = [
    // PaymentModel(icon: "assets/images/freecharge.png", title: "freecharge"),
    PaymentModel(icon: "assets/images/debit.png", title: "DEBIT CARD"),
    PaymentModel(icon: "assets/images/credit.png", title: "CREDIT CARD"),
  ];

  @override
  void initState() {
    super.initState();
  }

  final couponController = Get.put(CouponController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(leading: true, text: "Payment Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        child: Form(
          key: paymentKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(text: "Payment Options", fontSize: 17.sp),
              paymentOptionWidget(title: "UPI", list: upiList),
              paymentOptionWidget(title: "Card pay", list: cardList),
              couponBox(),
              addressWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: EdgeInsets.all(12.w),
          child: customButton(
              text: "Pay  ${Get.put(CartController()).totalPrice.value}",
              onTap: () {
                validate();
              }),
        ),
      ),
    );
  }

  Widget addressWidget() {
    return textFieldWidget(
        validation: false,
        context: context,
        hint: "Note",
        minLines: 3,
        maxLines: 3,
        prefixIcon: SizedBox(
          width: 10.w,
          child: Align(
            alignment: FractionalOffset(0.55.w, -0.15.h),
            child: Image.asset(
              "assets/images/gpay.png",
              height: 19.r,
              width: 19.r,
              fit: BoxFit.contain,
            ),
          ),
        ));
  }

  Widget paymentOptionWidget(
      {required String title, required List<PaymentModel> list}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            width: double.infinity,
            decoration: BoxDecoration(color: bgColor),
            child: customText(text: title, fontSize: 15.sp),
          ),
          ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            controller: scrollController,
            itemBuilder: (context, index) {
              return paymentTile(details: list[index]);
            },
          )
        ],
      ),
    );
  }

  Widget paymentTile({required PaymentModel details}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPayment = details.title;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                // width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: white,
                    border: Border.all(
                        color: selectedPayment == details.title
                            ? primary
                            : black)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                padding: EdgeInsets.all(2.w),
                child: selectedPayment == details.title
                    ? Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: primary),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                      )
                    : const SizedBox(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Image.asset(
                details.icon,
                height: 20.h,
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              flex: 5,
              child: customText(
                text: details.title,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget couponBox() {
    return Obx(
      () => Column(
        children: [
          couponController.couponapplied.value
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                          color: couponController.errorText.value.isEmpty
                              ? secondary
                              : red)),
                  padding: EdgeInsets.all(12.w),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: amber,
                                size: 20.r,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15.w),
                                child: customText(
                                  text: couponController.couponCode.value,
                                  fontSize: 14.sp,
                                  color: amber,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: textButton(
                              fontSize: 14.sp,
                              color: red,
                              onTap: () {
                                couponController.clearCoupon();
                                setState(() {});
                              },
                              text: "Remove",
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      textButton(
                          fontWeight: FontWeight.w400,
                          onTap: () {
                            Get.to(const CouponScreen());
                            setState(() {});
                          },
                          text: "view more coupons"),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: secondary)),
                  padding: EdgeInsets.all(12.w),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {
                      Get.to(const CouponScreen());
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: amber,
                          size: 20.r,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: customText(
                            text: "Apply Coupon",
                            color: orange,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: couponController.errorText.value.isEmpty
                ? const SizedBox()
                : customText(
                    text: couponController.errorText.value,
                    color: red,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
          ),
        ],
      ),
    );
  }

  borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
    );
  }

  validate() {
    final controller = Get.put(CartController());
    if (paymentKey.currentState!.validate() && selectedPayment.isNotEmpty) {
      var date = DateFormat("d/M/y hh:mm:ss a").format(DateTime.now());

      var v = date.split('/').join();
      v = v.split(':').join().removeAllWhitespace;
      v = v.substring(0, v.length - 2);

      final orderController = Get.put(OrderController());
      orderController.addOrder(
        HiveOrderModel(
          orderID: int.parse(v),
          bookedDate: date.toString(),
          deliveryDate: date.toString(),
          totalPrice: controller.totalPrice.value.toInt(),
          totalItems: controller.totalCount.value,
          status: "confirmed",
          products: controller.cartProducts,
        ),
      );
      Get.offAll(Homepage(
        index: 2,
      ));
    } else {
      customToast(context: context, text: "Select Payment Method");
    }
  }
}
