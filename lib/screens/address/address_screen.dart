import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/userController/address_controller.dart';
import 'package:firebase_testing/controller/userController/user_controller.dart';
import 'package:firebase_testing/screens/address/address_form_screen.dart';
import 'package:firebase_testing/screens/address/address_tile.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  TextEditingController addressController = TextEditingController();
  final FocusNode addressFocus = FocusNode();
  List<String?> address = List.filled(1, '');

  @override
  initState() {
    super.initState();
    loadData();
  }

  loadData() {
    _addressController.getAddress();
    userController.getDeliveryAddressID();
  }

  final userController = Get.put(UserController());
  final _addressController = Get.put(AddressController());

  @override
  void dispose() {
    addressController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(leading: true, text: "Address"),
      body: GetBuilder<AddressController>(
        init: AddressController(),
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customButton(
                    text: "Add Address",
                    onTap: () {
                      Get.to(AddressFormScreen());
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: customText(text: "Saved Address"),
                ),
                addressWidget(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget addressWidget(controller) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      shrinkWrap: true,
      itemCount: controller.addressList.length,
      itemBuilder: (context, index) {
        return AddressTile(details: controller.addressList[index]);
      },
    );
  }
}
