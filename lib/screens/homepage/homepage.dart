import 'package:badges/badges.dart' as badges;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/cartController/cart_controller.dart';
import 'package:firebase_testing/screens/sideMenu/sideMenu_screen.dart';
import 'package:firebase_testing/screens/tabs/cart/cart_screen.dart';
import 'package:firebase_testing/screens/tabs/home_screen.dart';
import 'package:firebase_testing/screens/tabs/orders/order_screen.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/constants.dart';

import '../../utils/custom_text.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key, this.index = 0});
  int index;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> screens = [
    const HomeScreen(),
    const OrderScreen(),
    CartScreen(),
  ];

  List<Widget> icons = [
    Icon(
      Icons.home,
      color: white,
    ),
    Icon(
      Icons.delivery_dining,
      color: white,
    ),
    Icon(Icons.shopping_cart, color: white),
  ];
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.index;
    debugPrint("\nhomepage index: $selectedIndex");
    super.initState();
  }

  GlobalKey homepageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: selectedIndex == 0
          ? AppBar(
              centerTitle: true,
              title: customText(
                text: Constants.appName,
                fontSize: 20.sp,
                color: white,
                fontWeight: FontWeight.w700,
              ),
              actions: [
                cartIconWidget(),
              ],
              leading: IconButton(
                onPressed: () {
                  // Scaffold.of(context).openDrawer();
                  scaffoldKey.currentState!.openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: Icon(
                  Icons.view_list_rounded,
                  color: white,
                ),
              ),
            )
          : null,
      drawer: SideMenuScreen(),
      body: screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: primary,
        buttonBackgroundColor: primary,
        backgroundColor: transparent,
        key: homepageKey,
        index: selectedIndex,
        items: icons,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }

  Widget cartIconWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: badges.Badge(
        position: badges.BadgePosition.topEnd(top: -17.h, end: 3.h),
        showBadge: true,
        onTap: () {
          // Get.to(Homepage(index: 2));
          setState(() {
            selectedIndex = 2;
          });
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
