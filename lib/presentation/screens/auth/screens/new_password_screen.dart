import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/phone_restore_password/phone_restore_password_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/main_screens.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_text_field.dart';
import 'package:qadriyatlar_app/presentation/widgets/flutter_toast.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.phone});

  static const String routeName = '/newPasswordScreen';

  final String phone;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Change password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: BlocListener<PhoneRestorePasswordBloc, PhoneRestorePasswordState>(
              listener: (context, state) {
                if (state is SuccessChangePasswordState) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainScreen.routeName,
                    (Route route) => false,
                    arguments: MainScreenArgs(selectedIndex: 4),
                  );
                }

                if (state is ErrorChangePasswordState) {
                  showFlutterToast(title: state.message ?? 'Unknown error');
                }
              },
              child: BlocBuilder<PhoneRestorePasswordBloc, PhoneRestorePasswordState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      CustomTextField(
                        controller: _newPasswordController,
                        obscure: true,
                        // TODO: Add translations
                        hintText: 'Password',
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Fill the form'; // TODO: Add translations
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _newPasswordConfirmController,
                        obscure: true,
                        // TODO: Add translations
                        hintText: 'Password confirm',
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Fill the form'; // TODO: Add translations
                          }

                          if (val != _newPasswordController.text) {
                            return 'Check the password is correctly';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomAppButton(
                        onPressed: state is LoadingChangePasswordState
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<PhoneRestorePasswordBloc>(context).add(
                                    ChangePasswordByPhoneEvent(
                                      phone: widget.phone,
                                      password: _newPasswordController.text,
                                      passwordRe: _newPasswordConfirmController.text,
                                    ),
                                  );
                                }
                              },
                        loaderIndicator: state is LoadingChangePasswordState,
                        label: 'Confirm',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
