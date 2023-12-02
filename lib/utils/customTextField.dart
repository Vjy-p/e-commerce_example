// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/custom_text.dart';

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

Widget textFieldWidget({
  required BuildContext context,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool showCursor = true,
  bool readOnly = false,
  bool onlyHint = false,
  required String hint,
  List<String?>? holder,
  TextEditingController? controller,
  FocusNode? currentFocus,
  FocusNode? nextFocus,
  Color? borderColor,
  bool isEmail = false,
  bool enabled = true,
  bool validation = true,
  TextAlign? textAlign,
  double borderRadius = 10,
  double? fontsize,
  Color? textColor,
  int maxLines = 1,
  void Function(String)? onChanged,
  int minLines = 1,
  int? maxlength,
  TextInputAction? textInputAction,
  TextCapitalization textCapitalization = TextCapitalization.words,
  // Function? onTap,
}) {
  return Container(
    alignment: Alignment.center,
    // height: SizeConfig.blockSizeVertical ! * 6,
    child: TextFormField(
      // onTap: onTap!(),
      maxLength: maxlength,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      minLines: minLines,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: readOnly,
      showCursor: showCursor,
      controller: controller,
      enabled: enabled,
      textInputAction: textInputAction != null
          ? textInputAction
          : nextFocus == null
              ? TextInputAction.done
              : TextInputAction.next,
      style: customTextStyle(color: textColor ?? tColor),

      textAlignVertical: TextAlignVertical.center,
      validator: (String? value) {
        if (validation == true) {
          if (value!.isEmpty) {
            return 'Enter $hint';
            // } else if (isEmail && !Constants().regex.hasMatch(value)) {
            //   return 'Enter valid $hint';
            // } else {
            //   return null;
          }
        } else {
          return null;
        }
      },
      onSaved: (value) {
        holder![0] = value;
      },
      focusNode: currentFocus,
      onFieldSubmitted: (v) {
        _fieldFocusChange(context, currentFocus!, nextFocus);
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: "",
        fillColor: white,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        hintText: onlyHint ? hint : 'Enter $hint',
        hintStyle: customTextStyle(
          color: textColor ?? tColor.withOpacity(0.5),
        ),
        prefixIcon: prefixIcon,
        suffix: suffixIcon,
        border: borderStyle(borderRadius, borderColor),
        disabledBorder: borderStyle(borderRadius, borderColor),
        enabledBorder: borderStyle(borderRadius, borderColor),
        errorBorder: borderStyle(borderRadius, borderColor),
        focusedBorder: borderStyle(borderRadius, borderColor),
        focusedErrorBorder: borderStyle(borderRadius, borderColor),
      ),
    ),
  );
}

borderStyle(borderRadius, borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    borderSide: BorderSide(
      color: borderColor ?? Colors.grey[400],
    ),
  );
}

