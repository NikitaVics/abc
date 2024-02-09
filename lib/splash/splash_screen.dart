
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/strings.dart';
import 'package:tennis_court_booking_app/onboarding/onboarding_screen.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  SharedPreferences? pref;

  autoLogin() async {
   
  
    String token = await SharePref.fetchAuthToken();
    print(token);
    if (token.isNotEmpty) {
    
      // ignore: use_build_context_synchronously
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const BottomNavBar(
                                  initial: 0,
                                )),
          (Route route) => false,
        );
      });
    } else {
      print(token);
      // ignore: use_build_context_synchronously
       Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const OnboardingScreen()),
          (Route route) => false,
        );
      });
    }
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
