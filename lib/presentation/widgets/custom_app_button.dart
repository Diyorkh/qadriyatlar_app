import 'package:flutter/material.dart';
import 'package:qadriyatlar_app/presentation/widgets/loader_widget.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loaderIndicator = false,
    this.bgColor,
    this.colorText,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loaderIndicator;
  final Color? bgColor;
  final Color? colorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? ColorApp.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: loaderIndicator
            ? LoaderWidget()
            : Text(
                label,
                style: TextStyle(
                  color: colorText ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
