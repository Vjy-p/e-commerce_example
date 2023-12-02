import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/models/Products_Model.dart';
import 'package:firebase_testing/screens/category/product_details.dart';
import 'package:firebase_testing/screens/widgets/horizontalTile.dart';
import 'package:firebase_testing/screens/widgets/shimmer_horizontalTile.dart';
import 'package:firebase_testing/services/categoriesServices/Category_Services.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';

class SingleCategoryScreen extends StatefulWidget {
  SingleCategoryScreen({super.key, required this.categoryName});
  String categoryName;

  @override
  State<SingleCategoryScreen> createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  ScrollController scrollController = ScrollController();
  ProductsModel? details;
  List<Products> products = [];
  bool isLoading = false;
  bool isErrorLoading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    setState(() {
      isLoading = true;
    });
    CategoryServices().getCategory(widget.categoryName).then((response) {
      if (response != null) {
        details = response;
        products = details!.products;
        debugPrint("\nresp: $products");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(text: widget.categoryName, leading: true),
      body: isLoading
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return shimmerHorizontalTile();
              },
            )
          : isErrorLoading
              ? Center(
                  child: customButton(
                      text: "Retry",
                      onTap: () {
                        loadData();
                      }),
                )
              : ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: products.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return HorizontalTile(
                      icon: products[index].thumbnail,
                      brandName: products[index].brand,
                      title: products[index].title,
                      price: products[index].price,
                      discount: products[index].discountPercentage.toDouble(),
                      rating: products[index].rating!.toDouble(),
                      onTap: () {
                        Get.to(ProductDetails(
                            productID: products[index].id,
                            name: products[index].title));
                      },
                    );
                  },
                ),
    );
  }
}
