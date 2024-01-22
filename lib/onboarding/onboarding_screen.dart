import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/announcement/announcement_screen.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/constants/onboarding_data.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_as_member.dart';
import 'package:tennis_court_booking_app/presentation/register/register.dart';
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
                currentPage: _currentPage,
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child:_currentPage < OnboardingData.onboardingData.length - 1?
              CustomElevatedButton(
                height: 60,
                width: MediaQuery.of(context).orientation == Orientation.landscape
              ? 70
              : double.infinity,
                text: 'Next',
                isLoading: false,
                onPressed: () {
                  _pageController.animateToPage(
                    _currentPage + 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                buttonColor: AppColors.elevatedColor,
                textColor: Colors.white,
              ):SizedBox(),
          ),
          Positioned(
              top: 36,
              // left: 319,
              right: 24,
              child: _currentPage < OnboardingData.onboardingData.length - 1
                  ? TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          _currentPage + 2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: const Text(
                        "SKIP",
                        style: TextStyle(
                         
                          
                          color: AppColors.allHeadColor,
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
                    isLoading: false,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AnnouncementScreen(),
                        ),
                      );
                    },
                    buttonColor: Colors.white,
                    textColor: AppColors.loginButtonColor,
                  ),
                  CustomElevatedButton(
                    height: 60,
                    width: 153,
                    text: 'Register Now',
                    isLoading: false,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterAsMember(),
                        ),
                      );
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
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String text;
  final String subtext;
  final int currentPage;
 

  const OnboardingPage(
      {super.key,
      required this.image,
      required this.text,
      required this.subtext, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 24,right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 279,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                ),
              ),
            ),
             const SizedBox(
              height: 38,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        OnboardingData.onboardingData.length,
                        (index) => buildDot(index),
                      ),
                    ),
            ),
             const SizedBox(
              height: 35,
            ),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.allHeadColor,
                fontSize: 32,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              subtext,
              style: const TextStyle(
                color: AppColors.subheadColor,
                fontSize: 16,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    if (currentPage < OnboardingData.onboardingData.length ) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? AppColors.dotColor : AppColors.appbarBoarder,
          ));
    } else {
      // Return an empty container for the last page to hide the dot
      return Container();
    }
  }
}
