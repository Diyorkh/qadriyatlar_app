import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/bloc/restore_password/restore_password_bloc.dart';
import 'package:qadriyatlar_app/presentation/widgets/alert_dialogs.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_app_button.dart';
import 'package:qadriyatlar_app/presentation/widgets/custom_text_field.dart';
import 'package:qadriyatlar_app/presentation/widgets/flutter_toast.dart';
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
  final _emailController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestorePasswordBloc, RestorePasswordState>(
      listener: (context, state) {
        if (state is SuccessRestorePasswordState) {
          showFlutterToast(
            title: localizations.getLocalization('restore_password_info'),
          );
        }

        if (state is ErrorRestorePasswordState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              content: unescape.convert(state.message),
            ),
          );
        }
      },
      child: BlocBuilder<RestorePasswordBloc, RestorePasswordState>(
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
                    controller: _emailController,
                    hintText: 'Raqam',
                    suffixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 180.0),
                  CustomAppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<RestorePasswordBloc>(context)
                            .add(SendRestorePasswordEvent(_emailController.text));
                      }
                    },
                    loaderIndicator: state is LoadingRestorePasswordState,
                    label: localizations.getLocalization('restore_password_button'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
