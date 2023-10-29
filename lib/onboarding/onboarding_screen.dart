import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/constants/onboarding_data.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: OnboardingData.onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                image: OnboardingData.onboardingData[index]['image']!,
                text: OnboardingData.onboardingData[index]['headingtext']!,
                subtext: OnboardingData.onboardingData[index]['subtext']!,
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    OnboardingData.onboardingData.length,
                    (index) => buildDot(index),
                  ),
                ),
                if (_currentPage < OnboardingData.onboardingData.length - 1)
                  CustomElevatedButton(
                    height: 60,
                    width: 153,
                    text: 'Next',
                    onPressed: () {
                      _pageController.animateToPage(
                        _currentPage + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    buttonColor: AppColors.elevatedColor,
                    textColor: Colors.white,
                  )
              ],
            ),
          ),
          Positioned(
              top: 36,
              left: 319,
              right: 24,
              child: _currentPage < OnboardingData.onboardingData.length - 1
                  ? TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationThickness: 2.0,
                          color: AppColors.headingTextColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w700,
                          height: 24 / 16,
                        ),
                      ))
                  : Container()),
          if (_currentPage == OnboardingData.onboardingData.length - 1)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 CustomElevatedButton(
                   height: 60,
                    width: 153,
                    text: 'Login',
                    onPressed: () {
                     Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>  LoginScreen(),
    ),
  );
                    },
                    buttonColor: AppColors.transparent,
                    textColor: AppColors.loginButtonColor,
                  ),
                  CustomElevatedButton(
                     height: 60,
                    width: 153,
                    text: 'Register Now',
                    onPressed: () {
                     
                    },
                    buttonColor: AppColors.elevatedColor,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    if (_currentPage < OnboardingData.onboardingData.length - 1) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? AppColors.dotColor : Colors.grey,
          ));
    } else {
      // Return an empty container for the last page to hide the dot
      return Container();
    }
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String text;
  final String subtext;

  const OnboardingPage(
      {super.key, required this.image, required this.text, required this.subtext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(1.0), // 100% black
                  Colors.black.withOpacity(0.8), // 80% black
                  Colors.black.withOpacity(0.7), // 70% black
                  Colors.transparent,
                ],
                stops: const [0.0, 0.2, 0.3, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 510, // Adjust the position of the text as needed
            left: 24,
            right: 53,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.headingTextColor,
                    fontSize: 32,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  subtext,
                  style: const TextStyle(
                    color: AppColors.headingTextColor,
                    fontSize: 16,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
