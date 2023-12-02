import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/models/Products_Model.dart';
import 'package:firebase_testing/screens/category/product_details.dart';
import 'package:firebase_testing/screens/category/single_category_screen.dart';
import 'package:firebase_testing/screens/homepage/homepage_shimmer_effect.dart';
import 'package:firebase_testing/screens/widgets/bannerWidget.dart';
import 'package:firebase_testing/screens/widgets/horizontalTile.dart';
import 'package:firebase_testing/services/ProductsService/Products_services.dart';
import 'package:firebase_testing/services/categoriesServices/Category_Services.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isErrorLoading = false;
  bool searchLoading = false;
  var categoriesList;
  List<Widget> BannerList = [
    BannerWidget(),
    BannerWidget(),
    BannerWidget(),
    BannerWidget(),
    BannerWidget(),
  ];
  int bannerIndex = 0;
  CarouselController carouselController = CarouselController();
  bool fullcategories = false;

  SearchController searchController = SearchController();
  List<Products> searchList = [];

  List<Products> trendingList = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    setState(() {
      isLoading = true;
      isErrorLoading = false;
    });
    CategoryServices().getAllCategories().then((value) {
      if (value != null) {
        categoriesList = value;

        getTrendingData();
        setState(() {
          isLoading = false;
          isErrorLoading = false;
        });
      } else {
        debugPrint("\nError $value");
        setState(() {
          isLoading = false;
          isErrorLoading = true;
        });
      }
    });
  }

  searchData() {
    ProductsServices().getSearchData(searchController.text).then((value) {
      if (value != null) {
        ProductsModel data = value;
        searchList = data.products;
        debugPrint("\nsearch data: $searchList");
        setState(() {});
      } else {}
    });
  }

  getTrendingData() {
    setState(() {
      isLoading = true;
      isErrorLoading = false;
    });
    ProductsServices().getAllProducts().then((value) {
      if (mounted) {
        if (value != null) {
          ProductsModel data = value;
          trendingList = data.products;
          debugPrint("\ntrending data: $trendingList");
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? homepageShimmerEffect()
          : isErrorLoading
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 35.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(text: "Something went wrong,Try agian."),
                      SizedBox(
                        height: 25.h,
                      ),
                      customButton(
                        onTap: () {
                          loadData();
                        },
                        text: "Retry",
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(15.w),
                  child: Column(
                    children: [
                      searchWidget(),
                      carouselWidget(),
                      categoriesWidget(),
                      trendingWidget(),
                    ],
                  ),
                ),
    );
  }

  Widget searchWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: SearchAnchor.bar(
        searchController: searchController,
        isFullScreen: true,
        barElevation: const MaterialStatePropertyAll(0),
        barShape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
              side: BorderSide(color: primary)),
        ),
        barHintText: "search",
        barHintStyle: MaterialStatePropertyAll(customTextStyle(
            color: tColor.withOpacity(0.5), fontWeight: FontWeight.w400)),
        barTextStyle: MaterialStatePropertyAll(customTextStyle()),
        barLeading: Icon(
          Icons.search_outlined,
          color: black.withOpacity(0.5),
        ),
        viewLeading: IconButton(
            onPressed: () {
              searchController.clear();
              Get.back();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: black.withOpacity(0.5),
              size: 16.r,
            )),
        viewTrailing: [
          IconButton(
            onPressed: () {
              searchController.clear();
              searchList.clear();
              setState(() {});
            },
            icon: Icon(Icons.close, color: black.withOpacity(0.5), size: 20.r),
          ),
        ],
        onTap: () {
          if (searchController.text.length >= 3) {
            searchData();
          }
        },
        suggestionsBuilder: (context, controller) {
          if (searchController.text.length >= 3) {
            searchData();
          }
          return List.generate(searchList.length, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: HorizontalTile(
                icon: searchList[index].thumbnail,
                brandName: searchList[index].brand,
                title: searchList[index].title,
                price: searchList[index].price,
                discount: searchList[index].discountPercentage.toDouble(),
                onTap: () {
                  Get.to(ProductDetails(
                      productID: searchList[index].id,
                      name: searchList[index].title));
                },
              ),
            );
          });
        },
      ),
    );
  }

  Widget carouselWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          CarouselSlider(
            items: BannerList,
            carouselController: carouselController,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.4,
              enlargeCenterPage: true,
              viewportFraction: 1,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              onPageChanged: (index, reason) {
                setState(() {
                  bannerIndex = index;
                });
              },
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: BannerList.asMap().entries.map((e) {
                return GestureDetector(
                  onTap: () {
                    carouselController.animateToPage(e.key);
                  },
                  child: Container(
                    width: bannerIndex == e.key ? 8.w : 6.w,
                    height: bannerIndex == e.key ? 8.w : 6.w,
                    margin:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tColor
                            .withOpacity(bannerIndex == e.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList()),
        ],
      ),
    );
  }

  Widget categoriesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(text: "Categories"),
        SizedBox(
          height: 10.h,
        ),
        GridView.builder(
          itemCount: fullcategories ? categoriesList.length : 5,
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.w,
            mainAxisExtent: 40.h,
          ),
          itemBuilder: (context, index) {
            if (!fullcategories && (index == 4)) {
              return categoryListTile(
                name: "View More",
                onTap: () {
                  setState(() {
                    fullcategories = true;
                  });
                },
              );
            }
            return categoryListTile(
              name: categoriesList[index],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SingleCategoryScreen(
                        categoryName: categoriesList[index])));
              },
            );
          },
        )
      ],
    );
  }

  Widget categoryListTile({required String name, required Function() onTap}) {
    // return Container(
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(6),
    //       border: Border.all(color: primary)),
    //   padding: EdgeInsets.all(6),
    //   alignment: Alignment.center,
    //   child: customText(text: name),
    // );
    return customButton(text: name, onTap: onTap);
  }

  Widget trendingWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: customText(text: "Trending")),
          ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: trendingList.length,
            itemBuilder: (context, index) {
              return HorizontalTile(
                  icon: trendingList[index].thumbnail,
                  brandName: trendingList[index].brand,
                  title: trendingList[index].title,
                  price: trendingList[index].price,
                  discount: trendingList[index].discountPercentage.toDouble(),
                  onTap: () {
                    Get.to(ProductDetails(
                        productID: trendingList[index].id,
                        name: trendingList[index].title));
                  });
            },
          )
        ],
      ),
    );
  }
}
