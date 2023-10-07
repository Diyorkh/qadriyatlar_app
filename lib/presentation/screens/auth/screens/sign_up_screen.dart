import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/main_screens.dart';
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
  final _regKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userPasswordController = TextEditingController();

  bool _passwordVisible = true;

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
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SuccessRegisterAccountState) {
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
                key: _regKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 50.0),
                          Center(
                            child: const Text(
                              // TODO: Add translations
                              'Yangi akkaunt yarating',
                              style: headline1,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: const Text(
                              // TODO: Add translations
                              "Iltimos, davom etish uchun shaklni to'ldiring",
                              style: headline3,
                            ),
                          ),
                          const SizedBox(height: 60.0),
                          if (state is ErrorRegisterAccountState)
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const SizedBox(height: 20.0),
                          CustomTextField(
                            controller: _userNameController,
                            // TODO: Add translations
                            hintText: "To'liq Ism",
                            suffixIcon: Icons.person_outline_rounded,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Fill the form'; // TODO: Add translations
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          CustomTextField(
                            controller: _userPhoneController,
                            hintText: 'Telefon Raqami', // TODO: Add translations
                            suffixIcon: Icons.phone,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Fill the form'; // TODO: Add translations
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          CustomTextField(
                            controller: _userPasswordController,
                            obscure: _passwordVisible,
                            // TODO: Add translations
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
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Fill the form'; // TODO: Add translations
                              }

                              if (val.length <= 4) {
                                return 'Password not correctly'; // TODO: Add translations
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 80.0),
                          CustomAppButton(
                            loaderIndicator: state is LoadingRegisterAccountState,
                            onPressed: state is LoadingRegisterAccountState
                                ? null
                                : () {
                                    if (_regKey.currentState!.validate()) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        RegisterAccountEvent(
                                          userName: _userNameController.text,
                                          userPassword: _userPasswordController.text,
                                          userPhone: _userPhoneController.text,
                                        ),
                                      );
                                    }
                                  },
                            // TODO: Add translations
                            label: "Ro'yxatdan o'tish",
                          ),
                          const SizedBox(height: 20.0),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  // TODO: Add translations
                                  TextSpan(
                                    text: 'Akkauntingiz bormi? ',
                                    style: headline.copyWith(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  // TODO: Add translations
                                  TextSpan(
                                    text: ' Kirish',
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
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
