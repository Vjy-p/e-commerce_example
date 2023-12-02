import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/services/userServices/user_services.dart';

class UserController extends GetxController {
  RxString number = ''.obs;
  RxString userName = ''.obs;
  RxString deliveryID = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  load() async {
    var userDB = await Hive.openBox(userStore);
    return userDB;
  }

  Future<String> getMobileNumber() async {
    var userDB = await Hive.openBox(userStore);
    number.value = userDB.get('mobileNumber') ?? '0';

    number.refresh();
    return number.value;
  }

  setMobileNumber(mobileNumber) async {
    var userDB = await Hive.openBox(userStore);
    userDB.put('mobileNumber', mobileNumber);
    number.value = userDB.get('mobileNumber');
    number.refresh();
    debugPrint("\nnumber stored: ${number.value}");
    return number.value;
  }

  saveName(name) async {
    var userDB = await Hive.openBox(userStore);
    userDB.put('name', name);
    userName.value = userDB.get('name');
    userName.refresh();
    debugPrint("\nname stored: ${userName.value}");

    var user = FirebaseAuth.instance.currentUser; //firebase save
    user!.updateDisplayName(name);
  }

  getUserName() async {
    var userDB = await Hive.openBox(userStore);
    userName.value = userDB.get('name') ?? 'user name';
    userName.refresh();

    return userName.value;
  }

  setNotificationCount() async {
    var userDB = await Hive.openBox(userStore);

    int notificationCount = userDB.get('notificationCount') ?? 0;
    notificationCount++;
    userDB.put('notificationCount', notificationCount);

    refresh();
    update();

    debugPrint("\nnotifications count $notificationCount");
  }

  getNotifyCount() async {
    var userDB = await Hive.openBox(userStore);
    var count = userDB.get('notificationCount');
    return count;
  }

  logout() async {
    var userDB = await Hive.openBox(userStore);
    userDB.put('mobileNumber', '0');
    UserServices().signOut();
  }

  getDeliveryAddressID() {
    var userDB = Hive.box(userStore);
    if (userDB.containsKey('deliveryID')) {
      deliveryID.value = userDB.get('deliveryID');
    }

    deliveryID.refresh();
    update();

    return deliveryID.value;
  }
}
