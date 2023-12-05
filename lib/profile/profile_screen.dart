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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  bool juniorColor = false, seniorColor = false;

  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  bool state = false;
  bool lightState=true;
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
  Future<void> profile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    profileProvider.fetchProfile(token);
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkThemeback
            : AppColors.lightThemeback,
        primary: true,
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                width: 24,
              ),
              Text(
                "My Account",
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
              name = profileData.result.name;
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(child: _buildLoginText()),
                  _buildProfilePerfomence()
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
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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

  Widget _buildProfilePerfomence() {
    final themeNotifier = context.watch<ThemeModeNotifier>();
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            height: 436,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0), color: 
                Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextInput
                              : Colors.white,
                ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/Profile1.png",
                            height: 15,
                            color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSubHead
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        "My Profile",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () async {},
                            child: Image.asset(
                              "assets/images/Right3.png",
                              width: 24,
                              height: 24,
                              color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/Card1.png",
                            height: 15,
                             color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        "Membership",
                        style: TextStyle(
                          color:Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () async {},
                            child: Image.asset(
                              "assets/images/Right3.png",
                              width: 24,
                              height: 24,
                               color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/Group3.png",
                            height: 15,
                             color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        "My Team",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () async {},
                            child: Image.asset(
                              "assets/images/Right3.png",
                              width: 24,
                              height: 24,
                               color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/Notification3.png",
                            height: 15,
                             color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () async {},
                            child: Image.asset(
                              "assets/images/Right3.png",
                              width: 24,
                              height: 24,
                               color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/Document5.png",
                            height: 15,
                             color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        "Languages - English",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Transform.scale(
                            scale: 0.6,
                            child: SizedBox(
                              height: 20,
                              child: CupertinoSwitch(
                                trackColor: AppColors.disableSwitch,
                                thumbColor: Colors.white,
                                activeColor: AppColors.confirmValid,
                                value: state,
                                onChanged: (value) {
                                  state = value;
                                  setState(
                                    () {},
                                  );
                                },
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/Sun1.png",
                            height: 15,
                             color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        "Light Mode",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Transform.scale(
                            scale: 0.6,
                            child: SizedBox(
                              height: 20,
                              child: CupertinoSwitch(
                                trackColor: AppColors.disableSwitch,
                                thumbColor: Colors.white,
                                activeColor: AppColors.confirmValid,
                                value: themeNotifier.themeMode == ThemeMode.light,
                                onChanged: (value) {
                                 
                                  setState(
                                    () {
                                      final newMode = value
                                          ? ThemeMode.light
                                          : ThemeMode.dark;
                                      themeNotifier.setThemeMode(newMode);
                                    },
                                  );
                                },
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/Like.png",
                            height: 15,
                             color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        "Rate Us",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    Container(
                      height: 17,
                      width: 17,
                      child: GestureDetector(
                          onTap: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();

                            pref.remove('authToken');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: Image.asset(
                            "assets/images/Logout.png",
                            height: 15,
                             color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          )),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();

                        pref.remove('authToken');
                        Provider.of<ProfileProvider>(context, listen: false)
                            .clearStateList();
                        Provider.of<CheckStatusProvider>(context, listen: false)
                            .clearStateList();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.profileDarkText
                              : AppColors.subheadColor,
                          fontSize: 16,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
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
        ));
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
