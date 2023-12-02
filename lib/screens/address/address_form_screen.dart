import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:firebase_testing/controller/userController/address_controller.dart';
import 'package:firebase_testing/models/hive_address_model.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customButton.dart';
import 'package:firebase_testing/utils/customTextField.dart';
import 'package:firebase_testing/utils/customToast.dart';

class AddressFormScreen extends StatefulWidget {
  AddressFormScreen({super.key, this.id = ""});
  String id;

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final addressKey = GlobalKey<FormState>();

  TextEditingController flatController = TextEditingController();
  final FocusNode flatFocus = FocusNode();
  List<String?> flatHolder = List.filled(1, '');

  TextEditingController buildingController = TextEditingController();
  final FocusNode buildingFocus = FocusNode();
  List<String?> buildingHolder = List.filled(1, '');

  TextEditingController colonyController = TextEditingController();
  final FocusNode colonyFocus = FocusNode();
  List<String?> colonyHolder = List.filled(1, '');

  TextEditingController landMarkController = TextEditingController();
  final FocusNode landMarkFocus = FocusNode();
  List<String?> landMarkHolder = List.filled(1, '');

  TextEditingController areaController = TextEditingController();
  final FocusNode areaFocus = FocusNode();
  List<String?> areaHolder = List.filled(1, '');

  TextEditingController optionController = TextEditingController();
  final FocusNode optionFocus = FocusNode();
  List<String?> optionHolder = List.filled(1, '');

  TextEditingController pincodeController = TextEditingController();
  final FocusNode pincodeFocus = FocusNode();
  List<String?> pincodeHolder = List.filled(1, '');

  final _addressController = Get.put(AddressController());

  @override
  initState() {
    super.initState();
    check();
  }

  check() {
    if (widget.id != null || widget.id.isNotEmpty) {
      _addressController.getAddress();
      for (var v in _addressController.addressList) {
        if (v.id == widget.id) {
          debugPrint("\nedit id ${v.id}");
          flatController.text = v.flatNumber;
          optionController.text = v.optional;
          buildingController.text = v.buildingName;
          colonyController.text = v.colonyRoadName;
          landMarkController.text = v.landmark;
          areaController.text = v.area;
          pincodeController.text = v.pincode;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(leading: true, text: "Add Address"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: addressKey,
          child: Column(
            children: [
              fields(),
              customButton(
                  text: "Save",
                  onTap: () {
                    validate();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget fields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: textFieldWidget(
            context: context,
            hint: "Flat number",
            controller: flatController,
            holder: flatHolder,
            currentFocus: flatFocus,
            nextFocus: optionFocus,
            maxlength: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: textFieldWidget(
            context: context,
            hint: 'Optional',
            controller: optionController,
            holder: optionHolder,
            currentFocus: optionFocus,
            nextFocus: buildingFocus,
            maxlength: 30,
            validation: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: textFieldWidget(
            context: context,
            hint: 'Building Name',
            controller: buildingController,
            holder: buildingHolder,
            currentFocus: buildingFocus,
            nextFocus: colonyFocus,
            maxlength: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: textFieldWidget(
            context: context,
            hint: "Colony/Road Name",
            controller: colonyController,
            holder: colonyHolder,
            currentFocus: colonyFocus,
            nextFocus: landMarkFocus,
            maxlength: 40,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: textFieldWidget(
            context: context,
            hint: "LandMark",
            controller: landMarkController,
            holder: landMarkHolder,
            currentFocus: landMarkFocus,
            nextFocus: areaFocus,
            maxlength: 50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: textFieldWidget(
            context: context,
            hint: "Area",
            controller: areaController,
            holder: areaHolder,
            currentFocus: areaFocus,
            nextFocus: pincodeFocus,
            maxlength: 50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 40),
          child: NumbertextFieldWidget(
              context: context,
              hint: "Pin code",
              controller: pincodeController,
              holder: pincodeHolder,
              currentFocus: pincodeFocus,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6)
              ]),
        ),
      ],
    );
  }

  validate() async {
    if (addressKey.currentState!.validate()) {
      if (optionController.text == null) {
        optionController.text = " ";
      }
      String add =
          "${flatController.text}, ${optionController.text} ${buildingController.text}, ${colonyController.text}, ${landMarkController.text}, ${areaController.text},${pincodeController.text}";
      debugPrint("\naddress: $add");
      if (widget.id == null || widget.id.isEmpty) {
        var id = DateFormat("d/M/y hh:mm:ss a").format(DateTime.now());
        debugPrint("\nid $id");
        HiveAddressModel address = HiveAddressModel(
            id: id,
            flatNumber: flatController.text,
            optional: optionController.text,
            buildingName: buildingController.text,
            colonyRoadName: colonyController.text,
            landmark: landMarkController.text,
            area: areaController.text,
            pincode: pincodeController.text);
        _addressController.saveAddress(address: address);
        setState(() {});
        customToast(context: context, text: "Address Added");
        debugPrint("\nupdated ${_addressController.addressList}");
        Get.back();
      } else {
        HiveAddressModel address = HiveAddressModel(
            id: widget.id,
            flatNumber: flatController.text,
            optional: optionController.text,
            buildingName: buildingController.text,
            colonyRoadName: colonyController.text,
            landmark: landMarkController.text,
            area: areaController.text,
            pincode: pincodeController.text);
        _addressController.saveAddress(address: address);
        setState(() {});
        customToast(context: context, text: "Address Updated");
        debugPrint("\nupdated ${_addressController.addressList}");
        Get.back();
      }
    }
  }
}
