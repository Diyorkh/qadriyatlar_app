import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:qadriyatlar_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/auth/widget/auth_phone_widget.dart';
import 'package:qadriyatlar_app/presentation/widgets/loader_widget.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';
import 'package:qadriyatlar_app/theme/const_styles.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const String routeName = '/authScreen';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => EditProfileBloc(),
        ),
      ],
      child: SignInScreenWidget(key: key),
    );
  }
}

class SignInScreenWidget extends StatefulWidget {
  const SignInScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreenWidget> createState() => _SignInScreenWidgetState();
}

class _SignInScreenWidgetState extends State<SignInScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Colors.white,
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: ColorApp.mainColor,
                      ),
                    )
                  : const SizedBox(),
              actions: [
                BlocListener<LanguagesBloc, LanguagesState>(
                  listener: (context, state) {
                    if (state is SuccessChangeLanguageState) {
                      // Updated global variables for change translations
                      setState(() {
                        localizations.saveCustomLocalization(state.locale);
                      });

                      BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent());
                    }
                  },
                  child: BlocBuilder<LanguagesBloc, LanguagesState>(
                    builder: (context, state) {
                      if (state is LoadingChangeLanguageState || state is LoadingLanguagesState) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: LoaderWidget(
                            loaderColor: ColorApp.mainColor,
                          ),
                        );
                      }

                      if (state is LoadedLanguagesState) {
                        return PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return state.languagesResponse.map((e) {
                              return PopupMenuItem(
                                value: e.code,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.nativeName,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    if (preferences.getString(PreferencesName.selectedLangAbbr) == e.code)
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                          onSelected: (String selectedLanguage) {
                            BlocProvider.of<LanguagesBloc>(context).add(SelectLanguageEvent(selectedLanguage));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.language_outlined,
                                color: ColorApp.mainColor,
                              ),
                            ),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: <Widget>[
                  Center(
                    child: const Text(
                      'Xush kelibsiz!', // TODO: 27.09.2023 Add Translations
                      style: headline1,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: const Text(
                      'Iltimos, akkauntingizga kiring', // TODO: 27.09.2023 Add Translations
                      style: headline3,
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  AuthPhoneWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
