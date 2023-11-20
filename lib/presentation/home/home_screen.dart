import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/courtshowprovider.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/tennismodel/teniscourt/court.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/home_appbar.dart';
import 'package:intl/intl.dart';

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
  bool juniorColor = false, seniorColor = false;
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
        child: Consumer<CourtShowProvider>(
          builder: (context, courtShowProvider, child) {
           
            if (courtShowProvider.courtList == null) {
              // If not loaded, fetch the data
              courtShowProvider.fetchCourts();
              // You can show a loading indicator here if needed
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
             
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildLoginText(),
                  _buildSignInButton(),
                  _buildSlotshowText(),
                  _buildShowCourt(
                      courtShowProvider.courtList!), // Pass the court list
                  _buildrecentBookText(),
                  _buildNoBook(),
                  // _buildForgotPasswordButton(),
                ],
              );
            }
          },
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
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      juniorColor = true;
                      seniorColor = false;
                    });
                  },
                  child: Text(
                    "Junior",
                    style: TextStyle(
                       decoration: juniorColor? TextDecoration.underline:TextDecoration.none,
                decorationThickness: 3.0, 
                      color: juniorColor
                          ? AppColors.dotColor
                          : const Color.fromRGBO(0, 0, 0, 0.50),
                      fontSize: 12,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w700,
                      height: 24 / 12,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 46,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      juniorColor = false;
                      seniorColor = true;
                    });
                  },
                  child:  Text(
                    "Senior",
                    style: TextStyle(
                    decoration: seniorColor? TextDecoration.underline:TextDecoration.none,
                     decorationColor: seniorColor
        ? AppColors.dotColor // Color of the underline
        : Colors.transparent, 
         decorationStyle: seniorColor
        ? TextDecorationStyle.solid
        : TextDecorationStyle.solid, 
                decorationThickness: 3.0, 
                      color: seniorColor
                          ? AppColors.dotColor
                          : const Color.fromRGBO(0, 0, 0, 0.50),
                      fontSize: 12,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w700,
                      height: 24 / 12,
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget _buildShowCourt(CourtList courtList) {
    final List<Court> filteredCourts = (juniorColor || seniorColor)
      ? (juniorColor
          ? courtList.result.where((court) => court.ageGroup == 'Junior').toList()
          : courtList.result.where((court) => court.ageGroup == 'Senior').toList())
      : List.from(courtList.result);
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:filteredCourts.length,
        itemBuilder: (context, index) {
          
          Court court = filteredCourts[index];
          // Format start and end times
          String startTime = DateFormat('h:mm a').format(
            DateFormat('HH:mm:ss').parse(court.startTime),
          );
          String endTime = DateFormat('h:mm a').format(
            DateFormat('HH:mm:ss').parse(court.endTime),
          );
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 145,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                        bottom: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        height: 85,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            court
                                .courtImageURL, // Use the image URL from the Court model
                            // You can also use AssetImage if the image is in the assets folder
                            // e.g., Image.asset("assets/images/court.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 22),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  court.courtName,
                                  style: TextStyle(
                                    color: AppColors.allHeadColor,
                                    fontSize: 16,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w500,
                                    height: 24 / 16,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${startTime} - ${endTime}",
                                  style: TextStyle(
                                    color: AppColors.hintColor,
                                    fontSize: 12,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w400,
                                    height: 16 / 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                "assets/images/Right.png",
                                height: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Image.asset(
                "assets/images/Nobooking.png",
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //TextSpan
                SizedBox(
                  width: 147,
                  child: RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "No Recent Bookings  ",
                          style: TextStyle(
                            color: AppColors.subheadColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 20 / 12,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Complete your profile ', // The first half of the sentence
                          style: TextStyle(
                            color: AppColors.disableButtonTextColor,
                            fontSize: 12,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 20 / 12,
                          ),
                        ),
                        TextSpan(
                          text:
                              'to start booking', // The second half of the sentence
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
