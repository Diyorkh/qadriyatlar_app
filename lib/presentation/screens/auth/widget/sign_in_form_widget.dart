import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/auth/screens/restore_password_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/auth/screens/sign_up_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/main_screens.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_text_field.dart';
import 'package:qadriyatlar_app/presentation/widgets/flutter_toast.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';
import 'package:qadriyatlar_app/theme/const_styles.dart';

class SignInPhoneFormWidget extends StatefulWidget {
  const SignInPhoneFormWidget({super.key});

  @override
  State<SignInPhoneFormWidget> createState() => _SignInPhoneFormWidgetState();
}

class _SignInPhoneFormWidgetState extends State<SignInPhoneFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool passwordVisible = true;
  bool enableInputs = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ErrorLoginAccountState) {
          showFlutterToast(title: state.message);
        }

        if (state is SuccessLoginAccountState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(
              context,
              MainScreen.routeName,
              arguments: MainScreenArgs(selectedIndex: 4),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _phoneController,
                  suffixIcon: Icons.phone,
                  hintText: 'Raqam', // TODO: Add translations
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return 'Fill the form'; // TODO: 27.09.2023 Add Translations
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  obscure: passwordVisible,
                  controller: _passwordController,
                  suffixWidget: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: ColorApp.grayText,
                    ),
                  ),
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return 'Fill the form'; // TODO: Add translations
                    }
                    if (val.length <= 4) {
                      return 'Password not correctly'; // TODO: Add translations
                    }
                    return null;
                  },
                  hintText: 'Parol', // TODO: Add translations
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, RestorePasswordScreen.routeName),
                    child: Text(
                      // TODO: Add translations
                      'Parolni unutdingizmi?',
                      style: headline3,
                    ),
                  ),
                ),
                const SizedBox(height: 100.0),
                CustomAppButton(
                  // TODO: Add translations
                  label: "Ro'yxatdan o'tish",
                  loaderIndicator: state is LoadingLoginAccountState,
                  onPressed: state is LoadingLoginAccountState
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginAccountEvent(
                                password: _passwordController.text,
                                phone: _phoneController.text,
                                register: false,
                              ),
                            );
                          }
                        },
                ),
                const SizedBox(height: 40.0),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(SignUpScreen.routeName),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          // TODO: Add translations
                          text: "Akkauntingiz yo'qmi? ",
                          style: headline.copyWith(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                        ),
                        TextSpan(
                          // TODO: Add translations
                          text: " Ro'yxatdan o'ting",
                          style: headlineDot.copyWith(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
