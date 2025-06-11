import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/welcome_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // Save onboarding completion status
  Future<void> saveOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false); // Mark onboarding as completed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          top: false,
          child: Stack(children: [
            PageView(controller: pageController, children: [
              buildpage(
                darkvector: "assets/Dark/g12.png",
                bgimage: 'assets/onboarding/screen 1.png',
                vector: 'assets/onboarding/g12.png',
                title: 'Have you read today?',
                subtitle: 'Read every day , the benefits\n are well enough ',
                pageController: pageController,
                saveOnboardingStatus: saveOnboardingStatus, // Pass callback
              ),
              buildpage(
                darkvector: 'assets/Dark/4529181 1.png',
                bgimage: 'assets/onboarding/screen 2.png',
                vector: 'assets/onboarding/g10.png',
                title: 'Read Anywhere, Anytime',
                subtitle:
                    'All in your pocket , access\n anytime, anywhere , any device  ',
                pageController: pageController,
                saveOnboardingStatus: saveOnboardingStatus, // Pass callback
              ),
              buildpage2(
                darkvector: "assets/Dark/g10 (1).png",
                bgimage: 'assets/onboarding/screen 3.png',
                vector: 'assets/onboarding/g10 (1).png',
                title: 'Unlimited Knowledge',
                subtitle:
                    'Help you carry an almost\n unlimited amount of books',
                onGetStarted: () async {
                  await saveOnboardingStatus(); // Save status when Get Started is pressed
                  Get.to(
                    () => const WelcomeScreen(),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 300),
                  );
                },
              ),
            ]),
            Positioned(
              left: 25,
              right: 50,
              bottom: 30,
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Color(0xffC86B60)
                          : Color(0xffFF9A8C),
                  dotHeight: 15,
                  dotWidth: 15,
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () async {
                  await saveOnboardingStatus(); // Save status when Skip is pressed
                  Get.to(
                    () => const WelcomeScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 365, top: 50, right: 1),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.5)
                            : Color(0xff4A536D),
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class buildpage extends StatelessWidget {
  const buildpage({
    super.key,
    required this.bgimage,
    required this.darkvector,
    required this.title,
    required this.subtitle,
    required this.vector,
    required this.pageController,
    required this.saveOnboardingStatus, // Callback for saving onboarding status
  });

  final String vector;
  final String darkvector;
  final String bgimage;
  final String title;
  final String subtitle;
  final PageController pageController;
  final Future<void> Function() saveOnboardingStatus; // Callback type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xff3A6F73)
                : Color(0xffAED6DC),
            bgimage,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 10),
            child: Image.asset(
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? darkvector
                  : vector,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.inter(
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: Center(
              child: Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.5)
                      : Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Positioned(
            left: 50,
            right: -240,
            bottom: 30,
            child: GestureDetector(
              onTap: () async {
                final currentPage = pageController.page?.toInt() ?? 0;
                if (currentPage < 2) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  await saveOnboardingStatus(); // Save status when Next is pressed
                  Get.to(
                    () => const WelcomeScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 300),
                  );
                }
              },
              child: Container(
                height: 60,
                width: 60,
                child: Image.asset(
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? 'assets/Dark/Frame6.png'
                      : 'assets/onboarding/next.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class buildpage2 extends StatelessWidget {
  const buildpage2(
      {super.key,
      required this.bgimage,
      required this.title,
      required this.subtitle,
      required this.vector,
      required this.onGetStarted,
      required this.darkvector // Callback for Get Started
      });

  final String vector;
  final String darkvector;
  final String bgimage;
  final String title;
  final String subtitle;
  final VoidCallback onGetStarted; // Callback type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xff3A6F73)
                : Color(0xffAED6DC),
            bgimage,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 10),
            child: Image.asset(
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? darkvector
                  : vector,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: Center(
              child: Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.5)
                      : Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 80,
            child: MaterialButton(
                hoverColor: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xffC86B60)
                    : Color(0xffFF9A8C),
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                onPressed:
                    onGetStarted, // Use callback when Get Started is pressed
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xffC86B60)
                    : Color(0xffFF9A8C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
