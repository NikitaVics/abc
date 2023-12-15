import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/booking_court.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';

class FilterCourtScreen extends StatefulWidget {
  final DateTime result;
  const FilterCourtScreen({super.key, required this.result});

  @override
  FilterCourtScreenState createState() => FilterCourtScreenState();
}

class FilterCourtScreenState extends State<FilterCourtScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------

  bool juniorColor = false, seniorColor = false;

  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();

    isFirstButtonSelected = true;
    result = widget.result;
    _fetchBookingResponse();
  }

  void _fetchBookingResponse() async {
    await context
        .read<BookingResponseProvider>()
        .fetchBookingResponse(result!);
  }

  final List<String> selectedCourts = [];

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
                : Color(0xffFCFCFC),
            primary: true,
            appBar: AppBar(
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 5),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 25,
                                color: Colors.black,
                              )),
                          SizedBox(
                            width: 110,
                          ),
                          Center(
                            child: Text(
                              "Filters",
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
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextInput
                  : const Color(0xffFCFCFC),
              elevation: 0.0,
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
          : const Color(0xffFCFCFC),
      child: Column(
        children: [
          Expanded(child: Center(child: _buildRightSide())),
          _buildSignInButton()
        ],
      ),
    );
  }

  Widget _buildRightSide() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : const Color(0xffFCFCFC),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              //  flex: 1,
              child: _buildBookingSlot()),
        ],
      ),
    );
  }

  Widget _buildBookingSlot() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 22,
       
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
                bool isSelected = selectedCourts.contains(court.courtName);
                return Column(
                  children: [
                    Container(
                      height: 56,
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                              bottom:
                                  BorderSide(color: AppColors.appbarBoarder))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  court.courtName,
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
                              ),
                              Checkbox(
                                side: BorderSide(
                                  color: AppColors.disableNavIconColor,
                                  width: 2.0
                                ),
                                activeColor: AppColors.dotColor,
                                value: isSelected,
                                onChanged: (value) {
                                  // Handle court selection/deselection
                                  if (value != null) {
                                    setState(() {
                                      if (value) {
                                        selectedCourts.add(court.courtName);
                                      } else {
                                        selectedCourts.remove(court.courtName);
                                      }
                                      print('Selected Courts: $selectedCourts');
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
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
          padding: EdgeInsets.symmetric(vertical: 24,horizontal: 24),
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
  description:  Text("Please select your prefer court..",
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
  icon:Icons.warning,
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
                         Provider.of<BookingResponseProvider>(context, listen: false).resetState();
                         Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingCourtScreen(result: widget.result,selectedCourts: selectedCourts),
    ),
  );
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
