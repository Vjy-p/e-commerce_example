import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/cartController/cart_controller.dart';
import 'package:firebase_testing/controller/userController/address_controller.dart';
import 'package:firebase_testing/models/Single_Product_Model.dart';
import 'package:firebase_testing/models/hive_cart_model.dart';
import 'package:firebase_testing/screens/category/shimmer_product_details.dart';
import 'package:firebase_testing/screens/homepage/homepage.dart';
import 'package:firebase_testing/services/ProductsService/Products_services.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/custom_loading.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails(
      {super.key, required this.productID, required this.name});
  final int productID;
  final String name;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ScrollController scrollController = ScrollController();
  SingleProductModel? productDetails;
  bool isLoading = false;
  bool isErrorLoading = true;
  int imageIndex = 0;
  CarouselController carouselController = CarouselController();
  bool addedToCart = false;
  final cartController = Get.put(CartController());
  int quantity = 1;

  @override
  void initState() {
    loadData();
    Get.put(AddressController()).selectAddress();
    super.initState();
  }

  loadData() {
    setState(() {
      isLoading = true;
    });
    ProductsServices().getProduct(widget.productID).then((response) {
      if (response != null) {
        productDetails = response;

        debugPrint("\nproduct Details: $productDetails");
        checkCart();
        setState(() {
          isLoading = false;
          isErrorLoading = false;
        });
      } else {
        debugPrint("\nresp: $response");
        setState(() {
          isLoading = false;
          isErrorLoading = true;
        });
      }
    });
  }

  checkCart() {
    setState(() {
      isLoading = true;
    });
    cartController.getData();
    var index = cartController.cartProducts
        .indexWhere((element) => element.id == productDetails!.id);
    debugPrint("\nindex : $index");
    if (index >= 0) {
      setState(() {
        addedToCart = true;
        quantity = cartController.cartProducts[index].quantity;
      });
    } else {
      addedToCart = false;
      quantity = 1;
      setState(() {});
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const ShimmerProductDetails()
        : isErrorLoading
            ? Center(
                child: customButton(
                    text: "Retry",
                    onTap: () {
                      loadData();
                    }),
              )
            : Scaffold(
                appBar: customAppBar(
                    leading: true,
                    text: widget.name,
                    actionWidget: [cartIconWidget()]),
                body: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(15.w),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imagesWidget(productDetails!.images),
                        texts(
                          name: productDetails!.title,
                          brandName: productDetails!.brand,
                          rating: productDetails!.rating,
                          price: productDetails!.price,
                          discount: productDetails!.discountPercentage,
                        ),
                        const Divider(),
                        addressWidget(),
                        description(description: productDetails!.description),
                      ]),
                ),
                bottomNavigationBar: bottomButton());
  }

  Widget imagesWidget(List imagesList) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: SizedBox(
        height: 180.h,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: CarouselSlider.builder(
              itemCount: imagesList.length,
              carouselController: carouselController,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // child: Image.network(imagesList[index]),
                  child: imagesList[index] != null &&
                          imagesList[index] != "NA" &&
                          imagesList[index].isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imagesList[index],
                          fit: BoxFit.contain,
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
                      : Container(),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.6,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    imageIndex = index;
                  });
                },
              ),
            )),
            SizedBox(
              height: 6.h,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imagesList.asMap().entries.map((e) {
                  return GestureDetector(
                    onTap: () {
                      carouselController.animateToPage(e.key);
                    },
                    child: Container(
                      width: imageIndex == e.key ? 8.w : 6.w,
                      height: imageIndex == e.key ? 8.w : 6.w,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary
                              .withOpacity(imageIndex == e.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList()),
          ],
        ),
      ),
    );
  }

  Widget texts(
      {required String name,
      required String brandName,
      required int price,
      required double discount,
      double? rating}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(text: "$brandName $name"),
        SizedBox(
          height: 8.h,
        ),
        rating != null
            ? RatingBarIndicator(
                itemCount: 5,
                rating: rating ?? 0,
                itemSize: 15.r,
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star,
                    color: amber,
                  );
                },
              )
            : const SizedBox(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: customText(
            text: "$discount% OFF",
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: green,
          ),
        ),
        customText(
          text: "\u{20B9} $price",
          fontSize: 13.sp,
        ),
      ],
    );
  }

  Widget description({required String description}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(text: "Details"),
          SizedBox(
            height: 2.h,
          ),
          customText(
            text: description,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: tColor.withOpacity(0.5),
          )
        ],
      ),
    );
  }

  Widget addressWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: primary.withOpacity(0.1),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      padding: EdgeInsets.all(10.w),
      child: Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5.w,
          runSpacing: 4.w,
          children: [
            Icon(
              Icons.door_front_door,
              color: bgColor,
              size: 20,
            ),
            customText(
              text: "Delivery to ",
              fontSize: 12.sp,
            ),
            Obx(() => customText(
                  text: "${Get.put(AddressController()).selectedAddress}",
                  fontSize: 12.sp,
                  color: tColor.withOpacity(0.5),
                )),
          ]),
    );
  }

  Widget bottomButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: isLoading
          ? CustomLoading().circularLoading()
          : addedToCart
              ? addRemoveButtons()
              : customIconButton(
                  icon: const Icon(Icons.shopping_basket),
                  text: "Add to Cart",
                  onTap: () {
                    cartController.addToCart(HiveCartModel(
                        id: productDetails!.id,
                        title: productDetails!.title,
                        price: productDetails!.price,
                        discountPercentage: productDetails!.discountPercentage,
                        rating: productDetails!.rating,
                        brand: productDetails!.brand,
                        thumbnail: productDetails!.thumbnail,
                        quantity: quantity));

                    setState(() {
                      addedToCart = true;
                    });
                    Get.offAll(Homepage(
                      index: 2,
                    ));
                  },
                ),
    );
  }

  Widget addRemoveButtons() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: primary)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.w),
        height: 55.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  cartController.updateToCart(HiveCartModel(
                      id: productDetails!.id,
                      title: productDetails!.title,
                      price: productDetails!.price,
                      discountPercentage: productDetails!.discountPercentage,
                      rating: productDetails!.rating,
                      brand: productDetails!.brand,
                      thumbnail: productDetails!.thumbnail,
                      quantity: --quantity));
                  if (quantity <= 1) {
                    addedToCart = false;
                    quantity = 1;
                  }
                  setState(() {});
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
                      id: productDetails!.id,
                      title: productDetails!.title,
                      price: productDetails!.price,
                      discountPercentage: productDetails!.discountPercentage,
                      rating: productDetails!.rating,
                      brand: productDetails!.brand,
                      thumbnail: productDetails!.thumbnail,
                      quantity: ++quantity));
                  setState(() {});
                },
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: green,
                  size: 16.r,
                ))
          ],
        ));
  }

  Widget cartIconWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: badges.Badge(
        position: badges.BadgePosition.topEnd(top: -17, end: 3),
        showBadge: true,
        onTap: () {
          Get.offAll(Homepage(index: 2));
        },
        badgeContent: Obx(() =>
            customText(text: "${Get.put(CartController()).totalCount.value}")),
        badgeStyle: badges.BadgeStyle(
          badgeColor: white,
        ),
        badgeAnimation: const badges.BadgeAnimation.rotation(),
        child: Icon(
          Icons.shopping_cart,
          color: white,
        ),
      ),
    );
  }
}
