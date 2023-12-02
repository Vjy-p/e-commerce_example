import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_testing/screens/auth/mobile_login.dart';
import 'package:firebase_testing/screens/homepage/homepage.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customTextField.dart';
import 'package:firebase_testing/utils/customToast.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  List<String?> email = List.filled(1, '');

  TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  List<String?> password = List.filled(1, '');

  bool isLoading = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
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
              customText(text: "Login"),
              const SizedBox(
                height: 50,
              ),
              textFieldWidget(
                hint: "Email",
                controller: emailController,
                holder: email,
                currentFocus: emailFocus,
                nextFocus: passwordFocus,
                context: context,
              ),
              const SizedBox(
                height: 16,
              ),
              PasswordtextFieldWidget(
                hint: "Password",
                controller: passwordController,
                holder: password,
                currentFocus: passwordFocus,
                nextFocus: null,
              ),
              const SizedBox(
                height: 20,
              ),
              customButton(
                  text: "Login",
                  onTap: () {
                    validate();
                  }),
              const SizedBox(
                height: 20,
              ),
              richTextButton(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MobileLogin()));
                },
                text1: "Don't Have an Account?  ",
                color1: tColor.withOpacity(0.4),
                text2: "SignUp",
              )
            ],
          ),
        ),
      )),
    );
  }

  validate() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          debugPrint("\nresponse: $value");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Homepage()));
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          debugPrint('No user found for that email.');
          customToast(context: context, text: "No user found for that email.");
        } else if (e.code == 'wrong-password') {
          debugPrint('Wrong password provided for that user.');
          customToast(
              context: context, text: "Wrong password provided for that user.");
        } else {
          debugPrint('\nerror ${e.code}');
          customToast(context: context, text: "${e.code} ${e.credential}");
        }
      }
    }
  }
}
