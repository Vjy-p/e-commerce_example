// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/custom_text.dart';

PreferredSizeWidget customAppBar(
    {required String text,
    Color? bgColor,
    Color? textColor,
    List<Widget>? actionWidget,
    bool leading = false}) {
  return AppBar(
    backgroundColor: bgColor,
    automaticallyImplyLeading: leading,
    centerTitle: true,
    title: customText(
      text: text,
      color: textColor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    leading: leading
        ? IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: black.withOpacity(0.5),
              size: 20,
            ),
          )
        : null,
    actions: actionWidget,
  );
}
