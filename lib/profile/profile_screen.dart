// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/language/provider/language_change_controller.dart';
import 'package:tennis_court_booking_app/notifications/notification_screen.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';

import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/profile/profileThings/my_profile_screen.dart';
import 'package:tennis_court_booking_app/profile/profileThings/my_teams.dart';

import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool lightState = true;
  var languages = ["English", "Hindi", "Marathi"];
  var destinationLanguage = "English";
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
      final languageNotifier = context.watch<LanguageChangeController>();
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkThemeback
              : AppColors.lightThemeback,
          primary: true,
          appBar: AppBar(
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                SizedBox(
                  width: 24,
                ),
                Text(
                  (AppLocalizations.of(context)!.accounts),
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
              return Padding(
                padding: const EdgeInsets.only(top: 180),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.dotColor,
                  ),
                ),
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
                  Center(child: _buildLoginText()),
                  _buildProfilePerfomence(),
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
        child: Center(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
          ),
        ));
  }

  Widget _buildProfilePerfomence() {
    final themeNotifier = context.watch<ThemeModeNotifier>();
    final languageNotifier = context.watch<LanguageChangeController>();
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            // height: 436,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextInput
                  : Colors.white,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfileScreen(
                                    pageName: "My Profile",
                                  )));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 21,
                        ),
                        Container(
                          height: 17,
                          width: 17,
                          child: Image.asset(
                            "assets/images/Profile1.png",
                            height: 15,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkSubHead
                                    : AppColors.subheadColor,
                          ),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          (AppLocalizations.of(context)!.myProfile),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                            fontSize: 16 * textScaleFactor,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w500,
                            height: 24 / 16,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: languageNotifier.appLocale == Locale("en")
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    "assets/images/Right.png",
                                    height: 24,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.headingTextColor
                                        : Colors.black,
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    "assets/images/rightarabic.png",
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.profileDarkText
                                  : AppColors.subheadColor,
                            )),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: () async {},
                        child: Text(
                          (AppLocalizations.of(context)!.membership),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                            fontSize: 16 * textScaleFactor,
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
                        child: languageNotifier.appLocale == Locale("en")
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  "assets/images/Right.png",
                                  height: 24,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.headingTextColor
                                      : Colors.black,
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  "assets/images/rightarabic.png",
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyTeamsScreen(
                                            pageName: "My Team",
                                          )));
                            },
                            child: Image.asset(
                              "assets/images/Group3.png",
                              height: 15,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.profileDarkText
                                  : AppColors.subheadColor,
                            )),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyTeamsScreen(
                                        pageName: "My Team",
                                      )));
                        },
                        child: Text(
                          (AppLocalizations.of(context)!.myTeam),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                            fontSize: 16 * textScaleFactor,
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
                        child: languageNotifier.appLocale == Locale("en")
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  "assets/images/Right.png",
                                  height: 24,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.headingTextColor
                                      : Colors.black,
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  "assets/images/rightarabic.png",
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
                  SizedBox(
                    height: 26,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen(
                                    pageName: "Notification",
                                  )));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 21,
                        ),
                        Container(
                          height: 17,
                          width: 17,
                          child: Image.asset(
                            "assets/images/Notification3.png",
                            height: 15,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                          ),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          (AppLocalizations.of(context)!.notification),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                            fontSize: 16 * textScaleFactor,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w500,
                            height: 24 / 16,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: languageNotifier.appLocale == Locale("en")
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    "assets/images/Right.png",
                                    height: 24,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.headingTextColor
                                        : Colors.black,
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    "assets/images/rightarabic.png",
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
                  SizedBox(
                    height: 26,
                  ),
                  Consumer<LanguageChangeController>(
  builder: (context, languageNotifier, _) {
    return Row(
      children: [
        SizedBox(width: 21),
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
            ),
          ),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () async {},
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Text(
              (AppLocalizations.of(context)!.language),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.profileDarkText
                    : AppColors.subheadColor,
                fontSize: 16 * textScaleFactor,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
              ),
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
                  value: languageNotifier.appLocale == Locale("en"),
                  onChanged: (value) {
                    print("hi");
                    setState(() {
                      final newLocale = value ? Locale("en") : Locale("ar");
                      print(newLocale);
                      languageNotifier.changeLanguage(newLocale);
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  },
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.profileDarkText
                                  : AppColors.subheadColor,
                            )),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: () async {},
                        child: Text(
                          (AppLocalizations.of(context)!.lightMode),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                            fontSize: 16 * textScaleFactor,
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
                                  value: themeNotifier.themeMode ==
                                      ThemeMode.light,
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.profileDarkText
                                  : AppColors.subheadColor,
                            )),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: () async {},
                        child: Text(
                          (AppLocalizations.of(context)!.rateUS),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                            fontSize: 16 * textScaleFactor,
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
                          child: languageNotifier.appLocale == Locale("ar")
                              ? Transform.flip(
                                  flipX: true,
                                  child: Image.asset(
                                    "assets/images/Logout.png",
                                    height: 15,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.profileDarkText
                                        : AppColors.subheadColor,
                                  ),
                                )
                              : Image.asset(
                                  "assets/images/Logout.png",
                                  height: 15,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.profileDarkText
                                      : AppColors.subheadColor,
                                ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();

                          pref.remove('authToken');
                        

                          Provider.of<ProfileProvider>(context, listen: false)
                              .clearStateList();
                          Provider.of<CheckStatusProvider>(context,
                                  listen: false)
                              .clearStateList();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: Text(
                          (AppLocalizations.of(context)!.logOut),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.profileDarkText
                                    : AppColors.subheadColor,
                            fontSize: 16 * textScaleFactor,
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
