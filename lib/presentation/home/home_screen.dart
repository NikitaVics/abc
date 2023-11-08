import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/home_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    // provider = Provider.of<SignInProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkThemeback
            : AppColors.lightThemeback,
        primary: true,
        appBar: const HomeAppBar(
          isBoarder: true,
          title: "Login",
          isProgress: false,
          step: 0,
        ),
        body: _buildBody(),
      );
    });
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.homeBack,
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
                          // _buildSignInButton()
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: _buildRightSide()),
                    // _buildSignInButton()
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLoginText(),
            _buildSignInButton(),
            _buildSlotshowText(),

            // _buildForgotPasswordButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Book your ",
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
            Text(
              "slot today ! ",
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
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 72,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: Row(children: [
                SizedBox(
                  width: 21,
                ),
                Text(
                  "Select Date",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.headingTextColor
                        : AppColors.subheadColor,
                    fontSize: 14,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w700,
                    height: 24 / 14,
                  ),
                ),
                SizedBox(width: 8),
                Image.asset(
                  "assets/images/calender.png",
                  height: 17,
                )
              ]),
            )
          ],
        ),
        Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              "assets/images/homeImage.png",
              height: 171,
            )),
      ]),
    );
  }

  Widget _buildSignInButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FocusScope(
            // Manage keyboard focus
            child: CustomElevatedButton(
          height: 60,
          width: MediaQuery.of(context).orientation == Orientation.landscape
              ? 70
              : double.infinity,
          isLoading: false,
          text: "Start Booking",
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            SharedPreferences pref = await SharedPreferences.getInstance();

            pref.remove('authToken');
            // ignore: use_build_context_synchronously
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));

/*
            setState(() {
              isLoading = true;
            });
           

            setState(() {
              isLoading = false;
            });
            */
          },
          buttonColor: AppColors.elevatedColor,
          textColor: Colors.white,
        )));
  }

  Widget _buildSlotshowText() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Our courts",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.headingTextColor
                    : AppColors.allHeadColor,
                fontSize: 24,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w700,
                height: 32 / 24,
              ),
            ),
            const Row(
              children: [
                Text(
                  "Junior",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.50),
                    fontSize: 12,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w700,
                    height: 24 / 12,
                  ),
                ),
                SizedBox(
                  width: 46,
                ),
                Text(
                  "Senior",
                  style: TextStyle(
                    color: AppColors.dotColor,
                    fontSize: 12,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w700,
                    height: 24 / 12,
                  ),
                ),
              ],
            )
          ],
        ));
  }

  // General Methods:-----------------------------------------------------------

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree

    _passwordFocusNode.dispose();
    super.dispose();
  }
}
