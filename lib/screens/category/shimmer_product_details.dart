import 'package:firebase_testing/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductDetails extends StatelessWidget {
  const ShimmerProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Shimmer.fromColors(
          baseColor: shimmerbaseColor,
          highlightColor: shimmerHighlightColor,
          enabled: true,
          child: Container(
            height: 20.h,
            width: ScreenUtil().screenWidth * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r), color: bgColor),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Shimmer.fromColors(
            baseColor: shimmerbaseColor,
            highlightColor: shimmerHighlightColor,
            enabled: true,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: black.withOpacity(0.5),
              size: 20.r,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Shimmer.fromColors(
              baseColor: shimmerbaseColor,
              highlightColor: shimmerHighlightColor,
              enabled: true,
              child: Container(
                height: 20.w,
                width: 20.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r), color: bgColor),
              ),
            ),
          )
        ],
      ),
      body: Shimmer.fromColors(
        baseColor: shimmerbaseColor,
        highlightColor: shimmerHighlightColor,
        enabled: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.w),
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            imagesWidget(),
            texts(),
            const Divider(),
            addressWidget(),
            description(),
          ]),
        ),
      ),
      bottomNavigationBar: bottomButton(),
    );
  }

  Widget imagesWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: SizedBox(
        height: 180.h,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Container(
                height: 150.h,
                width: ScreenUtil().screenWidth * 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r), color: bgColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => Container(
                        width: 7.w,
                        height: 7.w,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: bgColor),
                      )),
            ),
          ],
        ),
      ),
    );
  }

  Widget texts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10.h,
          width: ScreenUtil().screenWidth * 0.7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r), color: bgColor),
        ),
        SizedBox(
          height: 8.h,
        ),
        Container(
          height: 10.h,
          width: ScreenUtil().screenWidth * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r), color: bgColor),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Container(
            height: 10.h,
            width: ScreenUtil().screenWidth * 0.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r), color: bgColor),
          ),
        ),
        Container(
          height: 10.h,
          width: ScreenUtil().screenWidth * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r), color: bgColor),
        ),
      ],
    );
  }

  Widget description() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10.h,
            width: ScreenUtil().screenWidth * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.r), color: bgColor),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            height: 6.h,
            width: ScreenUtil().screenWidth * 1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r), color: bgColor),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Container(
              height: 6.h,
              width: ScreenUtil().screenWidth * 1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r), color: bgColor),
            ),
          ),
          Container(
            height: 6.h,
            width: ScreenUtil().screenWidth * 1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r), color: bgColor),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Container(
              height: 6.h,
              width: ScreenUtil().screenWidth * 1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r), color: bgColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressWidget() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        children: [
          Icon(
            Icons.door_front_door,
            color: bgColor,
            size: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w, right: 5.w),
            child: Container(
              height: 8.h,
              width: ScreenUtil().screenWidth * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r), color: bgColor),
            ),
          ),
          Expanded(
            child: Container(
              height: 8.h,
              width: ScreenUtil().screenWidth * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r), color: bgColor),
            ),
          ),
        ],
      ),
      Container(
        height: 8.h,
        width: ScreenUtil().screenWidth * 1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r), color: bgColor),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Container(
          height: 8.h,
          width: ScreenUtil().screenWidth * 1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r), color: bgColor),
        ),
      ),
      Container(
        height: 8.h,
        width: ScreenUtil().screenWidth * 1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r), color: bgColor),
      ),
    ]);
  }

  Widget bottomButton() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          height: 50.h,
          width: ScreenUtil().screenWidth * 1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r), color: bgColor),
        ));
  }
}
