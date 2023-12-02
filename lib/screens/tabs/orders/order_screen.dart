import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/orderController/order_controller.dart';
import 'package:firebase_testing/models/hive_order_model.dart';
import 'package:firebase_testing/screens/tabs/orders/single_order_screen.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/custom_loading.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final orderController = Get.put(OrderController());
  @override
  initState() {
    orderController.getData();
    debugPrint("\norder length ${orderController.orderProducts.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(text: "Orders"),
        // body: GetBuilder<OrderController>(
        //     init: OrderController(),
        //     builder: (controller) {
        //       if (controller.isLoading.value) {
        //         return CustomLoading().circularLoading();
        //       }
        //       if (controller.isLoading == false &&
        //           controller.orderProducts.isEmpty) {
        //         return Center(child: customText(text: "Order is Empty"));
        //       }

        //       return RefreshIndicator.adaptive(
        //         onRefresh: () async {
        //           await Future.delayed(const Duration(microseconds: 300), () {
        //             setState(() {
        //               List<HiveOrderModel> orders =
        //                   List.from(controller.orderProducts.reversed);
        //             });
        //           });
        //         },
        //         child: ListView.builder(
        //           physics: const BouncingScrollPhysics(),
        //           padding: const EdgeInsets.all(8),
        //           itemCount: controller.orderProducts.length,
        //           itemBuilder: (context, index) {
        //             List<HiveOrderModel> orders =
        //                 List.from(controller.orderProducts.reversed);
        //             debugPrint(
        //                 "\norder ${controller.orderProducts[index].totalItems}");
        //             return listTile(orders[index]);
        //           },
        //         ),
        //       );
        // }),
        body: Obx(
          () => orderController.isLoading == true
              ? CustomLoading().circularLoading()
              : Obx(() => orderController.orderProducts.isEmpty
                  ? Center(child: customText(text: "Order is Empty"))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: orderController.orderProducts.length,
                      itemBuilder: (context, index) {
                        RxList<HiveOrderModel> orders =
                            orderController.orderProducts;
                        List v = orders.reversed.toList();

                        return listTile(v[index]);
                      },
                    )),
        ));
  }

  Widget listTile(HiveOrderModel details) {
    debugPrint("\norder products ${details.products.length}");
    return details.products.length == 0
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: primary),
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primary),
                    color: white),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                        text: "Order ID: ${details.orderID}", fontSize: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: details.products.first.thumbnail,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return CustomLoading().circularLoading();
                                },
                                errorWidget: (context, url, error) {
                                  return SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.photo,
                                      color: primary,
                                    ),
                                  );
                                },
                              )),
                          Flexible(
                            child: customText(
                              text: details.products.isEmpty
                                  ? " "
                                  : "  ${details.products.first.title}",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          customText(
                            text: details.products.isEmpty ||
                                    details.products.length <= 1
                                ? " "
                                : "  + ${details.products.length - 1} products",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        child: textButton(
                            fontSize: 14,
                            textDecoration: TextDecoration.underline,
                            text: "View Details",
                            color: secondary,
                            onTap: () {
                              Get.to(SingleOrderScreen(
                                orderID: details.orderID,
                              ));
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  // Widget listTile(HiveOrderModel details) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: ExpansionTile(
  //         childrenPadding: const EdgeInsets.all(10),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(6),
  //             side: BorderSide(color: primary)),
  //         collapsedShape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(6),
  //             side: BorderSide(color: primary)),
  //         title: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             customText(text: "Order ID: ${details.orderID}", fontSize: 16),
  //           ],
  //         ),
  //         children: List.generate(
  //             details.products.length,
  //             (index) => Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: Row(children: [
  //                     Expanded(
  //                         flex: 1,
  //                         child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(4),
  //                             child: Image.network(
  //                               details.products[index].thumbnail,
  //                               height: 40,
  //                             ))),
  //                     Expanded(
  //                       flex: 5,
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left: 10),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             customText(
  //                               text: details.products[index].title,
  //                               fontSize: 14,
  //                             ),
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(vertical: 4),
  //                               child: customText(
  //                                 text:
  //                                     "${details.products[index].quantity} x ${details.products[index].price}",
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ]),
  //                 ))),
  //   );
  // }
}
