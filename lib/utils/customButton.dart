// ignore_for_file: must_be_immutable, camel_case_types
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class customButton extends StatelessWidget {
  customButton({
    super.key,
    required this.text,
    required this.onTap,
    this.buttoncolor,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.fontSize,
    this.fontWeight,
  });
  String text;
  Function() onTap;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  Color? buttoncolor;
  Color? borderColor;
  double? width;
  double? height;
  double? borderRadius;
  TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(buttoncolor ?? buttonColor),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              side: BorderSide(color: borderColor ?? buttonColor))),
          minimumSize: MaterialStatePropertyAll(
              Size(width ?? double.infinity, height ?? 45)),
        ),
        onPressed: onTap,
        child: customText(
          text: text,
          color: color ?? tColor2,
          fontSize: fontSize,
          fontWeight: fontWeight,
          textDecoration: textDecoration,
        ));
  }
}

class customIconButton extends StatelessWidget {
  customIconButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.buttoncolor,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.fontSize,
    this.fontWeight,
  });
  String text;
  Function() onTap;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  Color? buttoncolor;
  Color? borderColor;
  double? width;
  double? height;
  double? borderRadius;
  TextDecoration? textDecoration;
  Widget icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(buttoncolor ?? buttonColor),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              side: BorderSide(color: borderColor ?? buttonColor))),
          iconColor: MaterialStatePropertyAll(color ?? tColor2),
          minimumSize: MaterialStatePropertyAll(
              Size(width ?? double.infinity, height ?? 45)),
        ),
        onPressed: onTap,
        icon: icon,
        label: customText(
          text: text,
          color: color ?? tColor2,
          fontSize: fontSize,
          fontWeight: fontWeight,
          textDecoration: textDecoration,
        ));
  }
}

Widget textButton({
  required Function() onTap,
  required String text,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  TextDecoration? textDecoration,
  TextAlign? textAlign,
}) {
  return InkWell(
    onTap: onTap,
    child: customText(
      text: text,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      textDecoration: textDecoration,
      textAlign: textAlign,
    ),
  );
}

Widget richTextButton({
  required Function() onTap,
  required String text1,
  required String text2,
  double? fontSize1,
  FontWeight? fontWeight1,
  Color? color1,
  TextDecoration? textDecoration1,
  TextAlign? textAlign,
  double? fontSize2,
  FontWeight? fontWeight2,
  Color? color2,
  TextDecoration? textDecoration2,
}) {
  return InkWell(
      onTap: onTap,
      child: AutoSizeText.rich(
        textAlign: textAlign,
        TextSpan(
            text: text1,
            style: customTextStyle(
              color: color1,
              fontSize: fontSize1,
              fontWeight: fontWeight1,
              textDecoration: textDecoration1,
            ),
            children: [
              TextSpan(
                text: text2,
                style: customTextStyle(
                  color: color2 ?? tColor2,
                  fontSize: fontSize2,
                  fontWeight: fontWeight2,
                  textDecoration: textDecoration2,
                ),
              )
            ]),
      ));
}
