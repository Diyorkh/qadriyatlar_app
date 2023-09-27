import 'package:flutter/material.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';

class UnauthorizedWidget extends StatelessWidget {
  const UnauthorizedWidget({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              localizations.getLocalization('not_authenticated'),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          CustomAppButton(
            onPressed: onTap,
            label: localizations.getLocalization('login_label_text'),
          ),
        ],
      ),
    );
  }
}
