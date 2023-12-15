import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/filter/filter_court_screen.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/teamselect_screen.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/constants/onhover.dart';
import 'package:tennis_court_booking_app/constants/shimmer.dart';
import 'package:tennis_court_booking_app/model/bookingCourt/booking_response.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';

class BookingCourtScreen extends StatefulWidget {
  final DateTime result;
  final List<String>? selectedCourts;
  const BookingCourtScreen(
      {super.key, required this.result, this.selectedCourts});

  @override
  BookingCourtScreenState createState() => BookingCourtScreenState();
}

class BookingCourtScreenState extends State<BookingCourtScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------

  bool juniorColor = false, seniorColor = false;
  bool isLoad = false;
  bool isLoading = false;

  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();

    isFirstButtonSelected = true;
    result = widget.result;
    if (widget.selectedCourts != null) {
      _fetchBookingResponsewithFilter();
    } else {
      _fetchBookingResponse();
    }
  }

  void _fetchBookingResponse() async {
    setState(() {
      isLoad = true;
    });
    await context.read<BookingResponseProvider>().fetchBookingResponse(result!);
    setState(() {
      isLoad = false;
    });
  }

  void _fetchBookingResponsewithFilter() async {
    setState(() {
     isLoad = true;
    });
    await context
        .read<BookingResponseProvider>()
        .fetchBookingResponse(result!, widget.selectedCourts);
        setState(() {
       isLoad = false;
    });
  }

  bool isFirstButtonSelected = false;
  bool isSecondButtonSelected = false;
  bool isFormDone = false;
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Provider.of<BookingResponseProvider>(context,
                                        listen: false)
                                    .resetState();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavBar()));
                              },
                              icon: Image.asset(
                                "assets/images/leftIcon.png",
                                //width: 18,
                                height: 26,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "New Booking",
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
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                              icon: Image.asset(
                                "assets/images/Search.png",
                                //width: 18,
                                height: 18,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Provider.of<BookingResponseProvider>(context,
                                        listen: false)
                                    .resetState();
                                Navigator.of(context)
                                    .push(_createRoute(widget.result));
                              },
                              icon: Image.asset(
                                "assets/images/Filter.png",
                                //width: 18,
                                height: 15,
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
          : AppColors.homeBack,
      child: _buildRightSide(),
    );
  }

  Widget _buildRightSide() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.homeBack,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDatePick(),
          Expanded(
              //  flex: 1,
              child: isLoad?ShimmerEffect(): _buildBookingSlot()),
        ],
      ),
    );
  }

  Widget _buildDatePick() {
    print(result);
    return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          height: 87,
          child: DatePicker(
            DateTime.now(),
            initialSelectedDate: result,
            selectionColor: AppColors.dotColor,
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              setState(() {
                result = date;
              });
              _fetchBookingResponse();
            },
          ),
        ));
  }

  Widget _buildBookingSlot() {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 20, left: 24, right: 24),
      child: Consumer<BookingResponseProvider>(
        builder: (context, provider, child) {
          final bookingResponse = provider.bookingResponse;
          print('Booking Response: $bookingResponse');

          if (bookingResponse != null &&
              bookingResponse.result.courtsWithSlots.isNotEmpty) {
            final courtData = bookingResponse.result.courtsWithSlots;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: courtData.length,
              itemBuilder: (context, index) {
                final court = courtData[index];

                return Column(
                  children: [
                    Container(
                      //padding: EdgeInsets.fromLTRB(12, 12,12, 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.02),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  court.courtName,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.headingTextColor
                                        : AppColors.subheadColor,
                                    fontSize: 16,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w500,
                                    height: 24 / 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 17,
                                      height: 17,
                                      child: Image.asset(
                                        "assets/images/informationCircle.png",
                                        //width: 18,
                                        height: 17,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        " INFO",
                                        style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.headingTextColor
                                              : AppColors.bookingInvalid,
                                          fontSize: 10.50,
                                          fontFamily: FontFamily.satoshi,
                                          fontWeight: FontWeight.w500,
                                          height: 21 / 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 27),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runSpacing: 0.0,
                              spacing: 9.56,
                              children: court.availableSlots
                                  .map(
                                    (slot) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: InkWell(
                                          onTap: () {
                                            slot.isAvailable
                                                ? Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TeamSelectScreen(
                                                              result: result!,
                                                              time:
                                                                  slot.timeSlot,
                                                              courtName: court
                                                                  .courtName),
                                                    ),
                                                  )
                                                : MotionToast(
                                                    primaryColor:
                                                        AppColors.disableTime,
                                                    description: Text(
                                                      "This timeslot is booked. Please select another one..",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? AppColors
                                                                .headingTextColor
                                                            : AppColors
                                                                .allHeadColor,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            FontFamily.satoshi,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 24 / 16,
                                                      ),
                                                    ),
                                                    icon: Icons.warning,
                                                    animationCurve:
                                                        Curves.bounceInOut,
                                                  ).show(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: slot.isAvailable ==
                                                            true
                                                        ? AppColors.confirmValid
                                                        : AppColors
                                                            .disableTime)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 17.5,
                                                  right: 17.5,
                                                  top: 8.75,
                                                  bottom: 8.75),
                                              child: Text(
                                                slot.timeSlot,
                                                style: TextStyle(
                                                  color: slot.isAvailable ==
                                                          true
                                                      ? AppColors.dateColor
                                                      : AppColors.disableTime,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.roboto,
                                                  fontWeight: FontWeight.w500,
                                                  height: 20 / 14,
                                                ),
                                              ),
                                            ),
                                          )
                                          /*Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      AppColors.dateColor)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 17.5,
                                                right: 17.5,
                                                top: 8.75,
                                                bottom: 8.75),
                                            child: Text(
                                              slot,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? AppColors
                                                        .headingTextColor
                                                    : AppColors.dateColor,
                                                fontSize: 14,
                                                fontFamily: FontFamily.roboto,
                                                fontWeight: FontWeight.w500,
                                                height: 20 / 14,
                                              ),
                                            ),
                                          ),
                                        ),*/
                                          ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            // Add a divider for better separation
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            );
          } else {
            return Text('No court data available.');
          }
        },
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
