// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/bookingprocess/booking_court.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/confirm_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/court_info_provider.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/constants/shimmer.dart';
import 'package:tennis_court_booking_app/model/courtInfo/court_info.dart';
import 'package:tennis_court_booking_app/model/upComingBooking/upcoming_booking_model.dart';
import 'package:tennis_court_booking_app/mybookings/bookingDetails/booking_details.dart';
import 'package:tennis_court_booking_app/mybookings/provider/upComing_provider.dart';
import 'package:tennis_court_booking_app/notifications/notification_service.dart';
import 'package:tennis_court_booking_app/presentation/home/courtinfo/court_info.dart';
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
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late CurvedAnimation _animation;
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
  int? id;
  bool _isInitializationComplete = false;

  @override
  void initState() {
    super.initState();

    _passwordFocusNode = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Set the duration as needed
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _initializeData();
  }

  Future<void> _initializeData() async {
    await profile();
    await _fetchCourtInfoResponse();
    _animationController.forward();
  }

  final picker = ImagePicker();
  Future<void> _fetchCourtInfoResponse() async {
    await context.read<CourtInfoProvider>().fetchCourtInfo(id ?? 0);
  }

  File? imageFile;
  bool isFormDone = false;
  String name = "";
  String? tokens;
  bool loading = false;
  Future<void> profile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final upComingProvider =
        Provider.of<UpcomingBookProvider>(context, listen: false);
    final checkstatusprovider =
        Provider.of<CheckStatusProvider>(context, listen: false);

    setState(() {
      loading = true;
    });

    tokens = await SharePref.fetchAuthToken();
    print("Tokio $tokens");
    profileProvider.fetchProfile(tokens!);
    checkstatusprovider.checkRegistrationStatus(tokens!);
    upComingProvider.fetchupComingData(tokens!);
    setState(() {
      loading = false;
    });
  }

  bool? hasErrorMessage;
  bool isDeleting = false;
  String? tempImageUrl;

