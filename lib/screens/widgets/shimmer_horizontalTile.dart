import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:firebase_testing/utils/colors.dart';

Widget shimmerHorizontalTile() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Shimmer.fromColors(
      baseColor: shimmerbaseColor,
      highlightColor: shimmerHighlightColor,
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(color: bgColor)),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: bgColor,
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 12.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.r),
                              color: bgColor)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Container(
                            height: 12.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.r),
                                color: bgColor)),
                      ),
                      Container(
                        height: 12.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.r),
                            color: bgColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Container(
                            height: 12.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.r),
                                color: bgColor)),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    ),
  );
}
