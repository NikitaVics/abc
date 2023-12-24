// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';

import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';

import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_noneditable.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class MyProfileScreen extends StatefulWidget {
  final String pageName;
  const MyProfileScreen({super.key, required this.pageName});

  @override
  MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  //text controllers:-----------------------------------------------------------
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phonePrefixController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  bool juniorColor = false, seniorColor = false;
bool isSelected = false;
  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  bool state = false;
  bool lightState = true;
  //SignInProvider? provider;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    profile();
  }

  FocusNode myFocusNode = FocusNode();
  bool isFormDone = false;
  String name = "";
  String? tokens;
  Future<void> profile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    profileProvider.fetchProfile(token);
    print(name);
  }

  bool isEdited = false;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
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
                          widget.pageName,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
      );
    });
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : Colors.white,
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Column(
                  children: [
                    Expanded(child: _buildRightSide()),
                    isEdited ? _buildSignInButton() : SizedBox()
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: _buildRightSide()),
                    isEdited ? _buildSignInButton() : SizedBox()
                  ],
                ),
        ],
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
                  _buildLoginText(),
                  isEdited
                      ? const SizedBox()
                      : const SizedBox(
                          height: 20,
                        ),
                  _buildProfilePerfomence(),
                  _buildPerfomenceEveryBooking(),
                  SizedBox(
                    height: 20,
                  ),
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
        padding: const EdgeInsets.only(top: 28),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(150.0),
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? SilentErrorImage(
                        width: 80.0,
                        height: 80.0,
                        imageUrl: imageUrl!,
                      )
                    : Image.asset(
                        "assets/images/userImage.png",
                        width: 80.0,
                        height: 80.0,
                      )),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isEdited) {
                          isEdited = false;
                        } else {
                          isEdited = true;
                          nameController.text = name;
                        }
                      });
                    },
                    child: Text(
                      isEdited ? "Discard" : "Edit Profile",
                      style: TextStyle(
                        color: isEdited
                            ? AppColors.errorColor
                            : AppColors.dotColor,
                        fontSize: 14,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ));
  }

  Widget _buildProfilePerfomence() {
    Color borderColor = AppColors.appbarBoarder;
    final themeNotifier = context.watch<ThemeModeNotifier>();
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFieldNonEditable(
                  width: MediaQuery.of(context).size.width,
                  controller: nameController,
                  focusBorderColor: AppColors.focusTextBoarder,
                  fillColor:
                      isEdited ? AppColors.textInputField : Colors.transparent,
                  boarderColor: isEdited
                      ? AppColors.transparent
                      : AppColors.appbarBoarder,
                  color:
                      isEdited ? AppColors.textInputField : Colors.transparent,
                  hintColor:
                      isEdited ? AppColors.hintColor : AppColors.subheadColor,
                  hint: isEdited ? "User Name " : name,
                  obscure: false,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  editable: isEdited,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    TextFieldNonEditable(
                      width: MediaQuery.of(context).size.width / 5.5,
                      controller: phonePrefixController,
                      focusBorderColor: AppColors.focusTextBoarder,
                      fillColor: isEdited
                          ? AppColors.textInputField
                          : Colors.transparent,
                      boarderColor: isEdited
                          ? AppColors.transparent
                          : AppColors.appbarBoarder,
                      color: isEdited
                          ? AppColors.textInputField
                          : Colors.transparent,
                      hintColor: isEdited
                          ? AppColors.hintColor
                          : AppColors.subheadColor,
                      hint: isEdited ? "+973 " : name,
                      obscure: false,
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      editable: isEdited,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextFieldNonEditable(
                        width: MediaQuery.of(context).size.width / 1.5,
                        controller: phoneController,
                        focusBorderColor: AppColors.focusTextBoarder,
                        fillColor: isEdited
                            ? AppColors.textInputField
                            : Colors.transparent,
                        boarderColor: isEdited
                            ? AppColors.transparent
                            : AppColors.appbarBoarder,
                        color: isEdited
                            ? AppColors.textInputField
                            : Colors.transparent,
                        hintColor: isEdited
                            ? AppColors.hintColor
                            : AppColors.subheadColor,
                        hint: isEdited ? "Phone Number " : name,
                        obscure: false,
                        textInputType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        editable: isEdited,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldNonEditable(
                  width: MediaQuery.of(context).size.width,
                  controller: genderController,
                  focusBorderColor: AppColors.focusTextBoarder,
                  fillColor: Colors.transparent,
                  boarderColor: AppColors.appbarBoarder,
                  color: Colors.transparent,
                  hintColor: AppColors.subheadColor,
                  hint: name,
                  obscure: false,
                  textInputType: TextInputType.text,
                  editable: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                isEdited
                    ? GestureDetector(
                        onTap: () {
                         isSelected = !isSelected;
    setState(() {});
                        },
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.textInputField,
                              border: Border.all(
                                  color:isSelected?borderColor:AppColors.focusTextBoarder, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Change Password",
                                style: TextStyle(
                                  color: AppColors.subheadColor,
                                  fontSize: 16,
                                  fontFamily: FontFamily.satoshi,
                                  fontWeight: FontWeight.w400,
                                  height: 24 / 16,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: Image.asset(
                                  "assets/images/Right.png",
                                  //width: 18,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ));
  }

  Widget _buildPerfomenceEveryBooking() {
    final themeNotifier = context.watch<ThemeModeNotifier>();
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 104,
                    decoration: BoxDecoration(
                        color: AppColors.bookingShowColor,
                        border: Border.all(color: AppColors.confirmValid),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "20",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.confirmValid
                                  : AppColors.confirmValid,
                              fontSize: 32,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 40 / 32,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Total Number of ",
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.totalbookingColor
                                    : AppColors.totalbookingColor,
                                fontSize: 12,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w400,
                                height: 20 / 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Bookings",
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.totalbookingColor
                                    : AppColors.totalbookingColor,
                                fontSize: 12,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w400,
                                height: 20 / 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 104,
                    decoration: BoxDecoration(
                        color: AppColors.cancelBack,
                        border: Border.all(color: AppColors.errorColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "20",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.errorColor
                                  : AppColors.errorColor,
                              fontSize: 32,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 40 / 32,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Cancelled ",
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.cancelBooking
                                    : AppColors.cancelBooking,
                                fontSize: 12,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w400,
                                height: 20 / 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Bookings",
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.cancelBooking
                                    : AppColors.cancelBooking,
                                fontSize: 12,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w400,
                                height: 20 / 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSignInButton() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: FocusScope(
              // Manage keyboard focus
              child: CustomElevatedButton(
            height: 60,
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 70
                : double.infinity,
            isLoading: false,
            text: "Update profile",
            onPressed: () async {},
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
    this.width = 80.0,
    this.height = 80.0,
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
          "assets/images/userImage.png",
          width: width,
          height: height,
        );
      },
    );
  }
}
