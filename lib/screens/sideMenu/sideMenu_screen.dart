import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/userController/user_controller.dart';
import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/screens/account/profile_screen.dart';
import 'package:firebase_testing/screens/address/address_screen.dart';
import 'package:firebase_testing/screens/chat/chat_screen.dart';
import 'package:firebase_testing/screens/coupon/coupons_screen.dart';
import 'package:firebase_testing/screens/webview/webview_screen.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class SideMenuScreen extends StatefulWidget {
  SideMenuScreen({super.key});

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  final userController = Get.put(UserController());
  bool showContact = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
                },
              ),
              Divider(
                color: primary,
              ),
              optionsWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget header({required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: primary),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: CircleAvatar(
                radius: 30.r,
                child: const Icon(Icons.person),
              ),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => customText(
                          text: userController.userName.value,
                        )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Obx(() => customText(
                          text: userController.number.value,
                          fontSize: 14.sp,
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget optionsWidget(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          customTile(
              icon: Icon(
                Icons.local_offer,
                color: amber,
                size: 20.r,
              ),
              title: "Coupons",
              onTap: () {
                Get.to(const CouponScreen());
              }),
          customTile(
              icon: Icon(
                Icons.location_pin,
                color: tColor.withOpacity(0.5),
                size: 20.r,
              ),
              title: "Address",
              onTap: () {
                Get.to(const AddressScreen());
              }),
          customTile(
              icon: Icon(
                Icons.settings,
                color: tColor.withOpacity(0.5),
                size: 20.r,
              ),
              title: "Settings",
              onTap: () {}),
          customTile(
              icon: Icon(
                Icons.chat,
                color: tColor.withOpacity(0.5),
                size: 20.r,
              ),
              title: "Chat",
              onTap: () {
                Get.to(const ChatScreen());
                // Get.to(const ChatScreenStreams());
              }),
          contactWidget(),
          customTile(
              icon: Icon(
                Icons.web,
                color: tColor.withOpacity(0.5),
                size: 20.r,
              ),
              title: "Webview",
              onTap: () {
                Get.to(WebViewScreen());
              }),
          customTile(
              icon: Icon(
                Icons.logout,
                color: tColor.withOpacity(0.5),
                size: 20.r,
              ),
              title: "Logout",
              onTap: () {
                alertBox(context);
              }),
        ],
      ),
    );
  }

  Widget contactWidget() {
    return showContact == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customTile(
                  icon: Icon(
                    Icons.contact_support_outlined,
                    color: tColor.withOpacity(0.5),
                    size: 20.r,
                  ),
                  title: "Contact us",
                  onTap: () {
                    setState(() {
                      showContact = !showContact;
                    });
                  }),
              if (showContact) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: customTile(
                      fontSize: 14.sp,
                      padding: 2.h,
                      icon: Icon(
                        Icons.email,
                        color: tColor.withOpacity(0.5),
                        size: 20.r,
                      ),
                      title: "ecommerce@support.com",
                      onTap: () {}),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
                  child: customTile(
                      fontSize: 14.sp,
                      padding: 2.h,
                      icon: Icon(
                        Icons.call,
                        color: tColor.withOpacity(0.5),
                        size: 20.r,
                      ),
                      title: "022 1234567",
                      onTap: () {}),
                ),
              ]
            ],
          )
        : customTile(
            icon: Icon(
              Icons.contact_support_outlined,
              color: tColor.withOpacity(0.5),
              size: 20.r,
            ),
            title: "Contact us",
            onTap: () {
              setState(() {
                showContact = !showContact;
              });
            });
  }

  Widget customTile(
      {required icon,
      required String title,
      double? fontSize,
      double? padding,
      required Function() onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding ?? 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: icon),
              Expanded(
                  flex: 5,
                  child: customText(
                    text: title,
                    fontSize: fontSize ?? 16.sp,
                    textAlign: TextAlign.start,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  alertBox(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
            padding: EdgeInsets.all(8.r),
            child: Dialog(
              backgroundColor: white,
              insetPadding: EdgeInsets.all(6.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              child: Container(
                width: Get.width,
                height: 200.h,
                padding: EdgeInsets.all(12.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    customText(
                      text: "Are you sure to log Out?",
                      fontSize: 20.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: customButton(
                                text: "Yes",
                                onTap: () {
                                  userController.logout();
                                  Get.offAll(const SplashScreen());
                                  Get.back();
                                }),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: customButton(
                                text: "No",
                                onTap: () {
                                  Get.back();
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
