import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/filter/filter_court_screen.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/court_info_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/teamselect_screen.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/constants/onhover.dart';
import 'package:tennis_court_booking_app/constants/shimmer.dart';
import 'package:tennis_court_booking_app/model/bookingCourt/booking_response.dart';
import 'package:tennis_court_booking_app/model/courtInfo/court_info.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

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
  final CarouselController _controller = CarouselController();
  int current = 0;

  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  int id = 0;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();
    _fetchCourtInfoResponse();
    isFirstButtonSelected = true;
    result = widget.result;
    if (widget.selectedCourts != null) {
      _fetchBookingResponsewithFilter();
    } else {
      _fetchBookingResponse();
    }
  }

  Future<void> _fetchCourtInfoResponse() async {
    await context.read<CourtInfoProvider>().fetchCourtInfo(id);
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

  final GlobalKey _dotsRowKey = GlobalKey();
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
  bool showInfoSheet = false;
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
                                            const BottomNavBar(initial: 0)));
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
              child: isLoad
                  ? Center(
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
                          SizedBox(height: 5,),
                          AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText(
                                'Loading...',
                                textStyle: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
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
                    )
                  : _buildBookingSlot()),
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      id = court.courtId;
                                      print(id);
                                    });
                                    print("hi");

                                    showAnimatedDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return FutureBuilder<void>(
                                          future: _fetchCourtInfoResponse(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return buidSheet();
                                            } else {
                                              // You can return a loading indicator or null while waiting for the future
                                              return CircularProgressIndicator();
                                            }
                                          },
                                        );
                                      },
                                      animationType: DialogTransitionType
                                          .slideFromBottomFade,
                                      curve: Curves.fastOutSlowIn,
                                      duration: const Duration(seconds: 1),
                                    );
                                  },
                                  child: Row(
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
                                            color:
                                                Theme.of(context).brightness ==
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
                                  ),
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
            return AnimatedTextKit(
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
            );
          }
        },
      ),
    );
  }

/*DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
              color: Colors.pink,
              child: ListView(
                controller: controller,
                children: [Text("Hi"), Text("Bye")],
              ),
            ));*/
  Widget buidSheet() {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 48; // 24 padding on each side
    double containerHeight = MediaQuery.of(context).size.height / 1.5;

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      insetPadding: const EdgeInsets.only(left: 0, right: 0),
      child: Consumer<CourtInfoProvider>(
        builder: (context, provider, child) {
          final courtInfo = provider.courtinfo;
          print('Booking Response: $courtInfo');
          int _currentPage = 0;

          if (courtInfo != null && courtInfo.result != null) {
            final courtData = courtInfo.result;
            print(courtData!.courtId);
            String startTime = DateFormat('h a').format(
              DateFormat('HH:mm:ss').parse(courtData.startTime),
            );
            String endTime = DateFormat('h a').format(
              DateFormat('HH:mm:ss').parse(courtData.endTime),
            );

            // Use courtinfo.result.imageurl for CarouselSlider items
            List<String> imageUrls = courtData.courtImageURLs;

            // Instantiate CarouselController

            return Container(
              width: containerWidth,
              height: containerHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 200,
                          child: MyHomePage(
                            width: containerWidth,
                            height: 231,
                            imageUrls: imageUrls,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              courtData.courtName,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.booklight
                                    : AppColors.allHeadColor,
                                fontSize: 20,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w700,
                                height: 32 / 16,
                              ),
                            ),
                            Text(
                              "${startTime} - ${endTime}",
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.darkSubHead
                                    : AppColors.confirmValid,
                                fontSize: 12,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w400,
                                height: 16 / 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 4),
                        child: Text(
                          "Lorem ipsum dolor sit amet consectetur. Sed mauris arcu arcu placerat varius facilisis nibh volutpat. Leo egestas massa cras diam venenatis tincidunt. Diam fringilla lorem.",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkSubHead
                                    : AppColors.subheadColor,
                            fontSize: 14,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 24 / 14,
                          ),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 24, right: 24, top: 19.2),
                        child: Divider(
                          color: AppColors.appbarBoarder,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 24, right: 24, top: 13.5),
                        child: Text(
                          "Available facilities",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkSubHead
                                    : AppColors.subheadColor,
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w500,
                            height: 24 / 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24, top: 20),
                        child: SizedBox(
                          height: 54,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: courtData.facilities.length,
                            itemBuilder: (context, index) {
                              Facility facility = courtData.facilities[index];
                              return Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/parking.png",
                                        height: 24,
                                        width: 24,
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        facility.facilityName,
                                        style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.darkSubHead
                                              : AppColors.allHeadColor,
                                          fontSize: 12,
                                          fontFamily: FontFamily.satoshi,
                                          fontWeight: FontWeight.w400,
                                          height: 16 / 12,
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return AnimatedTextKit(
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
            );
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

class SilentErrorImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const SilentErrorImage(
      {super.key,
      required this.imageUrl,
      required this.width,
      required this.height});

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

class MyHomePage extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final double width;

  MyHomePage(
      {required this.imageUrls, required this.height, required this.width});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;
  bool _isCarouselPaused = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      child: Stack(
        children: [
          CarouselSlider(
            items: widget.imageUrls.map((imageUrl) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isCarouselPaused = !_isCarouselPaused;
                  });
                },
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: !_isCarouselPaused,
              enlargeCenterPage: true,
              pauseAutoPlayOnTouch: true,
              //  aspectRatio: screenWidth / screenHeight,
              viewportFraction: 1.0, // Take the full screen width
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 28.0, // Adjust the position as needed
            left: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCarouselPaused = !_isCarouselPaused;
                });
              },
              child: DotsIndicator(
                mainAxisSize: MainAxisSize.min,
                dotsCount: widget.imageUrls.length,
                position: _currentPage,
                decorator: DotsDecorator(
                  size: ui.Size.square(8.0),
                  activeSize: ui.Size(15.75, 8.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: AppColors.nondotcolor,
                  activeColor: AppColors.dotColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
