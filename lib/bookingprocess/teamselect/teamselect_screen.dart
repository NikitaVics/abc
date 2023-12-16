// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/bookingprocess/booking_court.dart';
import 'package:tennis_court_booking_app/bookingprocess/filter/filter_court_screen.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/coach_show_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/friend_show_provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'package:intl/intl.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';

class TeamSelectScreen extends StatefulWidget {
  final DateTime result;
  final String time;
  final String courtName;
  const TeamSelectScreen(
      {super.key,
      required this.result,
      required this.time,
      required this.courtName});

  @override
  TeamSelectScreenState createState() => TeamSelectScreenState();
}

class TeamSelectScreenState extends State<TeamSelectScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------

  bool juniorColor = false, seniorColor = false;

  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  String? coachImage;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();

    isFirstButtonSelected = true;
    result = widget.result;
    _fetchBookingResponse();
    profile();
  }

  Future<void> profile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    profileProvider.fetchProfile(token);
    final friendShow = Provider.of<FreindShowProvider>(context, listen: false);
    friendShow.fetchfriendshow(token);
    final coachShow = Provider.of<CoachShowProvider>(context, listen: false);
    coachShow.fetchfriendshow(widget.result, widget.time);
    print(name);
  }

  void _fetchBookingResponse() async {
    await context.read<BookingResponseProvider>().fetchBookingResponse(result!);
  }

  List<String> selectedImageUrls = [];

  bool isFirstButtonSelected = false;
  bool isSecondButtonSelected = false;
  bool isFormDone = false;
  bool isImageVisible = true;
  bool isImage = true;
  String name = "";
  String? tokens;
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
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkThemeback
                : AppColors.lightThemeback,
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
                    width: 2.0,
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
                                Navigator.pop(context, null);
                              },
                              icon: Image.asset(
                                "assets/images/leftIcon.png",
                                //width: 18,
                                height: 26,
                              ),
                            ),
                            SizedBox(
                              width: 106,
                            ),
                            Text(
                              widget.courtName,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextInput
                  : Colors.white,
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
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : Colors.white,
      child: _buildRightSide(),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            if (provider.profileModel == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final profileData = provider.profileModel!;
              imageUrl = profileData.result.imageUrl;
              name = profileData.result.name ?? "";
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildDatePick(),
                  _buildImage(isImageVisible, isImage),
                  _buildAddTeam(),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.92),
                    child: _buildImageProfile(!isImageVisible),
                  ),
                  _buildCoach(),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.92),
                    child: _buildCoachProfile(!isImage),
                  ),
                  /* Expanded(
                //  flex: 1,
                child: _buildBookingSlot()),*/
                ],
              );
            }
          },
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

  Widget _buildDatePick() {
    DateTime date = DateTime.parse(result.toString());

    String formattedDate = DateFormat('MMM d').format(date); // Dec 13
    String dayOfWeek = DateFormat('E').format(date);
    String formattedDates =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    String timeString = widget.time;
    List<String> splitString = timeString.split(' ');
    String timePart = splitString[0];
    String formattedTime = convertTo24HourFormat(timePart, splitString[1]);
    print(formattedTime);
    DateTime dateTime = DateTime.parse('$formattedDates $formattedTime:00');

    // Add 1 hour
    dateTime = dateTime.add(Duration(hours: 1));

    // Format the result
    int formattedHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    String results =
        "$formattedHour:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'am' : 'pm'}";

    print(formattedTime);

    // Extract the time part

    return Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.homeBack,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 78,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 28, right: 28, top: 15, bottom: 15),
            child: Stack(children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Date - ",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.headingTextColor
                              : AppColors.subheadColor,
                          fontSize: 14,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 14,
                        ),
                      ),
                      Text(
                        "$formattedDate ,",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.headingTextColor
                              : AppColors.subheadColor,
                          fontSize: 14,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w400,
                          height: 24 / 14,
                        ),
                      ),
                      Text(
                        dayOfWeek,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.headingTextColor
                              : AppColors.subheadColor,
                          fontSize: 14,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w400,
                          height: 24 / 14,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Time - ",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.headingTextColor
                              : AppColors.subheadColor,
                          fontSize: 14,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 14,
                        ),
                      ),
                      Text(
                        "$timePart - ",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.headingTextColor
                              : AppColors.subheadColor,
                          fontSize: 14,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w400,
                          height: 24 / 14,
                        ),
                      ),
                      Text(
                        results,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.headingTextColor
                              : AppColors.subheadColor,
                          fontSize: 14,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w400,
                          height: 24 / 14,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingCourtScreen(result: widget.result),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.confirmValid)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 13, right: 13, top: 11, bottom: 11),
                          child: Text(
                            "Change",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.dotColor
                                  : AppColors.dotColor,
                              fontSize: 12,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 16 / 12,
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ]),
          ),
        ));
  }

  Widget _buildImage(bool isVisible, bool isVisi) {
    return Visibility(
      visible: isVisible && isVisi,
      child: Image.asset("assets/images/teamsadd.png"),
    );
  }

  Widget _buildAddTeam() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 31, bottom: 21),
          child: Text(
            "Add team",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.headingTextColor
                  : AppColors.subheadColor,
              fontSize: 16,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        top: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(110.0),
                          child: SilentErrorImage(
                            width: 48.0,
                            height: 48.0,
                            imageUrl: imageUrl!,
                          ),
                        )),
                  ...List.generate(
    3, // Ensure the list has three items
    (index) {
      String imageUrl =
          index < selectedImageUrls.length ? selectedImageUrls[index] : "assets/images/userTeam.png";
      double leftPad = (35 * (index+1)).toDouble();
      return Positioned(
        left: leftPad,
        top: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150.0),
          child: SilentErrorImage(
            height: 48,
            width: 48,
            imageUrl: imageUrl,
          ),
        ),
      );
    },
  ),
                  
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isImageVisible = !isImageVisible;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.dotColor)),
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 26, right: 26, top: 11, bottom: 11),
                    child: SizedBox(
                      height: 24,
                      child: isImageVisible
                          ? Icon(
                              Icons.add,
                              color: AppColors.dotColor,
                            )
                          : Icon(
                              Icons.close,
                              color: AppColors.dotColor,
                            ),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageProfile(bool visibilityShow) {
    return Visibility(
      visible: visibilityShow,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.appbarBoarder)),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.appbarBoarder))),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child:
                        Stack(
  children: List.generate(
    3, // Ensure the list has three items
    (index) {
      String imageUrl =
          index < selectedImageUrls.length ? selectedImageUrls[index] : "assets/images/userTeam.png";
      double leftPad = (35 * index).toDouble();
      return Positioned(
        left: leftPad,
        top: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150.0),
          child: SilentErrorImage(
            height: 48,
            width: 48,
            imageUrl: imageUrl,
          ),
        ),
      );
    },
  ),
),

                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          //isImageVisible = !isImageVisible;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.dateColor)),
                        child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Repeat Team",
                              style: TextStyle(
                                color: AppColors.dateColor,
                                fontSize: 14,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w500,
                                height: 20 / 14,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<FreindShowProvider>(
                builder: (context, provider, child) {
                  final friendResponse = provider.friendShowModel;
                  print('Booking Response: $friendResponse');

                  if (friendResponse != null &&
                      friendResponse.result.isNotEmpty) {
                    final friendData = friendResponse.result;

                    return Container(
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: (friendData.length / 4)
                              .ceil(), // Calculate the number of rows
                          itemBuilder: (context, rowIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                4,
                                (indexInRow) {
                                  final dataIndex = rowIndex * 4 + indexInRow;
                                  if (dataIndex < friendData.length) {
                                    final court = friendData[dataIndex];
                                     final isSelected = selectedImageUrls.contains(court);
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                        if (isSelected) {
                        selectedImageUrls.remove(court);
                      } else {
                        selectedImageUrls.add(court);
                      }
                                        });
                                      },
                                      child: Container(
                                         decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150.0),
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                                        child: ClipRRect(
                                          
                                            borderRadius:
                                                BorderRadius.circular(150.0),
                                            child: SilentErrorImage(
                                                height: 48,
                                                width: 48,
                                                imageUrl: court)),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                        width:
                                            48); // Empty space if no more data
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Text('No court data available.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoach() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 31, bottom: 21),
          child: Text(
            "Add coach",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.headingTextColor
                  : AppColors.subheadColor,
              fontSize: 16,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        top: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(150.0),
                            child: SilentErrorImage(
                                height: 48,
                                width: 48,
                                imageUrl: coachImage ??
                                    "assets/images/userTeam.png"))),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isImage = !isImage;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.dotColor)),
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 26, right: 26, top: 11, bottom: 11),
                    child: SizedBox(
                      height: 24,
                      child: isImage
                          ? Icon(
                              Icons.add,
                              color: AppColors.dotColor,
                            )
                          : Icon(
                              Icons.close,
                              color: AppColors.dotColor,
                            ),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoachProfile(bool visibilityShow) {
    return Visibility(
      visible: visibilityShow,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.appbarBoarder)),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.appbarBoarder))),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(150.0),
                                  child: SilentErrorImage(
                                      height: 48,
                                      width: 48,
                                      imageUrl: coachImage ??
                                          "assets/images/userTeam.png")),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          //isImageVisible = !isImageVisible;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.dateColor)),
                        child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Repeat Coach",
                              style: TextStyle(
                                color: AppColors.dateColor,
                                fontSize: 14,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w500,
                                height: 20 / 14,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<CoachShowProvider>(
                builder: (context, provider, child) {
                  final coachResponse = provider.coachShowModel;
                  print('Booking Response: $coachResponse');

                  if (coachResponse != null &&
                      coachResponse.result.isNotEmpty) {
                    final friendData = coachResponse.result;

                    return Container(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: (friendData.length / 4)
                            .ceil(), // Calculate the number of rows
                        itemBuilder: (context, rowIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                4,
                                (indexInRow) {
                                  final dataIndex = rowIndex * 4 + indexInRow;
                                  if (dataIndex < friendData.length) {
                                    final court = friendData[dataIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          coachImage = court;
                                        });
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(150.0),
                                          child: SilentErrorImage(
                                              height: 48,
                                              width: 48,
                                              imageUrl: court)),
                                    );
                                  } else {
                                    return SizedBox(
                                        width:
                                            48); // Empty space if no more data
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text('No court data available.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
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

Route _createRoute(DateTime result) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => FilterCourtScreen(
      result: result,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
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
        return Image.asset(
          "assets/images/userTeam.png",
          width: width,
          height: height,
        );
      },
    );
  }
}
