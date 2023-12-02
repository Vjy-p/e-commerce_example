import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_testing/screens/auth/login_screen.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customTextField.dart';
import 'package:firebase_testing/utils/customToast.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  List<String?> email = List.filled(1, '');

  TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  List<String?> password = List.filled(1, '');

  bool isLoading = false;

  late final StreamSubscription _firebaseStreamEvents;

  @override
  initState() {
    _firebaseStreamEvents =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint("\nuser $user");
      if (user != null) {
        //    if (user.emailVerified) {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => const MultiAuthPage(),
        //     ),
        //   );
        // } else {
        //   user.sendEmailVerification();
        // }
        user.sendEmailVerification();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _firebaseStreamEvents.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              customText(text: "SignUp"),
              const SizedBox(
                height: 50,
              ),
              textFieldWidget(
                context: context,
                hint: "Email",
                controller: emailController,
                holder: email,
                currentFocus: emailFocus,
                nextFocus: passwordFocus,
              ),
              const SizedBox(
                height: 16,
              ),
              PasswordtextFieldWidget(
                hint: "Password",
                controller: passwordController,
                holder: password,
                currentFocus: passwordFocus,
              ),
              const SizedBox(
                height: 20,
              ),
              customButton(
                text: "Login",
                onTap: () async {
                  validate();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              richTextButton(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                },
                text1: "Have an Account? ",
                color1: tColor.withOpacity(0.4),
                text2: "Login",
              ),
            ],
          ),
        ),
      )),
    );
  }

  validate() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        debugPrint("\nresponse: $value");
        customToast(context: context, text: "Verify Email to Login");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
      FirebaseAuth.instance.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        debugPrint('The password provided is too weak.');
        customToast(
            context: context, text: "The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        debugPrint('An account already exists for that email.');
        customToast(
            context: context,
            text: "An account already exists for that email.");
      }
    } catch (e) {
      debugPrint(e.toString());
      customToast(context: context, text: "$e");
    }
  }
}
