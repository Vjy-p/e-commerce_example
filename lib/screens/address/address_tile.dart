import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/userController/address_controller.dart';
import 'package:firebase_testing/controller/userController/user_controller.dart';
import 'package:firebase_testing/models/hive_address_model.dart';
import 'package:firebase_testing/screens/address/address_form_screen.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customToast.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class AddressTile extends StatefulWidget {
  AddressTile({super.key, required this.details});
  HiveAddressModel details;

  @override
  State<AddressTile> createState() => _AddressTileState();
}

class _AddressTileState extends State<AddressTile>
    with SingleTickerProviderStateMixin {
  bool delete = false;

  final userController = Get.put(UserController());
  final _addressController = Get.put(AddressController());

  late AnimationController animationController;
  late Animation<Offset> animation;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    animation =
        Tween<Offset>(begin: const Offset(0, 0.0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: animationController, curve: Curves.bounceInOut));
  }

  move({required double value}) {
    animation =
        Tween<Offset>(begin: const Offset(0, 0.0), end: Offset(value ?? 0.0, 0))
            .animate(CurvedAnimation(
                parent: animationController,
                curve: Curves.easeInOutCubicEmphasized));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return addressTile(details: widget.details);
  }

  Widget addressTile({required HiveAddressModel details}) {
    var add = '';
    if (details.optional == null || details.optional.isEmpty) {
      add = " ";
    } else {
      add = details.optional + ",";
    }

    var address = details!.flatNumber +
        "," +
        add +
        details.buildingName +
        "," +
        details.colonyRoadName +
        "," +
        details.landmark +
        "," +
        details.area +
        "," +
        details.pincode +
        ".";
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {
          Get.to(AddressFormScreen(
            id: details.id,
          ));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: tColor2),
                        color: tColor2),
                    padding: const EdgeInsets.all(7),
                    child: IconButton(
                      onPressed: () {
                        if (userController.deliveryID == details.id) {
                          customToast(
                              context: context,
                              text:
                                  "You can't Delete the Selected Address,Change selected address and retry.");
                        } else {
                          setState(() {
                            delete = true;
                          });
                          _addressController.deleteAddress(details.id);
                          // Get.back();
                          customToast(
                              context: context, text: "Address Deleted");
                          // alertBox(id: details.id);
                        }
                      },
                      icon: const Icon(Icons.delete_forever),
                      color: red,
                    ))),
            SlideTransition(
              position: animation,
              child: Container(
                width: Get.width * 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: primary),
                    color: primary),
                padding: EdgeInsets.only(right: 6.w),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: primary),
                      color: white),
                  padding: EdgeInsets.all(6.w),
                  child: Row(
                    children: [
                      Obx(() {
                        return Radio.adaptive(
                          value: details.id,
                          groupValue: userController.deliveryID.value,
                          onChanged: (value) {
                            setState(() {
                              _addressController.changeDeliveryAddress(
                                  id: details.id);
                            });
                          },
                        );
                      }),
                      Expanded(
                          child: customText(
                        text: address,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      )),
                      delete
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  delete = false;
                                  move(value: 0);
                                });
                              },
                              icon: const Icon(Icons.keyboard_arrow_right),
                              color: green,
                            )
                          : IconButton(
                              onPressed: () {
                                if (userController.deliveryID == details.id) {
                                  customToast(
                                      context: context,
                                      text:
                                          "You can't Delete the Selected Address,Change selected address and retry.");
                                } else {
                                  setState(() {
                                    delete = true;
                                  });
                                  move(value: -0.15);
                                  // alertBox(id: details.id);
                                }
                              },
                              icon: const Icon(Icons.delete_forever),
                              color: red,
                            )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  alertBox({required String id}) {
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
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    customText(text: "Are you shure to Delete?"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        customButton(
                            width: 40.w,
                            text: "Yes",
                            onTap: () {
                              _addressController.deleteAddress(id);
                              Get.back();
                              customToast(
                                  context: context, text: "Address Deleted");
                            }),
                        customButton(
                            width: 40.w,
                            text: "No ",
                            onTap: () {
                              Get.back();
                            })
                      ],
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
