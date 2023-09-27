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
  });

  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final FormFieldValidator<String>? validator;
  final IconData? suffixIcon;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
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
