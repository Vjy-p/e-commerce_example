import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_testing/utils/colors.dart';

Widget BannerWidget() {
  return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: cyan),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [],
        ),
      ));
}
