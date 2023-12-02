import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:firebase_testing/controller/userController/user_controller.dart';
import 'package:firebase_testing/screens/auth/mobile_login.dart';
import 'package:firebase_testing/screens/homepage/homepage.dart';
import 'package:firebase_testing/services/userServices/user_services.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customToast.dart';
import 'package:firebase_testing/utils/custom_loading.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  final String phoneNumber;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;
  TextEditingController otpController = TextEditingController();
  final FocusNode otpFocus = FocusNode();
  List<String?> otp = List.filled(1, '');
  final otpKey = GlobalKey<FormState>();

  @override
  void initState() {
    scrollController = ScrollController();
    debugPrint("\nmobile number: ${widget.phoneNumber}");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary,
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: false,
        sendOtpOnInitialize: true,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        otpExpirationDuration: const Duration(seconds: 60),
        onCodeSent: () {
          debugPrint("\n OTP sent! ");
        },
        onLoginSuccess: (userCredential, autoVerified) async {
          onloginSuccess(userCredential);
        },
        onLoginFailed: (authException, stackTrace) {
          loginFailed(authException);
        },
        onError: (error, stackTrace) {
          debugPrint("\nerror $error ");
          customToast(context: context, text: 'An error occurred!');
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: customAppBar(
              text: 'Verify Phone Number',
            ),
            body: controller.isSendingCode
                ? sendingOTPwidget()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20.w),
                    controller: scrollController,
                    child: Form(
                      key: otpKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              color: buttonColor,
                            ),
                          ),
                          otpBoxes(),
                          controller.isOtpExpired
                              ? const SizedBox()
                              : customButton(
                                  text: "Verify",
                                  onTap: () async {
                                    if (otpKey.currentState!.validate()) {
                                      final verified = await controller
                                          .verifyOtp(otpController.text);
                                      if (verified) {
                                        debugPrint("\nverified");
                                        // number verify success
                                        // will call onLoginSuccess handler
                                      } else {
                                        // phone verification failed
                                        // will call onLoginFailed or onError callbacks with the error
                                      }
                                    }
                                  },
                                ),
                          if (controller.codeSent) ...[
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: controller.isOtpExpired
                                    ? () async {
                                        debugPrint('\nResend OTP');
                                        await controller.sendOTP();
                                      }
                                    : null,
                                child: customText(
                                  text: controller.isOtpExpired
                                      ? 'Resend'
                                      : '${controller.otpExpirationTimeLeft.inSeconds}s',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  onloginSuccess(UserCredential userCredential) {
    debugPrint("\n OTP sent!");

    customToast(text: 'Phone number verified successfully!', context: context);

    debugPrint("\n'Login Success UID: ${userCredential.user?.uid}'");
    Get.put(UserController()).setMobileNumber(widget.phoneNumber);
    UserServices().setToken();
    Get.offAll(Homepage());
  }

  loginFailed(authException) {
    debugPrint("\nerror ${authException.message}");

    switch (authException.code) {
      case 'invalid-phone-number':
        customToast(context: context, text: 'Invalid phone number!');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MobileLogin()));
        break;
      case 'invalid-verification-code':
        return customToast(
            context: context, text: 'The entered OTP is invalid!');

      default:
        customToast(context: context, text: 'Something went wrong!');
        Get.offAll(const MobileLogin());
        break;
    }
  }

  Widget sendingOTPwidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomLoading().circularLoading(),
        const SizedBox(height: 50),
        Center(
          child: customText(text: 'Sending OTP', fontSize: 18),
        ),
      ],
    );
  }

  Widget textWidget() {
    return customText(
      text:
          "We've sent an SMS with a verification code to ${widget.phoneNumber}",
    );
  }

  Widget otpBoxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: 'Enter OTP',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: PinCodeTextField(
            length: 6,
            controller: otpController,
            animationCurve: Curves.easeIn,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            validator: (value) => validate(),
            enablePinAutofill: true,
            enableActiveFill: true,
            useExternalAutoFillGroup: true,
            textStyle: customTextStyle(),
            keyboardType: TextInputType.number,
            autoFocus: true,
            pastedTextStyle: customTextStyle(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            pinTheme: PinTheme.defaults(
              borderRadius: BorderRadius.circular(6),
              fieldWidth: 50.w,
              fieldHeight: 50.w,
              shape: PinCodeFieldShape.box,
              activeColor: bgColor,
              activeFillColor: bgColor,
              inactiveColor: bgColor,
              inactiveFillColor: bgColor,
              disabledColor: bgColor,
              selectedColor: bgColor,
              selectedFillColor: bgColor,
              errorBorderColor: red,
            ),
            appContext: context,
          ),
        ),
      ],
    );
  }

  validate() {
    if (otpController.text == null || otpController.text.isEmpty) {
      return "OTP shouldn't be Empty";
    } else if (otpController.text.length < 6) {
      return "OTP shouldn't be lessthan 6";
    }
  }
}
