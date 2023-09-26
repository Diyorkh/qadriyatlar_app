import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/main_screens.dart';
import 'package:qadriyatlar_app/presentation/widgets/flutter_toast.dart';
import 'package:qadriyatlar_app/presentation/widgets/loader_widget.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';
import 'package:qadriyatlar_app/theme/const_dimensions.dart';

class AuthPhoneWidget extends StatefulWidget {
  const AuthPhoneWidget({super.key});

  @override
  State<AuthPhoneWidget> createState() => _AuthPhoneWidgetState();
}

class _AuthPhoneWidgetState extends State<AuthPhoneWidget> {
  final _formKey = GlobalKey<FormState>();
  final _regKey = GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyCodeController = TextEditingController();
  TextEditingController _regPasswordController = TextEditingController();
  TextEditingController _regConfirmPasswordController = TextEditingController();

  FocusNode myFocusNode = FocusNode();

  bool passwordVisible = true;
  bool enableInputs = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Показываем эти состояния когда пользователь есть в системе
        if (state is AuthPasswordState) {
          showDialog<void>(
            context: context,
            builder: (BuildContext _) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                      child: TextFormField(
                        controller: _passwordController,
                        enabled: enableInputs,
                        obscureText: true,
                        cursorColor: ColorApp.mainColor,
                        decoration: InputDecoration(
                          labelText: localizations.getLocalization('password_label_text'),
                          helperText: localizations.getLocalization('password_sign_in_helper_text'),
                          filled: true,
                          labelStyle: TextStyle(
                            color: myFocusNode.hasFocus ? Colors.red : Colors.black,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorApp.mainColor),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return localizations.getLocalization('login_empty_error_text');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: kButtonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.mainColor,
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                LoginAccountEvent(
                                  phone: _phoneController.text,
                                  password: _passwordController.text,
                                  register: false,
                                ),
                              );
                        },
                        // TODO: Добавить перевод
                        child: Text('Sign in'),
                      ),
                    )
                  ],
                ),
              );
            },
          ).whenComplete(
            () => _passwordController.clear(),
          );
        }

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

        // Показываем эти состояния когда пользователя нет в системе
        if (state is AuthVerifyPhoneState) {
          showDialog<void>(
            context: context,
            builder: (BuildContext _) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                      child: TextFormField(
                        controller: _verifyCodeController,
                        enabled: enableInputs,
                        cursorColor: ColorApp.mainColor,
                        maxLength: 5,
                        decoration: InputDecoration(
                          // TODO: Добавить перевод
                          labelText: 'Verify code',
                          // TODO: Добавить перевод
                          helperText: 'Enter 5 digits code',
                          filled: true,
                          labelStyle: TextStyle(
                            color: myFocusNode.hasFocus ? Colors.red : Colors.black,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorApp.mainColor),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 5) {
                            BlocProvider.of<AuthBloc>(context).add(
                              VerifyPhoneEvent(
                                phone: _phoneController.text,
                                code: _verifyCodeController.text,
                              ),
                            );
                          }
                        },
                        validator: (value) {
                          // TODO: Добавить перевод
                          if (value!.isEmpty) {
                            return 'Enter code';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ).whenComplete(
            () => _verifyCodeController.clear(),
          );
        }

        if (state is InvalidVerifyCodeState) {
          // TODO: Добавить перевод
          showFlutterToast(title: state.message ?? 'Invalid code');
        }

        if (state is ErrorVerifyPhoneState) {
          // TODO: Добавить перевод
          showFlutterToast(title: state.message ?? 'Unknown Error');
        }

        if (state is SuccessVerifyPhoneState) {
          Navigator.of(context, rootNavigator: false).pop();
          showDialog<void>(
            context: context,
            builder: (BuildContext _) {
              return AlertDialog(
                content: Form(
                  key: _regKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: TextFormField(
                          controller: _regPasswordController,
                          enabled: enableInputs,
                          obscureText: true,
                          cursorColor: ColorApp.mainColor,
                          decoration: InputDecoration(
                            // TODO: Добавить перевод
                            labelText: 'Password',
                            // TODO: Добавить перевод
                            helperText: 'Minimum 4 symbols ..',
                            filled: true,
                            labelStyle: TextStyle(
                              color: myFocusNode.hasFocus ? Colors.red : Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorApp.mainColor),
                            ),
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter code';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          controller: _regConfirmPasswordController,
                          enabled: enableInputs,
                          obscureText: true,
                          cursorColor: ColorApp.mainColor,
                          decoration: InputDecoration(
                            // TODO: Добавить перевод
                            labelText: 'Password',
                            // TODO: Добавить перевод
                            helperText: 'Minimum 4 symbols ..',
                            filled: true,
                            labelStyle: TextStyle(
                              color: myFocusNode.hasFocus ? Colors.red : Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorApp.mainColor),
                            ),
                          ),
                          validator: (value) {
                            // TODO: Добавить перевод
                            if (value!.isEmpty) {
                              return 'Enter code';
                            }

                            // TODO: Добавить перевод
                            if(_regConfirmPasswordController.text != _regPasswordController.text) {
                              return 'Please check password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: kButtonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorApp.mainColor,
                          ),
                          onPressed: () {
                            if (_regKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    LoginAccountEvent(
                                      phone: _phoneController.text,
                                      password: _regPasswordController.text,
                                      rePassword: _regConfirmPasswordController.text,
                                      register: true,
                                    ),
                                  );
                            }
                          },
                          // TODO: Добавить перевод
                          child: Text('Login'),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: _phoneController,
                    enabled: enableInputs,
                    cursorColor: ColorApp.mainColor,
                    decoration: InputDecoration(
                      // TODO: Добавить перевод
                      labelText: 'Phone',
                      // TODO: Добавить перевод
                      helperText: 'Enter your phone',
                      filled: true,
                      labelStyle: TextStyle(
                        color: myFocusNode.hasFocus ? Colors.red : Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorApp.mainColor),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        // TODO: Добавить перевод
                        return 'Enter phone';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: kButtonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.mainColor,
                    ),
                    onPressed: state is LoadingAuthPhoneState
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(AuthPhoneEvent(_phoneController.text));
                            }
                          },
                    // TODO: Добавить перевод
                    child: state is LoadingAuthPhoneState ? LoaderWidget() : Text('GET CODE'),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
