import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/model/bookingCourt/booking_response.dart';
import 'package:tennis_court_booking_app/profile/profile_screen.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';

class BookingCourtScreen extends StatefulWidget {
  final DateTime result;
  const BookingCourtScreen({super.key, required this.result});

  @override
  BookingCourtScreenState createState() => BookingCourtScreenState();
}

class BookingCourtScreenState extends State<BookingCourtScreen> {
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
    result = widget.result;
    _fetchBookingResponse();
  }

  void _fetchBookingResponse() async {
    await context
        .read<BookingResponseProvider>()
        .fetchBookingResponse(result!.toUtc().toIso8601String());
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
        child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkThemeback
              : AppColors.lightThemeback,
          primary: true,
          appBar: AppBar(
            toolbarHeight: 72,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
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
                        width: 80,
                      ),
                      Text(
                        "New Booking",
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
                    ],
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
      child: _buildRightSide(),
    );
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
            _buildDatePick(),
            Expanded(
                //  flex: 1,
                child: _buildBookingSlot()),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePick() {
    return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          height: 80,
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
    var isHover = false;

    return Padding(
      padding: const EdgeInsets.only(
        top: 22,
        bottom: 20,
      ),
      child: Consumer<BookingResponseProvider>(
        builder: (context, provider, child) {
          final bookingResponse = provider.bookingResponse;

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
                        boxShadow: [
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(
                                      width: 17,
                                      height: 17,
                                      child: Icon(
                                        Icons.info_outline,
                                        color: AppColors.bookingInvalid,
                                        size: 14,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "INFO",
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
                              spacing: 9.56,
                              children: court.availableSlots
                                  .map(
                                    (slot) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                           setState(() {
                                              isHover = true;
                                            });
                                            
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isHover?AppColors.disableButtonTextColor:Colors.transparent,
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
                                        ),
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

  List<Widget> _buildCourtNames(List<CourtSlot> courtsWithSlots) {
    return courtsWithSlots
        .map((courtSlot) => Text(courtSlot.courtName))
        .toList();
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                          " 25",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
        if (index < itemCount - 1)
          const Divider(
            color: AppColors.appbarBoarder,
            thickness: 1,
          ),
      ],
    );
  }

  Widget _buildProfilePerformance(int index, int itemCount) {
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                          " 25",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
