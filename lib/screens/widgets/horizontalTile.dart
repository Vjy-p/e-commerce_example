import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/custom_loading.dart';
import 'package:firebase_testing/utils/custom_text.dart';

Widget HorizontalTile({
  required String icon,
  required String brandName,
  required String title,
  required int price,
  required double discount,
  double? rating,
  required Function() onTap,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: primary)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    alignment: Alignment.center,
                    child: icon != null && icon != "NA" && icon.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: icon,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return CustomLoading().circularLoading();
                            },
                            errorWidget: (context, url, error) {
                              return SizedBox(
                                width: 40.w,
                                height: 40.w,
                                child: Icon(
                                  Icons.photo,
                                  color: primary,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: Icon(
                              Icons.photo,
                              color: primary,
                            ),
                          ))),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customText(text: "$brandName $title"),
                  SizedBox(
                    height: 2.h,
                  ),
                  rating != null
                      ? RatingBarIndicator(
                          itemCount: 5,
                          rating: rating ?? 0,
                          itemSize: 15.r,
                          itemBuilder: (context, index) {
                            return Icon(
                              Icons.star,
                              color: amber,
                            );
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 2,
                  ),
                  customText(
                    text: "$discount % OFF",
                    color: green,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  customText(
                    text: "\u{20B9} $price",
                    fontSize: 12.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
