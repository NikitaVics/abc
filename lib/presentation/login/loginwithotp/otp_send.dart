import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/notifications/notification_service.dart';
import 'package:tennis_court_booking_app/presentation/home/home_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar_login.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/otp_input.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpSendScreen extends StatefulWidget {
  final String email;
  const OtpSendScreen({super.key, required this.email});

  @override
  OtpSendScreenState createState() => OtpSendScreenState();
}

class OtpSendScreenState extends State<OtpSendScreen> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  SharedPreferences? pref;
  int resendTime = 100;
  late Timer countdownTimer;
  String? otp;
  bool isLoading = false;
  String? devToken;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    startTimer();
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    //notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) async {
      devToken = value;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('deviceToken', value);
      print('device token');
      print(value);
    });
  }

  bool allowNavigation = true;
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
    return AbsorbPointer(
      absorbing: isLoading || isLoad,
      child: WillPopScope(
        onWillPop: () async {
          if (allowNavigation) {
            Navigator.pop(context);
            return true;
          } else {
            // Prevent navigation from this screen.
            return false;
          }
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
              isIcon: true,
              isBoarder: true,
              title: (AppLocalizations.of(context)!.loginWithOtp),
              isProgress: false,
              step: 0,
            ),
            body: _buildBody(),
          ),
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
            const SizedBox(
              height: 18,
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
                      ? AppColors.darkSubHead
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
            resendTime != 0
                ? Text(
                    (AppLocalizations.of(context)!.codeExpire),
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSubHead
                            : AppColors.subheadColor,
                        fontSize: 14,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 14),
                  )
                : AutoSizeText(
                    (AppLocalizations.of(context)!.expireNote),
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSubHead
                            : AppColors.subheadColor,
                        fontSize: 12,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 20 / 12),
                  ),
            resendTime != 0
                ? Text(
                    " ${strFormatting(resendTime)} ",
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
            isLoad = true;
          });
          signInProvider.loginWithOtp(widget.email).then((val) {
            if (val["statusCode"] == 200) {
              restartTimer();
            }
            setState(() {
              isLoad = false;
            });
          });
        },
        child: resendTime != 0
            ? Visibility(
                visible: !(resendTime != 0),
                child: Text(
                  (AppLocalizations.of(context)!.resendCode),
                  style: TextStyle(
                    color: isLoad
                        ? AppColors.disableButtonColor
                        : AppColors.dotColor,
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
              text: (AppLocalizations.of(context)!.verifyOtp),
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                bool isValid = await validate();
                if (isValid) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  setState(() {
                    otp = _fieldOne.text +
                        _fieldTwo.text +
                        _fieldThree.text +
                        _fieldFour.text;
                    isLoading = true;
                  });
                  value
                      .sendOtpforlogin(widget.email, otp!, devToken!)
                      .then((val) {
                    if (val != null && val["statusCode"] == 200) {
                      pref.setString('authToken', val['result']['token']);
                      pref.setString('email', val['result']['user']['email']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavBar(
                                    initial: 0,
                                  )));
                      String? authToken = pref.getString('authToken');
                      if (authToken != null) {
                        print("Auth Token: $authToken");
                      } else {
                        print("Auth Token is not set.");
                      }
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
                  /* if (_formStore.canLogin) {
                DeviceUtils.hideKeyboard(context);
                _userStore.login(
                    _userEmailController.text, _passwordController.text);
              } else {
                _showErrorMessage('Please fill in all fields');
              }*/
                } else {
                  AnimatedToast.showToastMessage(
                    context,
                    (AppLocalizations.of(context)!.otpValidation),
                    const Color.fromRGBO(87, 87, 87, 0.93),
                  );
                }
              },
              isLoading: isLoading,
              buttonColor: AppColors.elevatedColor,
              textColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }

  Future<bool> validate() async {
    return _fieldOne.text.isNotEmpty &&
        _fieldTwo.text.isNotEmpty &&
        _fieldThree.text.isNotEmpty &&
        _fieldFour.text.isNotEmpty;
  }
}
