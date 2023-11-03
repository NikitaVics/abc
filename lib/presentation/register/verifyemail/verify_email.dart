// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/forgotPassword/reset_pass.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/presentation/register/register.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/otp_input.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  VerifyEmailScreenState createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  SharedPreferences? pref;
  int resendTime = 100;
  late Timer countdownTimer;
  String? otp;
  @override
  void initState() {
    startTimer();
    super.initState();
    
  }

  startTimer() {
    try {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          resendTime = resendTime - 1;
        });
        if (resendTime < 1) {
          countdownTimer.cancel();
        }
      });
    } catch (e) {
      print('Timer Error: $e');
    }
  }

  stopTimer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  String strFormatting(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '$minutes:${remainingSeconds.toString().padLeft(2, '0')} ';
    return formattedTime;
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.lightThemeback,
      primary: true,
      appBar: const CustomAppBar(
        isBoarder: true,
        title: "Verify mail id",
        isProgress: false,
        step: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.lightThemeback,
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(child: _buildLeftSide()),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildRightSide(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: Center(child: _buildRightSide())),
                    _buildforgotPassButton()
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox(
      width: 300,
      child: SizedBox.expand(
        child: Image.asset(
          "assets/images/onboard_back_one.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLoginText(),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(_fieldOne, true),
                OtpInput(_fieldTwo, false),
                OtpInput(_fieldThree, false),
                OtpInput(_fieldFour, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify with Otp",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.headingTextColor
                : AppColors.allHeadColor,
            fontSize: 32,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w700,
            height: 40 / 32,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(
              "Code sent to ",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSubHead
                      : AppColors.subheadColor,
                  fontSize: 14,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w400,
                  height: 24 / 14),
            ),
            Text(
              widget.email,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSubHead
                      : AppColors.subheadColor,
                  fontSize: 14,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w400,
                  height: 24 / 14),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "This code will expired in ",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSubHead
                      : AppColors.subheadColor,
                  fontSize: 14,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w400,
                  height: 24 / 14),
            ),
            resendTime != 0
                ? Text(
                    strFormatting(resendTime),
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSubHead
                            : AppColors.subheadColor,
                        fontSize: 14,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 14),
                  )
                : SizedBox()
          ],
        ),
      ],
    );
  }

  Widget _buildResendText() {
    return Text(
      "Resend Code",
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.headingTextColor
            : AppColors.allHeadColor,
        fontSize: 32,
        fontFamily: FontFamily.satoshi,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
      ),
    );
  }

  Widget _buildforgotPassButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: FocusScope(
          // Manage keyboard focus
          child: Consumer<SignInProvider>(builder: (context, value, child) {
            return CustomElevatedButton(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              text: "Verify Otp",
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                SharedPreferences pref = await SharedPreferences.getInstance();
                setState(() {
                  otp = _fieldOne.text +
                      _fieldTwo.text +
                      _fieldThree.text +
                      _fieldFour.text;
                });
                value
                    .verifyEmailForgotPasswordApi(
                  widget.email,
                  otp!,
                )
                    .then((val) {
                  if (val["statusCode"] == 200) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterForm()),
                    );
                    print(val);
                  } else {
                    setState(() {
                      print(val['errorMessage']);
                    });
                  }
                });
                /* if (_formStore.canLogin) {
                DeviceUtils.hideKeyboard(context);
                _userStore.login(
                    _userEmailController.text, _passwordController.text);
              } else {
                _showErrorMessage('Please fill in all fields');
              }*/
              },
              buttonColor: AppColors.elevatedColor,
              textColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }
}
