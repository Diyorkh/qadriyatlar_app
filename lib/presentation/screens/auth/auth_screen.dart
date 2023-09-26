import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/widget/auth_phone_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
      child: AuthScreenWidget(key: key),
    );
  }
}

class AuthScreenWidget extends StatefulWidget {
  const AuthScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreenWidget> createState() => _AuthScreenWidgetState();
}

class _AuthScreenWidgetState extends State<AuthScreenWidget> {
  String? get appLogo => preferences.getString(PreferencesName.appLogo);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(110.0), // here th
            child: AppBar(
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: true,
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
              title: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: CachedNetworkImage(
                  width: 50.0,
                  imageUrl: appLogo ?? '',
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) {
                    return SizedBox(
                      width: 83.0,
                      child: Image.asset(ImagePath.logo),
                    );
                  },
                ),
              ),
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
