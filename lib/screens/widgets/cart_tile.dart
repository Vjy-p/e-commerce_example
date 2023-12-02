import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/cartController/cart_controller.dart';
import 'package:firebase_testing/models/hive_cart_model.dart';
import 'package:firebase_testing/screens/category/product_details.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/custom_loading.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class CartTile extends StatelessWidget {
  CartTile({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.brand,
    required this.image,
    required this.discountPrice,
    required this.discountPercent,
    required this.total,
    required this.quantity,
    required this.rating,
  });
  int id;
  String title;
  String brand;
  String image;
  int price;
  double discountPercent;
  double discountPrice;
  int total;
  int quantity;
  double? rating;

  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: InkWell(
        onTap: () {
          Get.to(ProductDetails(productID: id, name: title));
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: primary)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: image != null && image != "NA" && image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: image,
                            width: 55.w,
                            height: 55.w,
                            fit: BoxFit.fill,
                            placeholder: (context, url) {
                              return CustomLoading().circularLoading();
                            },
                            errorWidget: (context, url, error) {
                              return SizedBox(
                                width: 55.w,
                                height: 55.w,
                                child: Icon(
                                  Icons.photo,
                                  color: primary,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            width: 55.w,
                            height: 55.w,
                            child: Icon(
                              Icons.photo,
                              color: primary,
                            ),
                          )),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(text: title, fontSize: 14.sp),
                    SizedBox(
                      height: 2.h,
                    ),
                    customText(
                      text: "$discountPercent % OFF",
                      color: green,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),

                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     customText(
                    //       text: "\u{20B9} $price",
                    //       fontSize: 12,
                    //       color: primary.withOpacity(0.5),
                    //       textDecoration: TextDecoration.lineThrough,
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     customText(
                    //       text: "\u{20B9} $discountPrice",
                    //       fontSize: 14,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customText(text: total.toString(), fontSize: 14.sp),
                  // SizedBox(
                  //   height: 2,
                  // ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: Alignment.center,
                      height: 30.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                cartController.updateToCart(HiveCartModel(
                                    id: id,
                                    title: title,
                                    price: price,
                                    discountPercentage: discountPercent,
                                    rating: rating,
                                    brand: brand,
                                    thumbnail: image,
                                    quantity: --quantity));
                              },
                              icon: Icon(
                                Icons.remove_circle_outline_rounded,
                                color: red,
                                size: 16.r,
                              )),
                          customText(
                            text: quantity.toString(),
                            fontSize: 16.sp,
                          ),
                          IconButton(
                              onPressed: () {
                                cartController.updateToCart(HiveCartModel(
                                    id: id,
                                    title: title,
                                    price: price,
                                    discountPercentage: discountPercent,
                                    rating: rating,
                                    brand: brand,
                                    thumbnail: image,
                                    quantity: ++quantity));
                              },
                              icon: Icon(
                                Icons.add_circle_outline_rounded,
                                color: green,
                                size: 16.sp,
                              ))
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
