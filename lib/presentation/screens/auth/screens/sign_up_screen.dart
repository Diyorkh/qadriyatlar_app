import 'package:flutter/material.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_text_field.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';
import 'package:qadriyatlar_app/theme/const_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/signUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userNameController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userPasswordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _userPhoneController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50.0),
                Center(
                  child: const Text(
                    'Yangi akkaunt yarating',
                    style: headline1,
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: const Text(
                    'Iltimos, davom etish uchun shaklni to\'ldiring',
                    style: headline3,
                  ),
                ),
                const SizedBox(height: 60.0),
                CustomTextField(
                  controller: _userNameController,
                  hintText: "To'liq Ism",
                  suffixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  controller: _userPhoneController,
                  hintText: 'Telefon Raqami',
                  suffixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  controller: _userPasswordController,
                  hintText: 'Parol',
                  suffixWidget: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: ColorApp.grayText,
                    ),
                  ),
                ),
                const SizedBox(height: 80.0),
                CustomAppButton(
                  onPressed: () {},
                  label: "Ro'yxatdan o'tish",
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Akkauntingiz bormi? ',
                        style: headline.copyWith(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                      TextSpan(
                        text: ' Kirish',
                        style: headlineDot.copyWith(
                          fontSize: 14.0,
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
