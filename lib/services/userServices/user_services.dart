import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_testing/main.dart';

class UserServices {
  Box userDB = Hive.box(userStore);

  setToken() async {
    final idtoken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("\nfcm token  $fcmToken\nid token $idtoken");

    // var box = await collection.openBox('userDB');
    // box.put('token', fcmToken ?? '');
    userDB.put('fcmToken', fcmToken);
    return fcmToken;
  }

  getToken() {
    // var box = await collection.openBox('userDB');
    // box.get('token');
    var fcmToken = userDB.get('fcmToken');
    return fcmToken;
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
