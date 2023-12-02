import 'package:flutter/material.dart';

import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/custom_text.dart';

customToast({required context, required String text}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      duration: const Duration(seconds: 2),
      content: customText(text: text, textAlign: TextAlign.center),
      backgroundColor: buttonColor,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
