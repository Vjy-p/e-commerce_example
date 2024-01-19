import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/screens/auth/otp_screen.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customTextField.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final mobileLoginKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();
  final FocusNode numberFocus = FocusNode();
  List<String?> number = List.filled(1, '');

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(text: "Login"),
      body: Form(
        key: mobileLoginKey,
        onWillPop: () async => false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // customText(text: "Enter Mobile Number"),

              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: NumbertextFieldWidget(
                    isPhoneNumber: true,
                    context: context,
                    hint: 'Mobile Number',
                    controller: numberController,
                    holder: number,
                    currentFocus: numberFocus,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              ),

              customButton(
                  text: "Login",
                  onTap: () async {
                    validate();
                  }),
              // SizedBox(height: 100.h),
              // customButton(
              //     text: "Skip",
              //     onTap: () async {
              //       Get.offAll(Homepage());
              //     })
            ],
          ),
        ),
      ),
    );
  }

  validate() async {
    if (mobileLoginKey.currentState!.validate()) {
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => VerifyPhoneNumberScreen(
      //         phoneNumber: "+91${numberController.text}")));
      Get.off(
          OTPScreen(phoneNumber: "+91${numberController.text}"));
    }
  }
}
