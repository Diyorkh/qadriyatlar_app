import 'package:flutter/material.dart';
import 'package:qadriyatlar_app/core/constants/assets_path.dart';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/presentation/screens/main_screens.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const String routeName = '/onboardingScreen';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // TODO: 27.09.2023 Add translations
  final List<SlideContent> _slideContents = [
    SlideContent(
      title: "Har qachon \nva har joyda o'rganing",
      subtitle: "Karantin o'rganish uchun \neng yaxshi vaqtdir, \nhech qayerdan ham!",
    ),
    SlideContent(
      title: "Siz uchun kurs \ntoping",
      subtitle: "Karantin o'rganish uchun \neng yaxshi vaqtdir, \nhech qayerdan ham!",
    ),
    SlideContent(
      title: "Ko'nikmalaringizni \noshiring",
      subtitle: "Karantin o'rganish uchun \neng yaxshi vaqtdir, \nhech qayerdan ham!",
    ),
  ];

  final List<String> _slideImages = [
    ImagePath.introOne,
    ImagePath.introTwo,
    ImagePath.introThree,
  ];

  void _skipIntro() {
    preferences.setBool(PreferencesName.firstEntry, true);

    Navigator.of(context).pushNamedAndRemoveUntil(
      MainScreen.routeName,
      arguments: MainScreenArgs(),
      (_) => false,
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _slideContents.length; i++) {
      indicators.add(
        i == _currentPage ? _indicator(true) : _indicator(false),
      );
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff192A59) : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _skipIntro(),
                child: const Text(
                  // TODO: 27.09.2023 Add translations
                  "O'tkazib\nyuborish",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 280,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    _slideImages[_currentPage],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slideContents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final SlideContent content = _slideContents[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        content.title,
                        style: const TextStyle(
                          color: Color(0xff3C3A36),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          content.subtitle,
                          style: const TextStyle(
                            fontSize: 16.5,
                            color: Color(0xff78746D),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _slideContents.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _skipIntro();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0xff192A56),
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      ),
                      child: Text(
                        // TODO: 27.09.2023 Add translations
                        _currentPage < _slideContents.length - 1 ? "Keyingi" : "Boshlash",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class SlideContent {
  SlideContent({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
