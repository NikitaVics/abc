
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 82),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.0, -1.0),
            end: Alignment(0.0, 1.0),
            colors: [Color(0xFF4ECB71), Color(0xFF259445)],
            stops: [0.0, 1.0],
            transform: GradientRotation(97 * 3.1415927 / 180),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.logoFirst.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontFamily: 'Satoshi',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                wordSpacing: 2.0,
              ),
            ),
            Text(
              Strings.logoLast.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontFamily: 'Satoshi',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                wordSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
