import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/cartController/cart_controller.dart';
import 'package:firebase_testing/screens/payment/payment_screen.dart';
import 'package:firebase_testing/screens/widgets/cart_tile.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/custom_loading.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ScrollController scrollController = ScrollController();
  final cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    debugPrint("\ncart Products: ${cartController.cartProducts}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(text: "cart"),
      body:
          // cartController.isLoading == true
          //     ? const Center(
          //         child: CircularProgressIndicator.adaptive(),
          //       )
          //     : cartController.errorLoading == true
          //         ? Center(
          //             child: customButton(
          //               text: "Retry",
          //               onTap: () {},
          //             ),
          //           )
          //         :
          GetBuilder<CartController>(
              init: CartController(),
              builder: (controller) {
                if (controller.isLoading.value) {
                  return CustomLoading().circularLoading();
                }
                if (controller.isLoading.value == false &&
                    controller.cartProducts.isEmpty) {
                  return Center(child: customText(text: "Cart is Empty"));
                }
                return Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    children: [
                      cartButton(controller),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.cartProducts.length,
                          itemBuilder: (_, index) {
                            return CartTile(
                              id: controller.cartProducts[index].id,
                              title: controller.cartProducts[index].title,
                              image: controller.cartProducts[index].thumbnail,
                              brand: controller.cartProducts[index].brand,
                              rating: controller.cartProducts[index].rating,
                              price: controller.cartProducts[index].price,
                              discountPrice: controller
                                  .cartProducts[index].discountPercentage,
                              discountPercent: controller
                                  .cartProducts[index].discountPercentage,
                              total: controller.cartProducts[index].price,
                              quantity: controller.cartProducts[index].quantity,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }

  Widget cartButton(controller) {
    return controller.totalPrice.value == 0
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => customIconButton(
                        icon: const Icon(Icons.shopping_basket),
                        text:
                            "Proceed  \u{20B9} ${controller.totalPrice.value}",
                        onTap: () {
                          // var date = DateFormat("d/M/y hh:mm:ss a")
                          //     .format(DateTime.now());

                          // var v = date.split('/').join();
                          // v = v.split(':').join().removeAllWhitespace;
                          // v = v.substring(0, v.length - 2);

                          // final orderController = Get.put(OrderController());
                          // orderController.addOrder(
                          //   HiveOrderModel(
                          //     orderID: int.parse(v),
                          //     bookedDate: date.toString(),
                          //     deliveryDate: date.toString(),
                          //     totalPrice: controller.totalPrice.value.toInt(),
                          //     totalItems: controller.totalCount.value,
                          //     status: "confirmed",
                          //     products: controller.cartProducts,
                          //   ),
                          // );
                          Get.to(PaymentScreen());
                          // Get.to(Homepage(index: 2));
                        }),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  flex: 1,
                  child: customIconButton(
                      text: "Clear",
                      icon: Icon(
                        Icons.delete,
                        color: red,
                      ),
                      onTap: () {
                        controller.deleteCart();
                      }),
                )
              ],
            ),
          );
  }
}
