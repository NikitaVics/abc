// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/confirm_booking_provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/constants/shimmer.dart';
import 'package:tennis_court_booking_app/model/upComingBooking/upcoming_booking_model.dart';
import 'package:tennis_court_booking_app/mybookings/bookingDetails/booking_details.dart';
import 'package:tennis_court_booking_app/mybookings/provider/previous_booking_provider.dart';
import 'package:tennis_court_booking_app/mybookings/provider/upComing_provider.dart';
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
  bool isLoad = false;
  String name = "";
  String? tokens;
  Future<void> profile() async {
    final upComingProvider =
        Provider.of<UpcomingBookProvider>(context, listen: false);
    final previousBookingProvider =
        Provider.of<PreviousBookProvider>(context, listen: false);
    setState(() {
      isLoad = true;
    });
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    upComingProvider.fetchupComingData(token);
    previousBookingProvider.fetchupComingData(token);
    print(name);
    setState(() {
      isLoad = false;
    });
  }

  final List<String> team = [];
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
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
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextInput
                : Colors.white,
            elevation: 0,
          ),
          body: _buildBody(),
        ),
      );
    });
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkThemeback
            : AppColors.homeBack,
        child: _buildRightSide());
  }

  Widget _buildRightSide() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
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
                ? _buildUpcomingBookings()
                : _buildPreviousBookings(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return Expanded(
      child: Consumer<UpcomingBookProvider>(
        builder: (context, provider, child) {
          final bookingResponse = provider.upComingBookModel;
          if (bookingResponse != null) {
            if (bookingResponse.result.isNotEmpty) {
              List<Booking> bookings = bookingResponse.result;

              print(bookings.length);
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<BookResultShowProvider>().clearStateList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsScreen(
                              id: bookings[index].bookingId),
                        ),
                      );
                    },
                    child: _buildupComingbooking(
                        index, bookings.length, bookings[index]),
                  );
                },
              );
            } else {
              return Center(
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
                    const SizedBox(
                      height: 28,
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(
                          'Sorry no bookings to show!...',
                          textStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.subheadColor,
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
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
                          color: Theme.of(context).brightness == Brightness.dark
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
            );
          }
        },
      ),
    );
  }

  Widget _buildPreviousBookings() {
    return Expanded(
      child: Consumer<PreviousBookProvider>(
        builder: (context, provider, child) {
          final bookingResponse = provider.upComingBookModel;

          if (bookingResponse != null && bookingResponse.result.isNotEmpty) {
            List<Booking> bookings = bookingResponse.result;

            print(bookings.length);
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.read<BookResultShowProvider>().clearStateList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingDetailsScreen(id: bookings[index].bookingId),
                      ),
                    );
                  },
                  child: _buildupComingbooking(
                      index, bookings.length, bookings[index]),
                );
              },
            );
          } else {
            return Center(
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
                  const SizedBox(
                    height: 28,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        'Sorry no bookings to show!...',
                        textStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.headingTextColor
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                        ),
                      ),
                    ],
                    repeatForever: true,
                    isRepeatingAnimation: true,
                  ),
                ],
              ),
            );
          }
        },
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
        padding: const EdgeInsets.only(top: 22, bottom: 20, left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.58,
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
                        : Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.homeBack,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: isFirstButtonSelected
                                ? Colors.transparent
                                : Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkAppBarboarder
          : AppColors.appbarBoarder,)),
                  ),
                  child: Text(
                    'Up comming Booking',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isFirstButtonSelected
                          ? Colors.white
                          : Theme.of(context).brightness == Brightness.dark
          ? AppColors.hintColor
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
              flex: 2,
              child: SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.39,
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
                        :  Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.homeBack,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: isSecondButtonSelected
                                ? Colors.transparent
                                : Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkAppBarboarder
          : AppColors.appbarBoarder,)),
                  ),
                  child: Text('Previous Booking',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSecondButtonSelected
                            ? Colors.white
                            : Theme.of(context).brightness == Brightness.dark
          ? AppColors.hintColor
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

  Widget _buildupComingbooking(int index, int itemCount, Booking? booking) {
    DateTime date = DateTime.parse(booking?.bookingDate.toString() ?? "");

    String formattedDate = DateFormat('MMM d').format(date);
    String dayOfWeek = DateFormat('E').format(date);
    String timeString = booking?.slot ?? "";
    String formattedDates =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    List<String> splitString = timeString.split(' ');
    String timePart = splitString[0];
    String formattedTime = convertTo24HourFormat(timePart, splitString[1]);
    print(formattedTime);
    DateTime dateTime = DateTime.parse('$formattedDates $formattedTime:00');

    // Add 1 hour
    dateTime = dateTime.add(const Duration(hours: 1));

    // Format the result
    int formattedHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    String results =
        "$formattedHour:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'am' : 'pm'}";

    DateTime dateTiming = DateFormat("MMM d").parse(formattedDate);
    String month = DateFormat("MMM").format(dateTiming);

    // Format day (23)
    String day = DateFormat("d").format(dateTiming);

    return Column(
      children: [
        Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          child: Stack(
            //fit: StackFit.expand,
            children: [
              Theme.of(context).brightness ==
                                      Brightness.dark?
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  "assets/images/DarkShape.png",
                ),
              ): ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  "assets/images/Shape.png",
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
                            borderRadius: BorderRadius.circular(110.0),
                            child: SilentErrorImage(
                              width: 25.44,
                              height: 25.44,
                              imageUrl: booking?.userImage ??
                                  'assets/images/ProfileImage.png',
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            booking?.userName ?? "",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkTextInput
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkTextInput
                                  : Colors.white,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 24 / 14,
                            ),
                          ),
                          Text(
                            " ${booking?.bookingId ?? ""}",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkTextInput
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
                            ? AppColors.darkTextInput
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
                      height: 250,
                      child: Stack(
                        children: [
                          Positioned(
                              left: 0,
                              top: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(110.0),
                                child: SilentErrorImage(
                                  width: 25.44,
                                  height: 25.44,
                                  imageUrl: booking?.userImage ??
                                      'assets/images/ProfileImage.png',
                                ),
                              )),
                          ...List.generate(
                            booking?.teamMembers.length ??
                                0, // Ensure the list has three items
                            (index) {
                              TeamMember teamMember =
                                  booking!.teamMembers[index];
                              double leftPad = (20 * (index + 1)).toDouble();
                              return Positioned(
                                left: leftPad,
                                top: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(150.0),
                                  child: SilentErrorImage(
                                    width: 25.44,
                                    height: 25.44,
                                    imageUrl: teamMember.imageUrl,
                                  ),
                                ),
                              );
                            },
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
                          "${month}".toUpperCase(),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.allHeadColor,
                            fontSize: 24,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w700,
                            height: 32 / 24,
                          ),
                        ),
                        Text(
                          " ${day}",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.elevatedColor
                                    : AppColors.elevatedColor,
                            fontSize: 24,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w700,
                            height: 32 / 24,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "$timePart - $results",
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
              )
            ],
          ),
        ),
        if (index < itemCount - 1)
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