Widget NumbertextFieldWidget(
    {BuildContext? context,
    Widget? prefixIcon,
    required String hint,
    List<String?>? holder,
    TextEditingController? controller,
    FocusNode? currentFocus,
    FocusNode? nextFocus,
    void Function(String)? onChanged,
    bool isPhoneNumber = false,
    int validationLength = 10,
    double borderRadius = 10,
    bool enabled = true,
    List<TextInputFormatter>? inputFormatters,
    Color? borderColor,
    TextAlign? textAlign,
    bool validation = true,
    Color? textColor}) {
  return Container(
    alignment: Alignment.center,
    // color: Colors.red,
    // height: SizeConfig.blockSizeVertical ! * 6,
    child: TextFormField(
      enabled: enabled,
      textAlign: textAlign ?? TextAlign.start,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
      maxLength: 10,
      textInputAction:
          nextFocus == null ? TextInputAction.done : TextInputAction.next,
      style: customTextStyle(color: textColor ?? tColor),
      textAlignVertical: TextAlignVertical.center,
      validator: (String? value) {
        if (validation == true) {
          if (value!.isEmpty) {
            return 'Enter $hint';
          } else if (isPhoneNumber == true &&
              value.length != validationLength) {
            return 'Invalid Number';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      onChanged: onChanged,
      onSaved: (value) {
        holder![0] = value;
      },
      focusNode: currentFocus,
      onFieldSubmitted: (v) {
        _fieldFocusChange(context!, currentFocus!, nextFocus);
      },
      decoration: InputDecoration(
        fillColor: white,
        filled: true,
        isDense: true,
        counterText: "",
        hintText: 'Enter ' + hint,
        hintStyle: customTextStyle(color: textColor ?? tColor.withOpacity(0.5)),
        prefixIcon: prefixIcon ?? null,
        border: borderStyle(borderRadius, borderColor),
        disabledBorder: borderStyle(borderRadius, borderColor),
        enabledBorder: borderStyle(borderRadius, borderColor),
        errorBorder: borderStyle(borderRadius, borderColor),
        focusedBorder: borderStyle(borderRadius, borderColor),
        focusedErrorBorder: borderStyle(borderRadius, borderColor),
      ),
    ),
  );
}

Widget PasswordtextFieldWidget(
    {BuildContext? context,
    Widget? prefixIcon,
    required String hint,
    List<String?>? holder,
    TextEditingController? controller,
    FocusNode? currentFocus,
    FocusNode? nextFocus,
    Color? borderColor,
    bool enabled = true,
    bool validation = true,
    Color? textColor}) {
  return Container(
    alignment: Alignment.center,

    // height: SizeConfig.blockSizeVertical ! * 6,
    child: TextFormField(
      enabled: enabled,
      controller: controller,
      textInputAction:
          nextFocus == null ? TextInputAction.done : TextInputAction.next,
      style: customTextStyle(color: textColor ?? tColor),
      textAlignVertical: TextAlignVertical.center,
      obscureText: true,
      validator: (String? value) {
        if (validation == true) {
          if (value!.isEmpty) {
            return 'Enter $hint';
          } else if (value.length < 8 || value.length > 16) {
            return '$hint length must be in between 8 to 16 characters';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      onSaved: (value) {
        holder![0] = value;
      },
      focusNode: currentFocus,
      onFieldSubmitted: (v) {
        _fieldFocusChange(context!, currentFocus!, nextFocus);
      },
      decoration: InputDecoration(
        fillColor: white,
        filled: true,
        isDense: true,
        hintText: 'Enter ' + hint,
        hintStyle: customTextStyle(color: textColor ?? tColor.withOpacity(0.5)),
        prefixIcon: prefixIcon ?? null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: borderColor ?? tColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    ),
  );
}

Widget conformPasswordtextFieldWidget(
    {BuildContext? context,
    Widget? prefixIcon,
    required String hint,
    List<String?>? holder,
    TextEditingController? controller,
    required TextEditingController? passwordcontroller,
    FocusNode? currentFocus,
    FocusNode? nextFocus,
    Color? borderColor,
    bool validation = true,
    bool enabled = true,
    Color? textColor}) {
  return Container(
    alignment: Alignment.center,

    // height: SizeConfig.blockSizeVertical ! * 6,
    child: TextFormField(
      enabled: enabled,
      controller: controller,
      textInputAction:
          nextFocus == null ? TextInputAction.done : TextInputAction.next,
      style: customTextStyle(color: textColor ?? tColor),
      textAlignVertical: TextAlignVertical.center,
      obscureText: true,
      validator: (String? value) {
        if (validation == true) {
          if (value!.isEmpty) {
            return 'Enter $hint';
          } else if (value.length < 8 || value.length > 16) {
            return '$hint length must be in between 8 to 16 characters';
          } else if (value != (passwordcontroller!.text)) {
            return 'Password miss match';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      onSaved: (value) {
        holder![0] = value;
      },
      focusNode: currentFocus,
      onFieldSubmitted: (v) {
        _fieldFocusChange(context!, currentFocus!, nextFocus);
      },
      decoration: InputDecoration(
        isDense: true,
        fillColor: white,
        filled: true,
        hintText: 'Confirm ' + hint,
        hintStyle: customTextStyle(color: textColor ?? tColor.withOpacity(0.5)),
        prefixIcon: prefixIcon ?? null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: borderColor ?? tColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    ),
  );
}
