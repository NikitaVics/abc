import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/notifications/notification_service.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';

class CongratsScreen extends StatefulWidget {
   final String email;
  final String password;
  const CongratsScreen({super.key, required this.email, required this.password});

  @override
  CongratsScreenState createState() => CongratsScreenState();
}

class CongratsScreenState extends State<CongratsScreen> {
  bool isLoading = false;
  String? devToken;
   NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
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

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WillPopScope(
         onWillPop: () async {
          return false; // Prevent going back
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
            body: _buildBody(),
          ),
        ),
      );
    });
  }

  // body methods:--------------------------------------------------------------
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
                           _buildSignInButton()
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: Center(child: _buildRightSide())),
                     _buildSignInButton()
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
          //Assets.carBackground,
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
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildCongrats(),
             const SizedBox(height: 24.0),
            _buildLoginText(),
           
          ],
        ),
      ),
    );
  }

  Widget _buildCongrats() {
    return Padding(
      padding: const EdgeInsets.only(left: 100, right: 100),
      child: Lottie.asset("assets/jsons/Successanimation.json"),
    );
  }

  Widget _buildLoginText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Congrats!",
          style: TextStyle(
            color: AppColors.dotColor,
            fontSize: 38,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w700,
            height: 40 / 32,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          "Your Account was ",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSubHead
                : AppColors.subheadColor,
            fontSize: 16,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "successfull created.",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSubHead
                : AppColors.subheadColor,
            fontSize: 16,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

 Widget _buildSignInButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: FocusScope(
          // Manage keyboard focus
          child: Consumer<SignInProvider>(builder: (context, value, child) {
            void loginButtonPressed() async {
              FocusManager.instance.primaryFocus?.unfocus();
              SharedPreferences pref = await SharedPreferences.getInstance();
                setState(() {
                  isLoading = true;
                });
               value
                    .loginApi(
                 widget.email,
                 widget.password,
                devToken!
                )
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
            }

            return CustomElevatedButton(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              isLoading: isLoading,
              text: "Go Home",
              onPressed:
                   loginButtonPressed,
              buttonColor: AppColors.elevatedColor,
              textColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }
}
