import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/bookingprocess/booking_court.dart';
import 'package:tennis_court_booking_app/bookingprocess/editTeam/edit_team.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/complete_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/confirm_booking_provider.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/language/provider/language_change_controller.dart';
import 'package:tennis_court_booking_app/mybookings/my_bookings.dart';
import 'package:tennis_court_booking_app/mybookings/provider/upComing_provider.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int id;
  final bool valid;
  const BookingDetailsScreen(
      {super.key, required this.id, required this.valid});

  @override
  BookingDetailsScreenState createState() => BookingDetailsScreenState();
}

class BookingDetailsScreenState extends State<BookingDetailsScreen> {
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
    _fetchUpcomingData();
  }

  void _fetchBookingResponse() async {
    tokens = await SharePref.fetchAuthToken();
    await context
        .read<BookResultShowProvider>()
        .fetchBookResult(tokens!, widget.id);
  }

  void _fetchUpcomingData() async {
    tokens = await SharePref.fetchAuthToken();
    final upComingProvider =
        Provider.of<UpcomingBookProvider>(context, listen: false);
    upComingProvider.fetchupComingData(tokens!);
  }

  bool isLoading = false;
  final List<String> selectedCourts = [];
  int? bookId;

  bool isFirstButtonSelected = false;
  bool isSecondButtonSelected = false;
  bool isFormDone = false;
  String name = "";

  Future _onWilPop() async {
     Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                       BottomNavBar(initial: 1)
                  ),
                );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = context.watch<LanguageChangeController>();
    return Builder(builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return await _onWilPop();
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkThemeback
                : AppColors.homeBack,
            primary: true,
            appBar: AppBar(
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Container(
                  // height: 100,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkAppBarboarder
                        : AppColors.appbarBoarder,
                    width: 1.0,
                  ))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 5),
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                     BottomNavBar(initial: 1)
                  ),
                );
                              },
                              icon: languageNotifier.appLocale == Locale("ar")
                                  ? Transform.flip(
                                      flipX: true,
                                      child: Image.asset(
                                        "assets/images/leftIcon.png",
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.headingTextColor
                                            : AppColors.profileHead,
                                        //width: 18,
                                        height: 26,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/images/leftIcon.png",
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.headingTextColor
                                          : AppColors.profileHead,
                                      //width: 18,
                                      height: 26,
                                    ),
                            ),
                            const Spacer(),
                            Text(
                              (AppLocalizations.of(context)!.bookingDetails),
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.profileHead,
                                fontSize: 20,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w700,
                                height: 32 / 20,
                              ),
                            ),
                            const Spacer(flex: 2)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkThemeback
                  : AppColors.homeBack,
              elevation: 0,
            ),
            body: _buildBody(),
          ),
        ),
      );
    });
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkThemeback
              : AppColors.homeBack,
        ),
        child: Column(
          children: [
            Expanded(child: _buildRightSide()),
            widget.valid == true ? _buildSignInButton() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: _buildBookingSlot()),
              ],
            ),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: AlertDialog(
                          surfaceTintColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.hintColor
                                  : AppColors.disableButtonColor,
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkTextInput
                                  : AppColors.primaryColor,
                          title: Text(
                            (AppLocalizations.of(context)!.cancelledBooking),
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.headingTextColor
                                  : AppColors.logoutColor,
                              fontSize: 24,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 32 / 24,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.darkEditColor
                                    : AppColors.dotColor,
                              ),
                              SizedBox(height: 16),
                              Text(
                                (AppLocalizations.of(context)!.waitText),
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.profileDarkText
                                      : Color(0xff49454F),
                                  fontSize: 12,
                                  fontFamily: FontFamily.poppins,
                                  fontWeight: FontWeight.w400,
                                  height: 20 / 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
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

  Widget _buildBookingSlot() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
      ),
      child: Consumer<BookResultShowProvider>(
        builder: (context, provider, child) {
          final languageNotifier = context.watch<LanguageChangeController>();
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
            return HalfCutContainer(
              innerContainer: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: languageNotifier.appLocale == Locale("en")
                                ? 19
                                : 0,
                            top: 19,
                            right: languageNotifier.appLocale == Locale("en")
                                ? 0
                                : 19),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courtData.tennisCourt.name,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
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
                                  (AppLocalizations.of(context)!.bookingId),
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.profileDarkText
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
                                        ? AppColors.profileDarkText
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
                                  (AppLocalizations.of(context)!.date),
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.profileDarkText
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
                                        ? AppColors.profileDarkText
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
                                  (AppLocalizations.of(context)!.time),
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.profileDarkText
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
                                        ? AppColors.profileDarkText
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
                    padding: EdgeInsets.only(
                        top: languageNotifier.appLocale == Locale("en")
                            ? 10
                            : 20,
                        left: 19,
                        right: 19),
                    child: Container(
                      height: languageNotifier.appLocale == Locale("en")
                          ? 145
                          : 155,
                      width: double.infinity,
                      padding: const EdgeInsets.all(17.63),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.58),
                        border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromRGBO(255, 255, 255, 0.10)
                                    : const Color.fromRGBO(0, 0, 0, 0.1),
                            width: 0.88),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (AppLocalizations.of(context)!.team),
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15.86,
                                  fontFamily: FontFamily.satoshi,
                                  fontWeight: FontWeight.w700,
                                  height: 21.15 / 15.86,
                                ),
                              ),
                               widget.valid == true ?
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTeamScreen(
                                          result: courtData.bookingDate,
                                          courtName:courtData.tennisCourt.name,
                                          time:courtData.slot,
                                          teamId:courtData.teamId,
                                          bookingId:courtData.bookingId ),
                                    ),
                                  );
                                },
                                child: Text(
                                  (AppLocalizations.of(context)!.editTeam),
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.darkEditColor
                                        : AppColors.dotColor,
                                    decorationColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkEditColor
                                            : AppColors.dotColor,
                                    fontSize: 12.34,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    height: 21.15 / 12.34,
                                  ),
                                ),
                              ):SizedBox(),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 14.1,
                                        backgroundImage:
                                            NetworkImage(courtData.userImage),
                                      ),
                                      SizedBox(width: 10.58),
                                      Text(
                                        courtData.userName,
                                        style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.profileDarkText
                                              : Colors.black,
                                          fontSize: 13.34,
                                          fontFamily: FontFamily.satoshi,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(width: 2.64),
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
                                  for (int i = 1; i < teamMember.length; i++)
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
                    child: MySeparator(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkAppBarboarder
                            : AppColors.appbarBoarder),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: languageNotifier.appLocale == Locale("en")
                            ? 45
                            : 55,
                        left: 65,
                        right: 65),
                    child: Container(
                      height: 190,
                      child: QrImageView(
                        foregroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.headingTextColor
                                : AppColors.allHeadColor,
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
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkEditColor
                                  : AppColors.dotColor),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(
                          (AppLocalizations.of(context)!.loading),
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
        memberImageUrl.isNotEmpty
            ? CircleAvatar(
                radius: 14.1, backgroundImage: NetworkImage(memberImageUrl))
            : CircleAvatar(
                radius: 14.1,
                backgroundImage: Theme.of(context).brightness == Brightness.dark
                    ? AssetImage(
                        "assets/images/darkavat.png",
                      )
                    : AssetImage(
                        "assets/images/userTeam.png",
                      )),
        SizedBox(width: 10.58),
        AutoSizeText(
          memberName.isNotEmpty ? memberName : "",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.profileDarkText
                : Colors.black,
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
            text: (AppLocalizations.of(context)!.cancelledBooking),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  surfaceTintColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.hintColor
                          : AppColors.homeBack,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkThemeback
                          : AppColors.homeBack,
                  title: Text(
                    (AppLocalizations.of(context)!.cancelledBooking),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.headingTextColor
                          : AppColors.logoutColor,
                      fontSize: 24,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w700,
                      height: 32 / 24,
                    ),
                  ),
                  content: isLoading
                      ? Text(
                          "Keep Patience..Caneclling....",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : Color(0xff49454F),
                            fontSize: 12,
                            fontFamily: FontFamily.poppins,
                            fontWeight: FontWeight.w400,
                            height: 20 / 12,
                          ),
                        )
                      : Text(
                          (AppLocalizations.of(context)!.attemtText2),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : Color(0xff49454F),
                            fontSize: 12,
                            fontFamily: FontFamily.poppins,
                            fontWeight: FontWeight.w400,
                            height: 20 / 12,
                          ),
                        ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          (AppLocalizations.of(context)!.cancel),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.hoverColor
                                    : AppColors.subheadColor,
                            fontSize: 14,
                            fontFamily: FontFamily.roboto,
                            fontWeight: FontWeight.w500,
                            height: 20 / 14,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        Navigator.of(ctx).pop();
                        await Api.deleteBooking(
                          tokens!,
                          bookId!,
                        );
                        _fetchUpcomingData();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavBar(initial: 1),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          (AppLocalizations.of(context)!.confirm),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkEditColor
                                    : AppColors.dotColor,
                            fontSize: 14,
                            fontFamily: FontFamily.roboto,
                            fontWeight: FontWeight.w500,
                            height: 20 / 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );

              /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavBar(initial: 0)));
              await Api.deleteBooking(
                tokens!,bookId!,
              );*/
            },
            buttonColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkEditColor
                : AppColors.dotColor,
            textColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.allHeadColor
                : AppColors.headingTextColor,
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
    final languageNotifier = context.watch<LanguageChangeController>();
    return Center(
      child: Stack(children: [
        Container(
          height: (languageNotifier.appLocale == Locale("en") ? 560 : 590),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextInput
                : Colors.white,
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
          top: (languageNotifier.appLocale == Locale("en") ? 560 : 590) / 2,
          child: Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkThemeback
                  : AppColors.homeBack,
            ),
          ),
        ),
        // Positioned circle on the right side
        Positioned(
          right: -25, // Adjust the right position as needed
          top: (languageNotifier.appLocale == Locale("en") ? 560 : 600) / 2,
          child: Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkThemeback
                  : Color(0xffF8F8F8),
            ),
          ),
        ),
      ]),
    );
  }
}
