import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/orderController/order_controller.dart';
import 'package:firebase_testing/models/hive_order_model.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/custom_loading.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class SingleOrderScreen extends StatefulWidget {
  SingleOrderScreen({super.key, required this.orderID});
  var orderID;

  @override
  _SingleOrderScreenState createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  final controller = Get.put(OrderController());
  ScrollController scrollcontroller = ScrollController();

  HiveOrderModel? orderDetails;
  bool isLoading = false;
  bool isErrorLoading = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    isLoading = true;
    setState(() {});

    controller.getOrderByID(widget.orderID).then((value) {
      if (value != null) {
        orderDetails = value;

        setState(() {
          isLoading = false;
          isErrorLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isErrorLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(text: "Order Details", leading: true),
      backgroundColor: white,
      body: isLoading
          ? CustomLoading().circularLoading()
          : isErrorLoading
              ? Center(
                  child: customButton(
                    text: "Retry",
                    onTap: () {
                      loadData();
                      setState(() {});
                    },
                  ),
                )
              : dataWidget(),
    );
  }

  Widget dataWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      controller: scrollcontroller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowWidget(title: "Order ID", description: orderDetails!.orderID),
          rowWidget(
              title: "Booking Date", description: orderDetails!.bookedDate),
          rowWidget(
              title: "Delivery Date", description: orderDetails!.deliveryDate),
          rowWidget(title: "Status", description: orderDetails!.status),
          rowWidget(
              title: "Total Items", description: orderDetails!.totalItems),
          rowWidget(title: "Amount", description: orderDetails!.totalPrice),
          buttons(),
          productsWidget(details: orderDetails!),
        ],
      ),
    );
  }

  Widget rowWidget({required String title, required var description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: customText(
                text: title, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Expanded(
            flex: 5,
            child: customText(
                text: "  $description",
                fontSize: 14,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customButton(
              width: 60,
              buttoncolor: transparent,
              borderColor: bgColor,
              color: secondary,
              text: "Raise a Complaint",
              onTap: () {}),
          customButton(
              width: 60,
              buttoncolor: transparent,
              borderColor: bgColor,
              color: secondary,
              text: "Feedback",
              onTap: () {})
        ],
      ),
    );
  }

  Widget productsWidget({required HiveOrderModel details}) {
    return ListView.builder(
      itemCount: details.products.length,
      shrinkWrap: true,
      controller: scrollcontroller,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Expanded(
                flex: 1,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    // child: Image.network(
                    //   details.products[index].thumbnail,
                    //   height: 40,
                    //   width: 40,
                    //   fit: BoxFit.fill,
                    // ),
                    child: details.products[index].thumbnail != null &&
                            details.products[index].thumbnail != "NA" &&
                            details.products[index].thumbnail.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: details.products[index].thumbnail,
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                            placeholder: (context, url) {
                              return CustomLoading().circularLoading();
                            },
                            // errorWidget: (context, url, error) {
                            //   return const CircleAvatar(
                            //     radius: 15,
                            //     child: Icon(
                            //       Icons.person,
                            //       size: 23,
                            //       color: AppColors.tTextColor,
                            //     ),
                            //   );
                            // },
                          )
                        : Container())),
            Expanded(
                flex: 5,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: details.products[index].title,
                          fontSize: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: customText(
                            text:
                                "${details.products[index].quantity} x ${details.products[index].price}",
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )))
          ]),
        );
      },
    );
  }
}
