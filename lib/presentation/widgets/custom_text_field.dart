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
    this.label,
    this.borderColor,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? label;
  final FormFieldValidator<String>? validator;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final Color? borderColor;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        label: label != null ? Text(label!) : null,
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
            color: borderColor ?? ColorApp.mainColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: borderColor ?? ColorApp.mainColor,
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
