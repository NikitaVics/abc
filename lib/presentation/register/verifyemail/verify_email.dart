// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/forgotPassword/reset_pass.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/congrats_screen.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_as_member.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/presentation/register/register.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/otp_input.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String password;

  const VerifyEmailScreen(
      {super.key, required this.email, required this.password});

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
  bool isLoading = false;
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

  Future _onWilPop() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterAsMember()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onWilPop(); // Prevent going back
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkThemeback
              : AppColors.lightThemeback,
          primary: true,
          appBar: CustomAppBar(
            isIcon: false,
            isBoarder: true,
            title: (AppLocalizations.of(context)!.verifyMail),
            isProgress: false,
            step: 0,
          ),
          body: _buildBody(),
        ),
      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OtpInput(_fieldOne, true),
                
                OtpInput(_fieldTwo, false),
                
                OtpInput(_fieldThree, false),
                
                OtpInput(_fieldFour, false),
              ],
            ),
            _buildResendText()
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
          (AppLocalizations.of(context)!.verifywithOtp),
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
              (AppLocalizations.of(context)!.codeSent),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.profileDarkText
                      : AppColors.subheadColor,
                  fontSize: 14,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w400,
                  height: 24 / 14),
            ),
            Text(
              " ${widget.email} ",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.profileDarkText
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
            resendTime != 0
                ? Text(
                    (AppLocalizations.of(context)!.codeExpire),
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.profileDarkText
                            : AppColors.subheadColor,
                        fontSize: 14,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 14),
                  )
                : Text(
                    (AppLocalizations.of(context)!.expireNote),
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.profileDarkText
                            : AppColors.subheadColor,
                        fontSize: 14,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 14),
                  ),
            resendTime != 0
                ? Text(
                   " ${strFormatting(resendTime)} " ,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.profileDarkText
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

  bool isLoad = false;

  Widget _buildResendText() {
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    void restartTimer() {
      setState(() {
        resendTime = 100;
      });
      startTimer();
    }

    return Align(
      alignment: Alignment.topLeft,
      child: TextButton(
        onPressed: () {
          setState(() {
            isLoad = false;
          });
          signInProvider.loginWithOtp(widget.email).then((val) {
            if (val["statusCode"] == 200) {
              restartTimer();
            }
              setState(() {
            isLoad =false;
          });
          });
        },
        child: resendTime != 0
            ? Visibility(
               visible:!(resendTime != 0) ,
              child: Text(
                  (AppLocalizations.of(context)!.resendCode),
                  style: TextStyle(
                    color: AppColors.dotColor,
                    fontSize: 14,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            )
            : WidgetAnimator(
                atRestEffect: WidgetRestingEffects.size(),
                child: Text(
                  (AppLocalizations.of(context)!.resendCode),
                  style: TextStyle(
                    color: AppColors.dotColor,
                    fontSize: 14,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }

  bool yuColor = false;

  Widget _buildforgotPassButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: FocusScope(
          // Manage keyboard focus
          child: Consumer<SignInProvider>(builder: (context, value, child) {
            return CustomElevatedButton(
              isLoading: isLoading,
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              text: (AppLocalizations.of(context)!.verifyOtp),
              onPressed: () async {
                bool isValid = await validate();
                if (isValid) {
                  setState(() {
                    yuColor = true;
                  });
                  _verifyOtp();
                }
                else{
                   AnimatedToast.showToastMessage(
                          context,
                        (AppLocalizations.of(context)!.otpValidation),
                          const Color.fromRGBO(87, 87, 87, 0.93),
                        );
                }
              },
              buttonColor: AppColors.elevatedColor,
              textColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }

  bool allFieldsFilled = false;

  Future<bool> validate() async {
    return _fieldOne.text.isNotEmpty &&
        _fieldTwo.text.isNotEmpty &&
        _fieldThree.text.isNotEmpty &&
        _fieldFour.text.isNotEmpty;
  }

  void _verifyOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      otp =
          _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text;
    });

    setState(() {
      isLoading = true;
    });

    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    signInProvider.verifyEmail(widget.email, otp!).then((val) {
      if (val["statusCode"] == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CongratsScreen(
              email: widget.email,
              password: widget.password,
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          if (val != null) {
            AnimatedToast.showToastMessage(
              context,
              val["errorMessage"][0],
              const Color.fromRGBO(87, 87, 87, 0.93),
            );
          }
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
