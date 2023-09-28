import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/auth/components/google_signin.dart';
import 'package:qadriyatlar_app/presentation/screens/languages/languages_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/main_screens.dart';
import 'package:qadriyatlar_app/presentation/screens/orders/orders_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/profile/widgets/privacy_policy_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/profile/widgets/profile_widget.dart';
import 'package:qadriyatlar_app/presentation/screens/profile/widgets/tile_item.dart';
import 'package:qadriyatlar_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:qadriyatlar_app/presentation/widgets/loader_widget.dart';
import 'package:qadriyatlar_app/presentation/widgets/unauthorized_widget.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';
import 'package:qadriyatlar_app/theme/const_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen() : super();

  @override
  Widget build(BuildContext context) => ProfileScreenWidget();
}

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget() : super();

  @override
  State<StatefulWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget> {
  @override
  void initState() {
    if (BlocProvider.of<ProfileBloc>(context).state is! LoadedProfileState) {
      BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LogoutProfileState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.of(context).pushNamedAndRemoveUntil(
              MainScreen.routeName,
              arguments: MainScreenArgs(),
              (Route<dynamic> route) => false,
            ),
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          if (state is InitialProfileState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is UnauthorizedState) {
            return UnauthorizedWidget(
              onTap: () => Navigator.pushReplacementNamed(
                context,
                MainScreen.routeName,
                arguments: MainScreenArgs(selectedIndex: 4),
              ),
            );
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                centerTitle: true,
                title: Text(
                  'Profile',
                  style: kAppBarTextStyle.copyWith(
                    color: Colors.black,
                  ),
                ),
                elevation: 0.0,
                backgroundColor: Colors.white,
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Header Profile
                    BlocProvider.value(
                      value: BlocProvider.of<ProfileBloc>(context),
                      child: ProfileWidget(),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: const Text(
                        "Qo'shimcha",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // View my profile
                    TileWidget(
                      leadingBackColor: Colors.red[600],
                      title: 'Sevimlar',
                      icon: IconlyLight.heart,
                      onClick: () {
                        Navigator.pushReplacementNamed(
                          context,
                          MainScreen.routeName,
                          arguments: MainScreenArgs(selectedIndex: 3),
                        );
                      },
                    ),
                    // My courses
                    TileWidget(
                      title: 'Mening kurslarim',
                      leadingBackColor: Colors.cyan[600],
                      icon: IconlyLight.bag_2,
                      onClick: () => Navigator.pushReplacementNamed(
                        context,
                        MainScreen.routeName,
                        arguments: MainScreenArgs(selectedIndex: 2),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: const Text(
                        'Sozlamalar',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // My orders
                    TileWidget(
                      leadingBackColor: Colors.green[600],
                      title: "To'lov usuli",
                      icon: IconlyLight.wallet,
                      onClick: () {
                        Navigator.of(context).pushNamed(OrdersScreen.routeName);
                      },
                    ),
                    // Settings
                    TileWidget(
                      leadingBackColor: Colors.yellow[600],
                      title: 'Settings',
                      icon: IconlyLight.setting,
                      onClick: () {
                        if (state is LoadedProfileState) {
                          Navigator.pushNamed(
                            context,
                            ProfileEditScreen.routeName,
                            arguments: ProfileEditScreenArgs(state.account),
                          );
                        }
                      },
                    ),

                    // Settings
                    TileWidget(
                      leadingBackColor: Colors.grey[400],
                      title: 'Til',
                      icon: Icons.language_outlined,
                      onClick: () => Navigator.of(context).pushNamed(LanguagesScreen.routeName),
                    ),

                    // Settings
                    TileWidget(
                      leadingBackColor: Colors.grey[400],
                      title: 'Foydalanuvchi shartnomasi',
                      icon: IconlyLight.document,
                      onClick: () => Navigator.pushNamed(
                        context,
                        PrivacyPolicyScreen.routeName,
                        arguments: PrivacyPolicyScreen,
                      ),
                    ),

                    Center(
                      child: TextButton(
                        onPressed: () => _showLogoutDialog(context),
                        child: Text(
                          'Chiqish',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.getLocalization('logout'),
            textScaleFactor: 1.0,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          content: Text(
            localizations.getLocalization('logout_message'),
            textScaleFactor: 1.0,
          ),
          actions: [
            TextButton(
              child: Text(
                localizations.getLocalization('cancel_button'),
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: ColorApp.mainColor,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                localizations.getLocalization('logout'),
                textScaleFactor: 1.0,
                style: TextStyle(color: ColorApp.mainColor),
              ),
              onPressed: () {
                GoogleSignInProvider().logoutGoogle();
                BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
