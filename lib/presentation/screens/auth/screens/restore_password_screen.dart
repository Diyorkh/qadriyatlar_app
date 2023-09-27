import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/restore_password/restore_password_bloc.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_text_field.dart';
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
      body: BlocProvider(
        create: (context) => RestorePasswordBloc(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: _RestorePasswordWidget(),
          ),
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
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {},
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // TODO: Add translation
                    const Text(
                      'Xush kelibsiz!',
                      style: headline1,
                    ),
                    const SizedBox(height: 80),
                    CustomTextField(
                      errorText: state is ErrorAuthPhoneState ? state.message : null,
                      controller: _phoneController,
                      // TODO: Add translations
                      hintText: 'Raqam',
                      suffixIcon: Icons.phone,
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          // TODO: Add translations
                          return 'Fill the form';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 180.0),
                    CustomAppButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(
                            AuthPhoneEvent(_phoneController.text),
                          );
                        }
                      },
                      loaderIndicator: state is LoadingAuthPhoneState,
                      label: 'Kirish', // TODO: Add translations
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
