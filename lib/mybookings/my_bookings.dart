// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/courtshowprovider.dart';
import 'package:tennis_court_booking_app/presentation/home/model/checkstatus.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/profile/model/profile_model.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/tennismodel/teniscourt/court.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/funky_overlay.dart';
import 'package:tennis_court_booking_app/widgets/home_appbar.dart';
import 'package:intl/intl.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  MyBookingScreenState createState() => MyBookingScreenState();
}

class MyBookingScreenState extends State<MyBookingScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  bool juniorColor = false, seniorColor = false;

  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    isFirstButtonSelected = true;
    profile();
  }

  bool isFirstButtonSelected = false;
  bool isSecondButtonSelected = false;
  bool isFormDone = false;
  String name = "";
  String? tokens;
  Future<void> profile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    profileProvider.fetchProfile(token);
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkThemeback
            : AppColors.lightThemeback,
        primary: true,
        appBar: AppBar(
          
         
          toolbarHeight: 72,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "My Bookings",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.headingTextColor
                        : AppColors.profileHead,
                    fontSize: 20,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w700,
                    height: 32 / 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          backgroundColor:  Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkTextInput
                            : Colors.white,
          elevation: 0,
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
        child: Column(
          children: [
            Expanded(child: _buildRightSide()),
          ],
        ));
  }

  Widget _buildRightSide() {
    return Container(
      color:  Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.homeBack,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBookingButton(),
            isFirstButtonSelected
                ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 5,

                      itemBuilder: (context, index) {
                        return _buildupComingbooking(index,5);

                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return _buildProfilePerformance(index,10);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(150.0),
              child: imageUrl!.isNotEmpty
                  ? Image.asset(
                      "assets/images/userImage.png",
                      width: 80.0,
                      height: 80.0,
                    )
                  /* SilentErrorImage(
                      width: 48.0,
                      height: 48.0,
                      imageUrl: imageUrl!,
                    )*/
                  : const Icon(
                      Icons.account_circle, // or any other default icon
                      size: 48.0,
                      color: Colors.grey,
                    ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              name,
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
            const SizedBox(
              height: 20,
            ),
          ]),
        ));
  }

  Widget _buildBookingButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 20, left: 7, right: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                height: 40,
                 width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFirstButtonSelected = true;
                      isSecondButtonSelected = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFirstButtonSelected
                        ? AppColors.elevatedColor
                        : Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: isFirstButtonSelected
                                ? Colors.transparent
                                : AppColors.bookingInvalid)),
                  ),
                  child: Text(
                    'Up comming Booking',
                     overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isFirstButtonSelected
                          ? Colors.white
                          : AppColors.bookingInvalid,
                      fontSize: 12,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w700,
                      height: 24 / 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: SizedBox(
                height: 40,
               width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFirstButtonSelected = false;
                      isSecondButtonSelected = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSecondButtonSelected
                        ? AppColors.elevatedColor
                        : Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: isSecondButtonSelected
                                ? Colors.transparent
                                : AppColors.bookingInvalid)),
                  ),
                  child: Text('Previous Booking',
                   overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSecondButtonSelected
                            ? Colors.white
                            : AppColors.bookingInvalid,
                        fontSize: 12,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w700,
                        height: 24 / 12,
                      )),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildupComingbooking(int index, int itemCount) {
    return Column(
      children: [
        Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  "assets/images/Shape.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(150.0),
                            child: ClipRect(
                              child: Image.asset(
                                "assets/images/ProfileImage.png",
                                height: 24,
                                //fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Robert Fox",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 16,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Booking ID -",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 24 / 14,
                            ),
                          ),
                          Text(
                            " 6726GT",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 24 / 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 80,
                bottom: 15,
                left: 14,
                child: Row(
                  children: [
                    Text(
                      "Team -",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.white,
                        fontSize: 14,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 14,
                      ),
                    ),
                    SizedBox(width: 8), // Adjust the spacing
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 18.90,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 37.79,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 56.69,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 37.5,
                //left: 230,
                right: 15,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "AUG",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.allHeadColor,
                            fontSize: 24,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w700,
                            height: 32 / 24,
                          ),
                        ),
                        Text(
                          " 25",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.elevatedColor,
                            fontSize: 24,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w700,
                            height: 32 / 24,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "04:00",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.subheadColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.subheadColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "05:00",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.subheadColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if(index<itemCount-1)
        const Divider(
          color: AppColors.appbarBoarder,
         thickness: 1,
        ),
      ],
    );
  }

  Widget _buildProfilePerformance(int index,int itemCount) {
    return Column(
      children: [
        Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  "assets/images/Shape.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(150.0),
                            child: ClipRect(
                              child: Image.asset(
                                "assets/images/ProfileImage.png",
                                height: 24,
                                //fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Robert Fox",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 16,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Booking ID -",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 24 / 14,
                            ),
                          ),
                          Text(
                            " 6726GT",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 24 / 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 80,
                bottom: 15,
                left: 14,
                child: Row(
                  children: [
                    Text(
                      "Team -",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.white,
                        fontSize: 14,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 14,
                      ),
                    ),
                    SizedBox(width: 8), // Adjust the spacing
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 18.90,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 37.79,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 56.69,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ProfileImage.png',
                              width: 25.44,
                              height: 25.44,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 37.5,
                left: 230,
                right: 15,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "AUG",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.allHeadColor,
                            fontSize: 24,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w700,
                            height: 32 / 24,
                          ),
                        ),
                        Text(
                          " 25",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.elevatedColor,
                            fontSize: 24,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w700,
                            height: 32 / 24,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "04:00",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.subheadColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.subheadColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "05:00",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.subheadColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
         if(index<itemCount-1)
        const Divider(
          color: AppColors.appbarBoarder,
         thickness: 1,
        ),
      ],
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

class SilentErrorImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const SilentErrorImage({
    super.key,
    required this.imageUrl,
    this.width = 48.0,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.fill,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Return an empty container (or any other widget) to silently handle errors
        return SizedBox(width: width, height: height);
      },
    );
  }
}
