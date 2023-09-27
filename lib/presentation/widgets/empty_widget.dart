import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    this.iconData,
    required this.title,
    this.buttonText,
    this.onTap,
    this.image,
  }) : super(key: key);

  final String? iconData;
  final String? image;
  final String title;
  final String? buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget? buildButton;

    if (buttonText != null && buttonText!.isNotEmpty) {
      buildButton = Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: CustomAppButton(
            onPressed: onTap,
            label: buttonText!,
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          image != null
              ? Image.asset(
                  image!,
                  width: 300,
                  height: 300,
                )
              : iconData != null
                  ? SvgPicture.asset(
                      iconData!,
                      width: 150,
                      height: 150,
                    )
                  : const SizedBox(),
          const SizedBox(height: 10.0),
          Text(
            title,
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          buildButton ?? const SizedBox(),
        ],
      ),
    );
  }
}
