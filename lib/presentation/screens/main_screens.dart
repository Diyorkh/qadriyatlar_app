import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:qadriyatlar_app/core/utils/utils.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/screens/auth/screens/sign_in_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/courses/courses_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/favorites/favorites_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/home/home_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/home_simple/home_simple_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/profile/profile_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/search/search_screen.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class MainScreenArgs {
  MainScreenArgs({this.selectedIndex});

  final int? selectedIndex;
}

class MainScreen extends StatelessWidget {
  static const String routeName = '/mainScreen';

  @override
  Widget build(BuildContext context) {
    final MainScreenArgs args = ModalRoute.of(context)?.settings.arguments as MainScreenArgs;

    return MainScreenWidget(selectedIndex: args.selectedIndex);
  }
}

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({this.selectedIndex}) : super();

  final int? selectedIndex;

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreenWidget> {
  int _selectedIndex = 0;
  final _selectedItemColor = ColorApp.mainColor;
  final _unselectedItemColor = ColorApp.unselectedColor;

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(microseconds: 500),
        child: _getBody(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        selectedFontSize: 10,
        backgroundColor: ColorApp.white,
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(IconlyLight.home, 0),
            label: localizations.getLocalization('home_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconlyLight.search, 1),
            label: localizations.getLocalization('search_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconlyLight.play, 2),
            label: localizations.getLocalization('courses_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconlyLight.heart, 3),
            label: localizations.getLocalization('favorites_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconlyLight.profile, 4),
            label: localizations.getLocalization('profile_bottom_nav'),
          ),
        ],
      ),
    );
  }

  Color? _getItemColor(int index) => _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;

  Widget _buildIcon(IconData iconData, int index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Icon(
          iconData,
          color: _getItemColor(index),
        ),
      );

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return appView ? HomeSimpleScreen() : HomeScreen();
      case 1:
        return SearchScreen();
      case 2:
        return CoursesScreen();
      case 3:
        return FavoritesScreen();
      case 4:
        if (!isAuth()) {
          return SignInScreen();
        } else {
          return ProfileScreen();
        }
      default:
        return Center(
          child: Text(
            'Not implemented!',
            textScaleFactor: 1.0,
          ),
        );
    }
  }
}
