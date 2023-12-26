import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/booking_court.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/complete_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/confirm_booking_provider.dart';
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
            _buildBookingSlot(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessfulText() {
    return Padding(
      padding: const EdgeInsets.only(top: 23),
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
                  onPressed: () {
                    Navigator.pop(context, null);
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
    String formattedTime = convertTo24HourFormat(timePart, splitString[1]);
    print(formattedTime);
    DateTime dateTime = DateTime.parse('$formattedDates $formattedTime:00');

    // Add 1 hour
    dateTime = dateTime.add(Duration(hours: 1));

    // Format the result
    int formattedHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    String results =
        "$formattedHour:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'am' : 'pm'}";
            print(courtData);
            List<String> courtImageUrls = courtData.tennisCourt.courtImages
    .map((courtImage) => courtImage.imageUrl)
    .toList();

// Now you can use courtImageUrls as needed, for example, print them
print(courtImageUrls);
            return HalfCutContainer(
              innerContainer: Column(

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 19,top: 19),
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
                                  fontSize:18,
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
                       ],),
                     ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 19,
                          right: 19
                        ),
                        child: Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)),
                            height: 92,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                               courtImageUrls[0] , // Use the image URL from the Court model
                                // You can also use AssetImage if the image is in the assets folder
                                // e.g., Image.asset("assets/images/court.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                 ],
              ),
            );

            /*Container(
              child: Column(
                children: [Text(courtData.coachName), Text(courtData.userName)],
              ),
            );*/
          } else {
            return const Text('No court data available.');
          }
        },
      ),
    );
  }

  Widget _buildSignInButton() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: FocusScope(
              // Manage keyboard focus
              child: selectedCourts.isEmpty
                  ? CustomElevatedButton(
                      height: 60,
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 70
                          : double.infinity,
                      isLoading: false,
                      text: "Apply Filter",
                      onPressed: () async {
                        MotionToast(
                          primaryColor: AppColors.warningToast,
                          description: Text(
                            "Please select your prefer court..",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.headingTextColor
                                  : AppColors.allHeadColor,
                              fontSize: 16,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 24 / 16,
                            ),
                          ),
                          icon: Icons.warning,
                          animationCurve: Curves.bounceInOut,
                        ).show(context);
                      },
                      buttonColor: AppColors.disableButtonColor,
                      textColor: AppColors.disableButtonTextColor,
                    )
                  : CustomElevatedButton(
                      height: 60,
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 70
                          : double.infinity,
                      isLoading: false,
                      text: "Apply Filter",
                      onPressed: () async {
                        Provider.of<BookingResponseProvider>(context,
                                listen: false)
                            .resetState();
                      },
                      buttonColor: AppColors.elevatedColor,
                      textColor: Colors.white,
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

class HalfCutContainer extends StatelessWidget {
  final Widget innerContainer;

  HalfCutContainer({required this.innerContainer});
  @override
  Widget build(BuildContext context) {
   
    return Center(
      child: Container(
        height:534,
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                innerContainer,
              ],
            ),
            // Positioned circle on the left side
            Positioned(
              left: -12, // Adjust the left position as needed
              top: 534/2,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4ECB71), Color(0xFF259445)],
                  ),
                ),
              ),
            ),
            // Positioned circle on the right side
            Positioned(
              right: -12, // Adjust the right position as needed
              top:534/2,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4ECB71), Color(0xFF259445)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
