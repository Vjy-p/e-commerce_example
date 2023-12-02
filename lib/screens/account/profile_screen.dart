// ignore_for_file: unused_field
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_testing/controller/userController/user_controller.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customTextField.dart';
import 'package:firebase_testing/utils/customToast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final addProfileKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  TextEditingController nameController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  List<String?> name = List.filled(1, '');

  TextEditingController numberController = TextEditingController();
  final FocusNode numberFocus = FocusNode();
  List<String?> number = List.filled(1, '');

  var user = FirebaseAuth.instance.currentUser;

  @override
  initState() {
    FirebaseAuth.instance.currentUser!.reload();
    super.initState();
    loadData();
  }

  loadData() {
    if (userController.userName.isNotEmpty) {
      nameController.text = userController.userName.value;
      numberController.text = userController.number.value;
    }
  }

  final userController = Get.put(UserController());

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(leading: true, text: "Profile"),
      backgroundColor: white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10),
        controller: scrollController,
        child: Form(
          key: addProfileKey,
          child: Column(
            children: [
              userNameWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: textFieldWidget(
            hint: "name",
            controller: nameController,
            holder: name,
            currentFocus: nameFocus,
            borderColor: primary,
            context: context,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 50),
          child: textFieldWidget(
            enabled: false,
            hint: "mobile Number",
            controller: numberController,
            holder: number,
            borderColor: primary,
            context: context,
          ),
        ),
        customButton(
            text: "update",
            onTap: () {
              validate();
            }),
      ],
    );
  }

  validate() async {
    if (addProfileKey.currentState!.validate()) {
      if (name[0] != null &&
          nameController.text.isNotEmpty &&
          nameController.text.toString() !=
              userController.userName.toString()) {
        userController.saveName(nameController.text);
        setState(() {});
        debugPrint("\nupdated ${user!.displayName.toString()}");
        customToast(context: context, text: "${nameController.text} Updated");
      }
      setState(() {});
      Get.back();
    }
  }

  Widget mobileNumberWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: NumbertextFieldWidget(
          enabled: false,
          hint: 'Mobile Number',
          controller: numberController,
          holder: number,
          currentFocus: numberFocus,
          borderColor: primary),
    );
  }
}
