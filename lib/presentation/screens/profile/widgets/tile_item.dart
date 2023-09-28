import 'package:flutter/material.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onClick,
    this.textColor,
    this.iconColor,
    this.leadingBackColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onClick;
  final Color? textColor;
  final Color? iconColor;
  final Color? leadingBackColor;

  @override
  Widget build(BuildContext context) {
    final Widget svg = Icon(
      icon,
      color: (iconColor == null) ? Colors.black : iconColor,
    );
    return ListTile(
      onTap: onClick,
      contentPadding: const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
      leading: CircleAvatar(
        backgroundColor: leadingBackColor,
        radius: 25,
        child: svg,
      ),
      title: Text(
        title,
        textScaleFactor: 1.0,
        style: TextStyle(
          color: textColor == null ? ColorApp.dark : textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: IconButton(
        onPressed: onClick,
        icon: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: ColorApp.grayText,
        ),
      ),
    );
  }
}
