import 'package:flutter/material.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.suffixIcon,
    this.hintText,
    this.helperText,
    this.validator,
    this.suffixWidget,
    this.errorText,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final IconData? suffixIcon;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        errorText: errorText,
        errorMaxLines: 3,
        hintText: hintText,
        helperText: helperText,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            width: 2,
            color: ColorApp.redColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: ColorApp.redColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            width: 2,
            color: ColorApp.mainColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: ColorApp.mainColor,
          ),
        ),
        suffixIcon: suffixWidget ??
            Icon(
              suffixIcon,
              color: ColorApp.grayText,
            ),
        hintStyle: TextStyle(
          color: ColorApp.grayText,
        ),
      ),
      validator: validator,
    );
  }
}
