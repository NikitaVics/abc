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
            _buildShowCourt(),
            _buildrecentBookText(),
            _buildNoBook()

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
        padding: const EdgeInsets.only(top: 20, bottom: 20),
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

  Widget _buildShowCourt() {
    final List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    return SizedBox(
      height: 160,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 145,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 8),
                        child: Container(
                          height: 82,
                          child: Image.asset("assets/images/court.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, right: 22),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Court  ${numbers[index]}",
                                  style: TextStyle(
                                    color: AppColors.allHeadColor,
                                    fontSize: 16,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w500,
                                    height: 24 / 16,
                                  ),
                                ),
                                Text(
                                  " 10 am -7 pm",
                                  style: TextStyle(
                                    color: AppColors.hintColor,
                                    fontSize: 12,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w400,
                                    height: 16 / 12,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    "assets/images/Right.png",
                                    height: 24,
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildrecentBookText() {
    return Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Bookings",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.headingTextColor
                    : AppColors.allHeadColor,
                fontSize: 20,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w700,
                height: 32 / 20,
              ),
            ),
            const Text(
              "See all",
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 2.0, // Set the thickness of the underline
                decorationStyle: TextDecorationStyle.solid,

                color: AppColors.dotColor,
                fontSize: 14,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w700,
                height: 24 / 14,
              ),
            ),
          ],
        ));
  }

  Widget _buildNoBook() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 138,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
              child: Image.asset(
                                      "assets/images/Nobooking.png",
                                      
                                    ),
            ),
           Column(
             mainAxisAlignment: MainAxisAlignment.center, 
             children: [
              
               
           SizedBox(
             width: 147,
             
             child: RichText(
             text: const TextSpan(
               children: <TextSpan>[
                 TextSpan(
             text:"No Recent Bookings  ",
             style: TextStyle(
               color: AppColors.subheadColor,
               fontSize: 12,
               fontFamily: FontFamily.satoshi,
               fontWeight: FontWeight.w400,
               height: 20 / 12,
             ),
           ),
                 TextSpan(
                   text: 'Complete your profile ', // The first half of the sentence
                    style: TextStyle(
               color: AppColors.disableButtonTextColor,
               fontSize: 12,
               fontFamily: FontFamily.satoshi,
               fontWeight: FontWeight.w400,
               height: 20 / 12,
             ),
                 ),
                 TextSpan(
                   text: 'to start booking', // The second half of the sentence
                   style: TextStyle(
               color: AppColors.hintColor,
               fontSize: 12,
               fontFamily: FontFamily.satoshi,
               fontWeight: FontWeight.w400,
               height: 20 / 12,
             ),
                 ),
               ],
             ),
           ),
           )

             ],
           )
          ],
        ),
      ),
    );
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
