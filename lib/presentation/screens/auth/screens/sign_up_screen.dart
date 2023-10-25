import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/main.dart';
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
                            child: Text(
                              localizations.getLocalization('create_account'),
                              style: headline1,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: Text(
                              localizations.getLocalization('complete_the_form'),
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
                            hintText: localizations.getLocalization('full_name'),
                            suffixIcon: Icons.person_outline_rounded,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return localizations.getLocalization('fill_the_form');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          CustomTextField(
                            keyboardType: TextInputType.phone,
                            controller: _userPhoneController,
                            hintText: localizations.getLocalization('phone_number'),
                            suffixIcon: Icons.phone,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return localizations.getLocalization('fill_the_phone_number');
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          CustomTextField(
                            controller: _userPasswordController,
                            obscure: _passwordVisible,
                            hintText: localizations.getLocalization('password_label_text'),
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
                                return localizations.getLocalization('password_empty_error_text');
                              }

                              if (val.length <= 4) {
                                return localizations.getLocalization('password_sign_in_helper_text');
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
                            label: localizations.getLocalization('auth_sign_up_tab'),
                          ),
                          const SizedBox(height: 20.0),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${localizations.getLocalization('do_you_have_account')} ',
                                    style: headline.copyWith(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${localizations.getLocalization('login_label_text')}',
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
