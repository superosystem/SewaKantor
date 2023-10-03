import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';

Widget readOnlyWidget({
  context,
  TextEditingController? controller,
  double? errBorderRadius,
  double? fcsBorderRadius,
  double? enblBorderRadius,
  Widget? suffixIcon,
  String? hint,
  Function()? onTap,
  Widget? label,
  TextStyle? textStyle,
  FormFieldValidator<String?>? validator,
  TextInputAction? textInputAction,
}) {
  return TextFormField(
    //cursorColor: MyColor.deepAqua,
    controller: controller,
    readOnly: true,
    onTap: onTap,
    validator: validator,
    decoration: InputDecoration(
      label: label,
      hintText: hint,
      hintStyle: textStyle,
      filled: true,
      //fillColor: MyColor.border,
      suffixIcon: suffixIcon,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: MyColor.redColor,
        ),
        borderRadius: BorderRadius.circular(errBorderRadius!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: MyColor.redColor,
        ),
        borderRadius: BorderRadius.circular(errBorderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: MyColor.grayLightColor,
        ),
        borderRadius: BorderRadius.circular(fcsBorderRadius!),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: MyColor.grayLightColor,
        ),
        borderRadius: BorderRadius.circular(enblBorderRadius!),
      ),
    ),
  );
}
