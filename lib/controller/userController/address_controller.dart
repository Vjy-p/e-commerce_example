import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:firebase_testing/controller/userController/user_controller.dart';
import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/models/hive_address_model.dart';

class AddressController extends GetxController {
  RxList<HiveAddressModel> addressList = <HiveAddressModel>[].obs;
  RxString selectedAddress = ''.obs;

  @override
  onInit() {
    getAddress();
    super.onInit();
  }

  saveAddress({required HiveAddressModel address}) {
    // addressList.add(HiveAddressModel(id: addressList.length, address: address));
    // addressList.refresh();
    debugPrint("\naddress id: ${address.id}");
    var addressDB = Hive.box<HiveAddressModel>('address');

    addressDB.put(address.id, address);
    changeDeliveryAddress(id: address.id);
    getAddress();
    addressList.refresh();

    debugPrint("\naddress stored: $addressList");
  }

  getAddress() {
    var addressDB = Hive.box<HiveAddressModel>('address');
    debugPrint("\naddress keys ${addressDB.keys}");
    addressList = RxList.from(addressDB.values);
    addressList = RxList.from(addressList.reversed);
    addressList.refresh();

    debugPrint("\nstored address: ${addressList}");
    return addressList;
  }

  deleteAddress(index) {
    if (addressList.isNotEmpty) {
      var addressDB = Hive.box<HiveAddressModel>('address');
      addressDB.delete(index);
      debugPrint("\ndeleted $addressList");

      getAddress();
      addressList.refresh();
      
      refresh();
    }
  }

  changeDeliveryAddress({required String id}) async {
    var userDB = await Hive.openBox(userStore);
    userDB.put('deliveryID', id);
    final user = Get.put(UserController());
    user.deliveryID.value = userDB.get('deliveryID');
    user.deliveryID.refresh();
    selectAddress();
    debugPrint("\ndelivery ID: ${user.deliveryID.value}");
  }

  selectAddress() {
    var addressDB = Hive.box<HiveAddressModel>('address');
    var id = Get.put(UserController()).getDeliveryAddressID() ?? ' ';

    if (addressDB.containsKey(id)) {
      var add = addressDB.get(id);
      var text = '';
      if (add!.optional == null || add.optional.isEmpty) {
        text = " ";
      } else {
        text = add.optional + ",";
      }

      selectedAddress.value = add!.flatNumber +
          "," +
          text +
          add.buildingName +
          "," +
          add.colonyRoadName +
          "," +
          add.landmark +
          "," +
          add.area +
          "," +
          add.pincode +
          ".";
    }

    debugPrint("\nselected Address: ${selectedAddress.value}");

    selectedAddress.refresh();
   
  }
}
