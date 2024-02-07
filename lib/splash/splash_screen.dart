
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/strings.dart';
import 'package:tennis_court_booking_app/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  //SharedPreferences? pref;

  autoLogin() async {
    Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const OnboardingScreen()),
          (Route route) => false,
        );
      });
   /* pref = await SharedPreferences.getInstance();
    String token = await fetchAuthToken();
    print(token);
    if (token.isNotEmpty) {
      await Api.fetchDashboardData(token);
      // ignore: use_build_context_synchronously
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const Navbar()),
          (Route route) => false,
        );
      });
    } else {
      print(token);
      // ignore: use_build_context_synchronously
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SplashScreenThree(),
          ),
        );
      });
    }*/
  }

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: Color(0xffEDFAF1),
      body: Center(
        child: Image.asset("assets/images/splashIcon.png",
        height: 102,),
      ),
    );
  }
}
