// ignore_for_file: camel_case_types, must_be_immutable
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_testing/utils/colors.dart';

class customText extends StatelessWidget {
  customText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.textAlign,
    this.overflow,
  });
  String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  TextDecoration? textDecoration;
  TextAlign? textAlign;
  TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: GoogleFonts.robotoFlex(
        color: color ?? tColor,
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.w600,
        decoration: textDecoration,
        decorationColor: color ?? tColor,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

TextStyle customTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  TextDecoration? textDecoration,
}) {
  return GoogleFonts.robotoFlex(
    color: color ?? tColor,
    fontSize: fontSize ?? 16.sp,
    fontWeight: fontWeight ?? FontWeight.w600,
    decoration: textDecoration,
  );
}