//Home
  @override
  Widget build(BuildContext context) {
    return Consumer2<CheckStatusProvider, ProfileProvider>(
      builder: (context, checkStatusProvider, profileProvider, child) {
        if (checkStatusProvider.checkStatus == null) {
          profileProvider.fetchProfile(tokens ?? "");
          checkStatusProvider.checkRegistrationStatus(tokens ?? "");

          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          imageUrl = profileProvider.profileModel?.result.imageUrl;
          name = profileProvider.profileModel?.result.name ?? "";
          hasErrorMessage = checkStatusProvider.checkStatus!.result;
          List<String> nameParts = name.split(' ');

// Extract the first name
          String firstName = nameParts.isNotEmpty ? nameParts.first : '';

          print("Nope $hasErrorMessage");

          return loading == true && _isInitializationComplete == true
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
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0.0, -100 * (1 - _animation.value)),
                            child: child,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkTextInput
                                    : Colors.white,
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Map<Permission, PermissionStatus>
                                            statuses = await [
                                          Permission.storage,
                                          Permission.camera,
                                        ].request();
                                        if (statuses[Permission.storage]!
                                                .isGranted &&
                                            statuses[Permission.camera]!
                                                .isGranted) {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => changeImage(),
                                          );
                                        } else {}
                                      },
                                      child: SizedBox(
                                        height: 48,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24),
                                          child: isDeleting
                                              ? SilentErrorImage(
                                                  width: 48.0,
                                                  height: 48.0,
                                                  imageUrl: tempImageUrl!)
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150.0),
                                                  child: imageFile == null
                                                      ? SilentErrorImage(
                                                          width: 48.0,
                                                          height: 48.0,
                                                          imageUrl: imageUrl!,
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      150.0),
                                                          child: Image.file(
                                                            imageFile!,
                                                            height: 48.0,
                                                            width: 48.0,
                                                            fit: BoxFit.fill,
                                                          ))),
                                        ),
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
                                              color: Theme.of(context)
                                                          .brightness ==
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
                                              color: Theme.of(context)
                                                          .brightness ==
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
                                                      await SharePref
                                                          .fetchEmail();
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegisterForm(
                                                        email: email!,
                                                        password: '',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.errorback,
                                                  foregroundColor:
                                                      AppColors.errorColor,
                                                  side: BorderSide(
                                                      color:
                                                          AppColors.errorColor),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Complete profile',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.satoshi,
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
                                            color:
                                                Theme.of(context).brightness ==
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
                      ),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                );
        }
      },
    );
  }

  Widget changeImage() {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: Color(0xFFf8f8f8),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.02),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile Photo",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.booklight
                        : AppColors.allHeadColor,
                    fontSize: 25,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isDeleting = true;
                      tempImageUrl = "assets/images/userImage.png";
                    });

                    await Api.removePhoto(tokens!);
                    await profile();
                    setState(() {
                      isDeleting = false;
                      tempImageUrl = imageUrl;
                    });
                  },
                  child: Image.asset(
                    "assets/images/Delete.png",
                    height: 26,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 133,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFEFE),
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.02),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 41, bottom: 41, left: 54, right: 54),
                        child: GestureDetector(
                          onTap: () async {
                            await _imgFromGallery();

                            // Step 2: Check if imageFile is not null after picking from gallery
                            if (imageFile != null) {
                              // Step 3: Call API to update image
                              await Api.updateImage(tokens!, imageFile!.path);

                              // Step 4: Update the profile
                            }
                            await profile();
                          },
                          child: Center(
                            child: Image.asset(
                              "assets/images/gallery.png",
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: Container(
                      height: 133,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEFEFE),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.02),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 41, bottom: 41, left: 54, right: 54),
                        child: GestureDetector(
                          onTap: () async {
                            _imgFromCamera();
                            await Api.updateImage(tokens!, imageFile!.path);
                            await profile();
                          },
                          child: Image.asset(
                            "assets/images/selfie.png",
                          ),
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          result = null;
        });
        return false;
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
                  hasErrorMessage!
                      ? Consumer<UpcomingBookProvider>(
                          builder: (context, provider, child) {
                          final bookingResponse = provider.upComingBookModel;

                          if (bookingResponse != null &&
                              bookingResponse.result.isNotEmpty) {
                            List result = bookingResponse.result
                                .map((teamMembers) => teamMembers.bookingDate)
                                .toList();

                            List<Booking> bookings = bookingResponse.result;

                            print(bookings.length);
                            return Container(
                              height: 126,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: bookings.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<BookResultShowProvider>()
                                          .clearStateList();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookingDetailsScreen(
                                                      id: bookings[index]
                                                          .bookingId)));
                                    },
                                    child: _buildupComingbooking(index,
                                        bookings.length, bookings[index]),
                                  );
                                },
                              ),
                            );
                          } else {
                            return buildnoBook();
                          }
                        })
                      : buildnoCompleteProfileforBook(),
                  SizedBox(
                    height: 20,
                  )
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
      padding: const EdgeInsets.only(top: 40),
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
              hasErrorMessage!
                  ? GestureDetector(
                      onTap: () async {
                        result = await showDatePicker(
                          
                          context: context,
                          initialDate: dateTime ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                          helpText: "Select Date",
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data:Theme.of(context).brightness == Brightness.dark
                      ? ThemeData.dark().copyWith(
                                // Customize the color scheme here
                                colorScheme: const ColorScheme.dark(
                                  primary: AppColors.darkEditColor, // Change primary color
                                  onPrimary:AppColors.darkThemeback, // Change text color on primary
                                  surface: AppColors.darkThemeback, // Change surface color
                                  onSurface: AppColors.darkSubHead,

                                  // Change text color on surface
                                ),
                               
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        AppColors.darkEditColor, // button text color
                                  ),
                                ),
                                // You can customize more properties here if needed
                              ):ThemeData.light().copyWith(
                                // Customize the color scheme here
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.dotColor, // Change primary color
                                  onPrimary: Colors
                                      .white, // Change text color on primary
                                  surface: Colors.white, // Change surface color
                                  onSurface: AppColors.allHeadColor,

                                  // Change text color on surface
                                ),
                                selectedRowColor: AppColors.dotColor,
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        AppColors.dotColor, // button text color
                                  ),
                                ),
                                // You can customize more properties here if needed
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkSubHead
                                    : AppColors.subheadColor,
                          )
                        ]),
                      ),
                    )
                  : GestureDetector(
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
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
                                                password: '',
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
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    id = court.courtId;
                  });
                  await showAnimatedDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: FutureBuilder<void>(
                          future: _fetchCourtInfoResponse(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return buidSheet();
                            } else {
                              // You can return a loading indicator or null while waiting for the future
                              return Center(
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    WavyAnimatedText(
                                      'Loading...',
                                      textStyle: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.headingTextColor
                                              : AppColors.allHeadColor,
                                          fontSize: 20,
                                          fontFamily: FontFamily.satoshi,
                                          fontWeight: FontWeight.w500,
                                          height: 34 / 20,
                                          decoration: TextDecoration.none),
                                    ),
                                  ],
                                  repeatForever: true,
                                  isRepeatingAnimation: true,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
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
                                court.courtImageURLs[
                                    0], // Use the image URL from the Court model
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavBar(initial: 1),
                    ),
                  );
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.dotColor,
                    decorationThickness:
                        2.0, // Set the thickness of the underline
                    decorationStyle: TextDecorationStyle.solid,

                    color: AppColors.dotColor,
                    fontSize: 14,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w700,
                    height: 24 / 14,
                  ),
                ),
              ),
            ],
          ),
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

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextInput
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 2,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SilentErrorImage(
                    height: 102,
                    width: 82,
                    imageUrl: booking?.tennisCourt.courtImageURLs[0] ??
                        'assets/images/ProfileImage.png',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 14),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            booking?.tennisCourt.name ?? "",
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
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          /// color: Colors.pink,
                          height: 16,
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/calender.png",
                                height: 12,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.darkSubHead
                                    : AppColors.subheadColor,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "${month}".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10,
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w400,
                                  //height: 0.16,
                                ),
                              ),
                              Text(
                                " ${day}",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10,
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w400,
                                  // height: 0.16,
                                ),
                              ),
                              Text(
                                " ${timePart} ${dateTime.hour < 12 ? 'am' : 'pm'}",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10,
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w400,
                                  // height: 0.16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          /// color: Colors.pink,
                          height: 16,
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/Group3.png",
                                height: 12,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.darkSubHead
                                    : Colors.black.withOpacity(0.5),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                " Team Members",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10,
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w400,
                                  // height: 0.16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 36,
                              child: Stack(
                                children: [
                                  Positioned(
                                      left: 0,
                                      top: 0,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(110.0),
                                        child: SilentErrorImage(
                                          width: 30,
                                          height: 30,
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
                                      double leftPad =
                                          (23 * (index + 1)).toDouble();
                                      return Positioned(
                                        left: leftPad,
                                        top: 0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(150.0),
                                          child: SilentErrorImage(
                                            width: 30,
                                            height: 30,
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
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
  Widget _buildNoBook(UpcomingBookingModel? booking) {
    final List<Booking> booking=booking.res
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
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: booking.length,
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
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    id = court.courtId;
                  });
                  await showAnimatedDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: FutureBuilder<void>(
                          future: _fetchCourtInfoResponse(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return buidSheet();
                            } else {
                              // You can return a loading indicator or null while waiting for the future
                              return Center(
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    WavyAnimatedText(
                                      'Loading...',
                                      textStyle: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.headingTextColor
                                              : AppColors.allHeadColor,
                                          fontSize: 20,
                                          fontFamily: FontFamily.satoshi,
                                          fontWeight: FontWeight.w500,
                                          height: 34 / 20,
                                          decoration: TextDecoration.none),
                                    ),
                                  ],
                                  repeatForever: true,
                                  isRepeatingAnimation: true,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
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
                                court.courtImageURLs[
                                    0], // Use the image URL from the Court model
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
            ),
          );
        },
      ),
    );
    /* */
  }
*/
  Widget buildnoBook() {
    return Container(
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
                              'Continue booking now ', // The first half of the sentence
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
                              'for an amazing experience!', // The second half of the sentence
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
    );
  }

  Widget buildnoCompleteProfileforBook() {
    return Container(
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
    );
  }

  Widget buidSheet() {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 48; // 24 padding on each side
    double containerHeight = MediaQuery.of(context).size.height / 1.5;

    return Container(
      color: Colors.white,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 330,
                        child: MyHomePage(imageUrls: imageUrls, height: 330)),
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
                          color: Theme.of(context).brightness == Brightness.dark
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
                      padding: EdgeInsets.only(left: 24, right: 24, top: 19.2),
                      child: Divider(
                        color: AppColors.appbarBoarder,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13.5),
                      child: Text(
                        "Available facilities",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
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

    _animationController.dispose();
    _passwordFocusNode.dispose();
    result = null;
    super.dispose();
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _imgFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
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

class MyHomePage extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  MyHomePage({required this.imageUrls, required this.height});

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
      child: ImageSlideshow(
        height: widget.height,
        indicatorColor: Colors.blue,
        onPageChanged: (value) {
          debugPrint('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: widget.imageUrls.map((imageUrl) {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          );
        }).toList(),
      ),
    );
  }
}
