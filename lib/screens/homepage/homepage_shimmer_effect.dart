import 'package:firebase_testing/screens/widgets/shimmer_horizontalTile.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget homepageShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: shimmerbaseColor,
    highlightColor: shimmerHighlightColor,
    enabled: true,
    child: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60.h,
              width: ScreenUtil().screenWidth * 1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r), color: bgColor),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 5.h),
              child: Container(
                height: 140.h,
                width: ScreenUtil().screenWidth * 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r), color: bgColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => CircleAvatar(
                        radius: 4.r,
                      )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
              child: Container(
                height: 10.h,
                width: ScreenUtil().screenWidth * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r), color: bgColor),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: REdgeInsets.only(bottom: 20.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 36.h,
                mainAxisSpacing: 6.h,
                crossAxisSpacing: 10.w,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  height: 10.h,
                  width: ScreenUtil().screenWidth * 1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r), color: bgColor),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Container(
                height: 10.h,
                width: ScreenUtil().screenWidth * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r), color: bgColor),
              ),
            ),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return shimmerHorizontalTile();
              },
            )
          ],
        ),
      ),
    ),
  );
}
