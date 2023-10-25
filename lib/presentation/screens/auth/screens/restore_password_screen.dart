import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/phone_restore_password/phone_restore_password_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/auth/screens/new_password_screen.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_text_field.dart';
import 'package:qadriyatlar_app/presentation/widgets/loader_widget.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';
import 'package:qadriyatlar_app/theme/const_styles.dart';

class RestorePasswordScreen extends StatelessWidget {
  const RestorePasswordScreen() : super();

  static const String routeName = '/restorePasswordScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: ColorApp.grayText,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _RestorePasswordWidget(),
        ),
      ),
    );
  }
}

class _RestorePasswordWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RestorePasswordWidgetState();
}

class _RestorePasswordWidgetState extends State<_RestorePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _digitsController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PhoneRestorePasswordBloc, PhoneRestorePasswordState>(
          listener: (context, state) {
            if (state is SuccessPhoneRestorePasswordState) {
              _showVerifyDialogPhone(context);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SuccessVerifyPhoneState) {
              Navigator.of(context).pop();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPasswordScreen(phone: _phoneController.text),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<PhoneRestorePasswordBloc, PhoneRestorePasswordState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    localizations.getLocalization('welcome'),
                    style: headline1,
                  ),
                  const SizedBox(height: 80),
                  CustomTextField(
                    keyboardType: TextInputType.phone,
                    errorText: state is ErrorPhoneRestorePasswordState ? state.message : null,
                    controller: _phoneController,
                    hintText: localizations.getLocalization('phone_number'),
                    suffixIcon: Icons.phone,
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return localizations.getLocalization('fill_the_phone_number');
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 180.0),
                  CustomAppButton(
                    onPressed: state is LoadingPhoneRestorePasswordState
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<PhoneRestorePasswordBloc>(context).add(
                                RequestPasswordRestoreEvent(phone: _phoneController.text),
                              );
                            }
                          },
                    loaderIndicator: state is LoadingPhoneRestorePasswordState,
                    label: localizations.getLocalization('login_label_text'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showVerifyDialogPhone(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          content: SizedBox(
            child: Column(
              children: [
                BlocBuilder<PhoneRestorePasswordBloc, PhoneRestorePasswordState>(
                  builder: (context, state) {
                    return Text(state is SuccessPhoneRestorePasswordState ? state.message! : '');
                  },
                ),
                const SizedBox(height: 20.0),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Pinput(
                          controller: _digitsController,
                          length: 5,
                          forceErrorState: state is InvalidVerifyCodeState ? true : false,
                          errorText: state is InvalidVerifyCodeState ? '${state.message}' : null,
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return localizations.getLocalization('code_error');
                            }

                            if (val.length != 5) {
                              return localizations.getLocalization('code_error');
                            }

                            return null;
                          },
                          defaultPinTheme: PinTheme(
                            height: 44,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFE7E7E8),
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            height: 44,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: ColorApp.mainColor,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          errorPinTheme: PinTheme(
                            height: 44,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.red,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          onCompleted: (pin) {
                            BlocProvider.of<AuthBloc>(context).add(
                              VerifyPhoneEvent(phone: _phoneController.text, code: pin),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state is LoadingVerifyPhoneState)
                          LoaderWidget(
                            loaderColor: ColorApp.mainColor,
                          )
                        else
                          const SizedBox(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      _digitsController.clear();
      BlocProvider.of<AuthBloc>(context).add(ResetStatesEvent());
    });
  }
}
