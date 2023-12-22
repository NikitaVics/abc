// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/bookingprocess/booking_court.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/courtshowprovider.dart';
import 'package:tennis_court_booking_app/presentation/home/model/checkstatus.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/profile/model/profile_model.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/tennismodel/teniscourt/court.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/funky_overlay.dart';
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

  DateTime? dateTime;
  DateTime? result;
  DateTime? results;
  String? imageUrl;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    profile();
  }

  bool isFormDone = false;
  String name = "";
  String? tokens;
  bool loading = false;
  Future<void> profile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final checkstatusprovider =
        Provider.of<CheckStatusProvider>(context, listen: false);

    setState(() {
      loading = true;
    });

    tokens = await SharePref.fetchAuthToken();
    print("Tokio $tokens");
    profileProvider.fetchProfile(tokens!);
    checkstatusprovider.checkRegistrationStatus(tokens!);
    setState(() {
      loading = false;
    });
  }

  bool? hasErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Consumer2<CheckStatusProvider, ProfileProvider>(
      builder: (context, checkStatusProvider, profileProvider, child) {
        if (checkStatusProvider.checkStatus == null 
            ) {
          profileProvider.fetchProfile(tokens ?? "");
          checkStatusProvider.checkRegistrationStatus(tokens ?? "");

          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          imageUrl = profileProvider.profileModel?.result.imageUrl;
          name = profileProvider.profileModel?.result.name??"";
          hasErrorMessage = checkStatusProvider.checkStatus!.result;
          List<String> nameParts = name.split(' ');

// Extract the first name
          String firstName = nameParts.isNotEmpty ? nameParts.first : '';

          print("Nope $hasErrorMessage");

          return loading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Scaffold(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkThemeback
                          : AppColors.lightThemeback,
                  primary: true,
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextInput
                              : Colors.white,
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: MediaQuery(
                               data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 48,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 24),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(150.0),
                                          child: imageUrl != null &&
                                                  imageUrl!.isNotEmpty
                                              ? SilentErrorImage(
                                                  width: 48.0,
                                                  height: 48.0,
                                                  imageUrl: imageUrl!,
                                                )
                                              : Image.asset(
                                                  "assets/images/userImage.png",
                                                  width: 48.0,
                                                  height: 48.0,
                                                )),
                                    ),
                                  ),
                                  hasErrorMessage!
                                      ? const SizedBox(
                                          width: 20,
                                        )
                                      : const SizedBox(
                                          width: 10,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Hello",
                                          style: TextStyle(
                                            color: Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.headingTextColor
                                                : AppColors.allHeadColor,
                                            fontFamily: FontFamily.satoshi,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 24 / 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          firstName ?? " ",
                                          style: TextStyle(
                                            color: Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.headingTextColor
                                                : AppColors.allHeadColor,
                                            fontFamily: FontFamily.satoshi,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 24 / 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: hasErrorMessage!
                                        ? const SizedBox()
                                        : SizedBox(
                                            height: 34,
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                SharedPreferences pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String? email =
                                                    await SharePref.fetchEmail();
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterForm(email: email!),
                                                  ),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.errorback,
                                                foregroundColor:
                                                    AppColors.errorColor,
                                                side: BorderSide(
                                                    color: AppColors.errorColor),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: const Text(
                                                'Complete profile',
                                                style: TextStyle(
                                                  fontFamily: FontFamily.satoshi,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  height: 24 / 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          showAlertDialog(context);
                                        },
                                        child: Image.asset(
                                          "assets/images/notification1.png",
                                          height: 25,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.headingTextColor
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                );
        }
      },
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return WillPopScope(
      onWillPop: () async {
        print("WillPopScope triggered");
        setState(() {
          result = null;
        });
        return true;
      },
      child: Material(
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
        child: Builder(
          builder: (context) {
            final courtShowProvider = Provider.of<CourtShowProvider>(context);

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
                  _buildShowCourt(courtShowProvider.courtList!),
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
        MediaQuery(
           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Book your ",
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.booklight
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
                      ? AppColors.booklight
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
              hasErrorMessage!?
              GestureDetector(
                 onTap: () async {
                              result = await showDatePicker(
                                context: context,
                                initialDate: dateTime ?? DateTime.now(),
                                firstDate:DateTime.now(),
                                lastDate: DateTime(2101),
                                helpText: "Select Date",
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: AppColors.darkSubHead,
                                      hintColor: Colors.teal,
                                      colorScheme: const ColorScheme.light(
                                              primary: AppColors.dotColor)
                                          .copyWith(background: Colors.blueGrey),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (result != null) {
                                setState(() {
                                  dateTime = result;
                                  results = result;
                                  // _userDobController.text = DateFormat('dd/MM/yyyy').format(result!);
                      
                                  print("yp${result!.toLocal().toString()}");
                                });
                              }
                            },
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextInput
                        : Colors.white,
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 21,
                    ),
                    results != null
                        ? Text(
                            DateFormat('dd/MM/yyyy').format(results!),
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkSubHead
                                  : AppColors.subheadColor,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 24 / 14,
                            ),
                          )
                        : Text(
                            "Select Date",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkSubHead
                                  : AppColors.subheadColor,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 24 / 14,
                            ),
                          ),
                    const SizedBox(width: 8),
                    Image.asset(
                      "assets/images/calender.png",
                      height: 18,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkSubHead
                          : AppColors.subheadColor,
                    )
                   
                  ]),
                ),
              ): GestureDetector(
                onTap: () async {
                              showAlertDialog(context);
                            },
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextInput
                        : Colors.white,
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 21,
                    ),
                    results != null
                        ? Text(
                            DateFormat('dd/MM/yyyy').format(results!),
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkSubHead
                                  : AppColors.subheadColor,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 24 / 14,
                            ),
                          )
                        : Text(
                            "Select Date",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkSubHead
                                  : AppColors.subheadColor,
                              fontSize: 14,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 24 / 14,
                            ),
                          ),
                    const SizedBox(width: 8),
                    
                   Image.asset(
                     "assets/images/calender.png",
                     height: 18,
                   )
                  ]),
                ),
              )
            ],
          ),
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
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: FocusScope(
              // Manage keyboard focus
              child: hasErrorMessage!
                  ? results != null
                      ? CustomElevatedButton(
                          height: 60,
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 70
                              : double.infinity,
                          isLoading: false,
                          text: "Start Booking",
                          onPressed: () async {
                            final newResult = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingCourtScreen(
                                        result: result!,
                                      )),
                            );
    
                            // Update result with the value returned from the second screen
                            setState(() {
                              results = null;
                            });
    
                            /*await context
                              .read<BookingResponseProvider>()
                              .fetchBookingResponse(
                              result!.toUtc().toIso8601String(),
                              );*/
                          },
                          buttonColor: AppColors.elevatedColor,
                          textColor: Colors.white,
                        )
                      : CustomElevatedButton(
                          height: 60,
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 70
                              : double.infinity,
                          isLoading: false,
                          text: "Start Booking",
                          onPressed: () async {},
                          buttonColor: AppColors.buttonwithvalue,
                          textColor: AppColors.buttonmid,
                        )
                  : CustomElevatedButton(
                      height: 60,
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 70
                          : double.infinity,
                      isLoading: false,
                      text: "Start Booking",
                      onPressed: () async {
                        showAlertDialog(context);
                      },
                      buttonColor: AppColors.disableButtonColor,
                      textColor: AppColors.disableButtonTextColor,
                    ))),
    );
  }

  showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return FunkyOverlay(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                )),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Image.asset(
                            "assets/images/rafiki.png",
                            height: 196,
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 113),
                            child: const Center(
                              child: Text(
                                ' Oops!',
                                style: TextStyle(
                                  color: AppColors.dotColor,
                                  fontFamily: FontFamily.satoshi,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  height: 40 / 32,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 66),
                            child: Text(
                              "You haven't completed your Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.subheadColor,
                                fontFamily: FontFamily.satoshi,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 24 / 16,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 102, right: 102, bottom: 63),
                            child: SizedBox(
                              height: 34,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: AppColors.elevatedColor,
                                    ),
                                    borderRadius: BorderRadius.circular(98),
                                  ),
                                  backgroundColor: AppColors
                                      .elevatedColor, // Change background color on hover
                                ),

                                child: const Text(
                                  "Complete profile",
                                  style: TextStyle(
                                    color: AppColors.completeProfileColor,
                                    fontSize: 14,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w700,
                                    height: 24 / 14,
                                  ),
                                ),
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();

                                  pref.remove('authToken');
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterForm(
                                                email: '',
                                              )));

                                  /*
                                        setState(() {
                                          isLoading = true;
                                        });
                                       
                            
                                        setState(() {
                                          isLoading = false;
                                        });
                                        */
                                },
                                //buttonColor: AppColors.elevatedColor,
                                // textColor: Colors.white,
                              ),
                            ),
                          ),
                          /*TextButton(
                            onPressed: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              String? email = pref.getString('email');
                              Navigator.pop(context);
                              /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterForm(
                                            email: email!,
                                          )));*/
                            },
                            child: const Text('OK',
                                style: TextStyle(
                                    color: Color(0xff03BF4E),
                                    fontWeight: FontWeight.bold)),
                          ),*/
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlotshowText() {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
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
                        decoration: juniorColor
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationThickness: 3.0,
                        color: juniorColor
                            ? AppColors.dotColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSubHead
                                : Color.fromRGBO(0, 0, 0, 0.50),
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
                    child: Text(
                      "Senior",
                      style: TextStyle(
                        decoration: seniorColor
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: seniorColor
                            ? AppColors.dotColor // Color of the underline
                            : Colors.transparent,
                        decorationStyle: seniorColor
                            ? TextDecorationStyle.solid
                            : TextDecorationStyle.solid,
                        decorationThickness: 3.0,
                        color: seniorColor
                            ? AppColors.dotColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSubHead
                                : Color.fromRGBO(0, 0, 0, 0.50),
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
          )),
    );
  }

  Widget _buildShowCourt(CourtList courtList) {
    final List<Court> filteredCourts = (juniorColor || seniorColor)
        ? (juniorColor
            ? courtList.result
                .where((court) => court.ageGroup == 'Junior')
                .toList()
            : courtList.result
                .where((court) => court.ageGroup == 'Senior')
                .toList())
        : List.from(courtList.result);
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredCourts.length,
        itemBuilder: (context, index) {
          Court court = filteredCourts[index];
          // Format start and end times
          String startTime = DateFormat('h a').format(
            DateFormat('HH:mm:ss').parse(court.startTime),
          );
          String endTime = DateFormat('h a').format(
            DateFormat('HH:mm:ss').parse(court.endTime),
          );
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: MediaQuery(
               data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Container(
                width: 145,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextInput
                      : Colors.white,
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
                              court.courtImageURLs[0] , // Use the image URL from the Court model
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
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.booklight
                                          : AppColors.allHeadColor,
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
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.darkSubHead
                                          : AppColors.hintColor,
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
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.headingTextColor
                                      : Colors.black,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildrecentBookText() {
    return Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: MediaQuery(
           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
          ),
        ));
  }

  Widget _buildNoBook() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 138,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextInput
                : Colors.white,
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Image.asset(
                "assets/images/Nobooking.png",
              ),
            ),
            MediaQuery(
               data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TextSpan
                  SizedBox(
                    width: 147,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "No Recent Bookings  ",
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.booklight
                                      : AppColors.subheadColor,
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
                              color:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.darkSubHead
                                      : AppColors.hintColor,
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
              ),
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
    result = null;
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
          (BuildContext context, Object error, StackTrace? stackTrace) {
        // Handle the error, e.g., display a placeholder image
        return Image.asset(
          "assets/images/userImage.png",
          width: width,
          height: height,
        );
      },
    );
  }
}
