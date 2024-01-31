import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/bookingprocess/booking_court.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/complete_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/confirm_booking_provider.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:intl/intl.dart';

class FinalBookingScreen extends StatefulWidget {
  final int id;
  const FinalBookingScreen({super.key, required this.id});

  @override
  FinalBookingScreenState createState() => FinalBookingScreenState();
}

class FinalBookingScreenState extends State<FinalBookingScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------

  //SignInProvider? provider;
  String? tokens;
  @override
  void initState() {
    super.initState();

    _fetchBookingResponse();
  }

  void _fetchBookingResponse() async {
    tokens = await SharePref.fetchAuthToken();
    await context
        .read<BookResultShowProvider>()
        .fetchBookResult(tokens!, widget.id);
  }

  final List<String> selectedCourts = [];

  bool isFirstButtonSelected = false;
  bool isSecondButtonSelected = false;
  bool isFormDone = false;
  String name = "";

  Future _onWilPop() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return await _onWilPop();
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            primary: true,
            body: _buildBody(),
          ),
        ),
      );
    });
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4ECB71), Color(0xFF259445)],
        ),
      ),
      child: Column(
        children: [
          Expanded(child: _buildRightSide()),
          _buildSignInButton(),
        ],
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
            _buildSuccessfulText(),
            Center(child: _buildBookingSlot()),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessfulText() {
    return Padding(
      padding: const EdgeInsets.only(top: 43),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Successfully",
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.headingTextColor
                      : Colors.white,
                  fontSize: 32,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w700,
                  height: 40 / 32,
                ),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavBar(initial: 0),
                      ),
                    );
                    context.read<BookResultShowProvider>().clearStateList();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.white,
                  )),
            ],
          ),
          Text(
            "Booked!",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSubHead
                  : Colors.white,
              fontSize: 32,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w700,
              height: 40 / 32,
            ),
          ),
        ],
      ),
    );
  }

  String convertTo24HourFormat(String time, String amPm) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // If the time is PM and not 12, add 12 to convert to 24-hour format
    if (amPm.toLowerCase() == 'pm' && hour != 12) {
      hour += 12;
    }

    // If the time is 12 AM, convert to 00
    if (amPm.toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }

    // Format the result
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int? bookId;
  Widget _buildBookingSlot() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
      ),
      child: Consumer<BookResultShowProvider>(
        builder: (context, provider, child) {
          final bookingResponse = provider.bookedResult;

          if (bookingResponse != null) {
            final courtData = bookingResponse.result;
            DateTime date = DateTime.parse(courtData.bookingDate.toString());

            String formattedDate = DateFormat('MMM d').format(date);
            String dayOfWeek = DateFormat('E').format(date);
            String timeString = courtData.slot;
            String formattedDates =
                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            List<String> splitString = timeString.split(' ');
            String timePart = splitString[0];
            String formattedTime =
                convertTo24HourFormat(timePart, splitString[1]);
            print(formattedTime);
            DateTime dateTime =
                DateTime.parse('$formattedDates $formattedTime:00');

            // Add 1 hour
            dateTime = dateTime.add(const Duration(hours: 1));

            // Format the result
            int formattedHour =
                dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
            String results =
                "$formattedHour:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'am' : 'pm'}";
            print(courtData);

            List teamMember = courtData.teamMembers
                .map((teamMembers) => teamMembers.name)
                .toList();
            List teamMemberUrl = courtData.teamMembers
                .map((teamMembers) => teamMembers.imageUrl)
                .toList();
            bookId = courtData.bookingId;
            return Stack(
              children: [
                HalfCutContainer(
                  innerContainer: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 19, top: 19),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  courtData.tennisCourt.name,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.headingTextColor
                                        : Colors.black,
                                    fontSize: 18,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w700,
                                    height: 24 / 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Booking ID",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.headingTextColor
                                            : Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w500,
                                        height: 24 / 14,
                                      ),
                                    ),
                                    Text(
                                      " - ${courtData.bookingId}",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.headingTextColor
                                            : Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w400,
                                        height: 24 / 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Date",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.headingTextColor
                                            : Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w500,
                                        height: 24 / 14,
                                      ),
                                    ),
                                    Text(
                                      " - $formattedDate, $dayOfWeek",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.headingTextColor
                                            : Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w400,
                                        height: 24 / 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Time",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.headingTextColor
                                            : Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w500,
                                        height: 24 / 14,
                                      ),
                                    ),
                                    Text(
                                      " - $timePart - $results",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.headingTextColor
                                            : Colors.black,
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
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 19, top: 19, left: 25),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4)),
                                height: 92,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    courtData.tennisCourt.courtImages[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 19, right: 19),
                        child: Container(
                          height: 145,
                          width: double.infinity,
                          padding: const EdgeInsets.all(17.63),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.58),
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 0.1),
                                width: 0.88),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Team',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.86,
                                      fontFamily: FontFamily.satoshi,
                                      fontWeight: FontWeight.w700,
                                      height: 21.15 / 15.86,
                                    ),
                                  ),
                                  SizedBox(width: 167.45),
                                  Text(
                                    'Edit team',
                                    style: TextStyle(
                                      color: AppColors.dotColor,
                                      fontSize: 12.34,
                                      fontFamily: FontFamily.satoshi,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      height: 21.15 / 12.34,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18.51),

                              // Use ListView.builder to dynamically generate team members

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 14.1,
                                            backgroundImage: NetworkImage(
                                                courtData.userImage),
                                          ),
                                          SizedBox(width: 10.58),
                                          Text(
                                            courtData.userName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.34,
                                              fontFamily: FontFamily.satoshi,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(height: 2.64),
                                          Image.asset(
                                            "assets/images/ticket.png",
                                            height: 9,
                                          ),
                                          SizedBox(width: 2.64),
                                        ],
                                      ),
                                      // Display one team member information
                                      if (teamMember.isNotEmpty)
                                        _buildTeamMemberRow(
                                            teamMember[0], teamMemberUrl[0]),
                                    ],
                                  ),
                                  const SizedBox(height: 10.58),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Display team member information
                                      for (int i = 1;
                                          i < teamMember.length;
                                          i++)
                                        _buildTeamMemberRow(
                                            teamMember[i], teamMemberUrl[i]),
                                    ],
                                  ),
                                  // Add any additional UI elements for each team member
                                ],
                              ),
                              // ... (additional UI elements)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 17),
                        child:
                            const MySeparator(color: AppColors.appbarBoarder),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 35, left: 65, right: 65),
                        child: Container(
                          height: 190,
                          child: QrImageView(
                            data: courtData.bookingId.toString(),
                            version: 1,
                            size: 190,
                            gapless: false,
                            errorStateBuilder: (cxt, err) {
                              return Container(
                                child: Center(
                                  child: Text(
                                    'Uh oh! Something went wrong...',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/success.gif",
                    // fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 215,
                      child: Image.asset(
                        "assets/images/loadinggif.gif",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(
                          'Loading...',
                          textStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.subheadColor,
                            fontSize: 20,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w500,
                            height: 34 / 20,
                          ),
                        ),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTeamMemberRow(String memberName, String memberImageUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 14.1,
          backgroundImage: NetworkImage(
            memberImageUrl.isNotEmpty
                ? memberImageUrl
                : "assets/images/Profile1.png",
          ),
        ),
        SizedBox(width: 10.58),
        Text(
          memberName.isNotEmpty ? memberName : "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13.34,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 2.64),
        // Add any additional UI elements for each team member
      ],
    );
  }

  Widget _buildSignInButton() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: FocusScope(
              // Manage keyboard focus
              child: CustomElevatedButton(
            height: 60,
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 70
                : double.infinity,
            isLoading: false,
            text: "Cancel Booking",
            onPressed: () async {
              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavBar(initial: 0)));
              await Api.deleteBooking(
                tokens!,bookId!,
              );
            },
            buttonColor: Colors.white,
            textColor: AppColors.allHeadColor,
          ))),
    );
  }

  // General Methods:-----------------------------------------------------------

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree

    super.dispose();
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class HalfCutContainer extends StatelessWidget {
  final Widget innerContainer;

  HalfCutContainer({required this.innerContainer});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Container(
          height: 560,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 4),
                blurRadius: 107,
                spreadRadius: -14,
                color: Color.fromRGBO(0, 0, 0, 0.08),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              innerContainer,
            ],
          ),
        ),
        Positioned(
          left: -25, // Adjust the left position as needed
          top: 560 / 2,
          child: Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColors.roundColorBooking),
          ),
        ),
        // Positioned circle on the right side
        Positioned(
          right: -25, // Adjust the right position as needed
          top: 560 / 2,
          child: Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColors.roundColorBooking),
          ),
        ),
      ]),
    );
  }
}
