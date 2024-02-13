// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/language/provider/language_change_controller.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';

import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/profile/passwardChange/password_change.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/myprofile_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profileCreate_provider.dart';

import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/genderField.dart';
import 'package:tennis_court_booking_app/widgets/textfield_noneditable.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  FocusNode _focusNode = FocusNode();
  

  //predefine bool value for error:---------------------------------------------
  bool emailError = false,
      passwordError = false,
      confirmPasswordError = false,
      loginError = false;
  String emailErrorText = '',
      passwordErrorText = '',
      loginErrorMessage = '',
      confirmPasswordErrorText = '';
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmpasswordFocusNode;
  bool isLoading = false;
  //predefine bool value for error:---------------------------------------------
  List<bool> isPasswordValid(String password) {
    // Define regular expressions for each condition
    final lowercaseRegex = RegExp(r'[a-z]');
    final uppercaseRegex = RegExp(r'[A-Z]');
    final digitRegex = RegExp(r'[0-9]');
    final specialCharRegex = RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]');

    final isLengthValid = password.length >= 8;
    final hasLowercase = lowercaseRegex.hasMatch(password);
    final hasUppercase = uppercaseRegex.hasMatch(password);
    final hasDigit = digitRegex.hasMatch(password);
    final hasSpecialChar = specialCharRegex.hasMatch(password);

    return [
      isLengthValid,
      hasLowercase,
      hasUppercase,
      hasDigit,
      hasSpecialChar
    ];
  }

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------

  bool juniorColor = false, seniorColor = false;
  bool isSelected = false;
  DateTime? dateTime;
  DateTime? result;
  String? imageUrl;
  bool state = false;
  bool lightState = true;
  //SignInProvider? provider;
  bool _isMenuVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      setState(() {
        _isMenuVisible = _passwordFocusNode.hasFocus;
      });
    });
    _confirmpasswordFocusNode = FocusNode();
    _confirmpasswordFocusNode.addListener(() {
      //validateConfirmPassword();
    });
    profile();
  }

  FocusNode myFocusNode = FocusNode();
  bool isFormDone = false;
  String prefPhone = "";
  String name = "";
  String userName = "";
  String phoneNum = "";
  String gen = "";
  String bookCount = "";
  String cancelBook = "";
  String? tokens;
  File? imageFile;

  Future<void> profile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    profileProvider.fetchProfile(token);
    final myProfileProv =
        Provider.of<MyProfileProvider>(context, listen: false);
    myProfileProv.fetchProfile(token);

    print(name);
  }

  bool isEdited = false;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final languageNotifier = context.watch<LanguageChangeController>();
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
                width: 1.0,
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
                          icon:languageNotifier.appLocale == Locale("ar")? Transform.flip(
                            flipX: true,
                           child: Image.asset(
                              "assets/images/leftIcon.png",
                              color:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.headingTextColor
                                      : AppColors.profileHead,
                              //width: 18,
                              height: 26,
                            ),
                          ): Image.asset(
                            "assets/images/leftIcon.png",
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.profileHead,
                            //width: 18,
                            height: 26,
                          ),
                        ),
                        SizedBox(
                          width: 106,
                        ),
                        Text(
                          (AppLocalizations.of(context)!.myProfile),
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
              ? AppColors.darkThemeback
              : AppColors.lightThemeback,
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
        child: Consumer2<ProfileProvider, MyProfileProvider>(
          builder: (context, provider, providers, child) {
            if (provider.profileModel == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkEditColor
                      : AppColors.dotColor,
                ),
              );
            } else {
              final profileData = provider.profileModel!;
              final myprofileData = providers.myProfile;

              imageUrl = profileData.result.imageUrl;
              name = profileData.result.name ?? "";
              phoneNum = myprofileData?.result.phoneNumber ?? "";
              gen = myprofileData?.result.gender ?? "";
              prefPhone = myprofileData?.result.countryCode ?? "";
              bookCount = myprofileData?.result.totalBookings.toString() ?? "0";
              cancelBook =
                  myprofileData?.result.totalCancelledBookings.toString() ??
                      "0";

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
                  const SizedBox(
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
        padding: const EdgeInsets.only(top: 38),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.storage,
                  Permission.camera,
                ].request();
                if (statuses[Permission.storage]!.isGranted &&
                    statuses[Permission.camera]!.isGranted) {
                  showImagePicker(context);
                } else {}
              },
              child: ClipRRect(
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
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10,right: 20),
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
                          nameController.text = userName;
                          phoneController.text = phoneNum;
                          genderController.text = gen;
                          phonePrefixController.text = prefPhone;
                        }
                      });
                    },
                    child: Text(
                      isEdited ? (AppLocalizations.of(context)!.discard) : (AppLocalizations.of(context)!.editProfile),
                      style: TextStyle(
                        color: isEdited
                            ? AppColors.errorColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkEditColor
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
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkAppBarboarder
        : AppColors.appbarBoarder;
    final themeNotifier = context.watch<ThemeModeNotifier>();
    final languageNotifier = context.watch<LanguageChangeController>();
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Consumer<MyProfileProvider>(builder: (context, provider, child) {
          if (provider.myProfile == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        isEdited
                            ? Expanded(
                                flex: 1,
                                child: GenderTextFieldWidget(
                                  read: false,
                                  hint: '+ ',
                                  inputType: TextInputType.none,
                                  focusNode: _focusNode,
                                  hintColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkhint
                                      : AppColors.hintColor,
                                  // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
                                  textController: phonePrefixController,
                                  inputAction: TextInputAction.next,
                                  errorBorderColor: AppColors
                                      .errorColor, // Border color for validation error

                                  focusBorderColor: AppColors.focusTextBoarder,
                                  autoFocus: false,
                                  onSuffixIconPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        phonePrefixController.text =
                                            "+ ${country.phoneCode}";
                                        setState(() {});
                                      },
                                    );
                                  },
                                  onChanged: (value) {
                                    // Trigger validation on text change
                                  },
                                  errorText: " ",
                                  isIcon: true,
                                ),
                              )
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 20,
                                        bottom: 20),
                                    child: Text(
                                      prefPhone,
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.profileDarkText
                                            : AppColors.subheadColor,
                                        fontSize: 16,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w400,
                                        height: 24 / 16,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkAppBarboarder
                                            : AppColors.appbarBoarder,
                                      )),
                                ),
                              ),
                        SizedBox(
                          width: 8,
                        ),
                        isEdited
                            ? Expanded(
                                flex: 2,
                                child: TextFieldWidget(
                                  read: false,
                                  hint: (AppLocalizations.of(context)!.phoneNo),
                                  inputType: TextInputType.phone,
                                  hintColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkhint
                                      : AppColors.hintColor,
                                  // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
                                  textController: phoneController,
                                  inputAction: TextInputAction.next,
                                  errorBorderColor: AppColors.textInputField,
                                  focusBorderColor: AppColors.focusTextBoarder,
                                  autoFocus: false,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  errorText: " ",
                                ))
                            : Expanded(
                                flex: 2,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 20,
                                        bottom: 20),
                                    child: Text(
                                      phoneNum,
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.profileDarkText
                                            : AppColors.subheadColor,
                                        fontSize: 16,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w400,
                                        height: 24 / 16,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkAppBarboarder
                                            : AppColors.appbarBoarder,
                                      )),
                                ),
                              ),

                        /* InkWell(
                          onTap: isEdited == true
                              ? () {
                                  if (isEdited == true) {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        phonePrefixController.text =
                                            "+ ${country.phoneCode}";
                                      },
                                    );
                                  }
                                }
                              : null,
                          child:Theme.of(context).brightness == Brightness.dark
                          ? TextFieldNonEditable(
                            width: MediaQuery.of(context).size.width / 5.5,
                            focusNode: _focusNode,
                            controller: phonePrefixController,
                            focusBorderColor: isEdited
                                ? AppColors.focusTextBoarder
                                : Theme.of(context).brightness == Brightness.dark
                          ? AppColors.headingTextColor
                          : AppColors.appbarBoarder,
                            fillColor: isEdited
                                ?  AppColors.darkTextInput
                          
                                : Colors.transparent,
                            boarderColor: isEdited
                                ? AppColors.transparent
                                : Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkAppBarboarder
                          : AppColors.appbarBoarder,
                            color: isEdited
                                ? AppColors.textInputField
                                : Colors.transparent,
                            hintColor: isEdited
                                ? AppColors.hintColor
                                :  Theme.of(context).brightness == Brightness.dark
                          ? AppColors.profileDarkText
                          : AppColors.subheadColor,
                            hint: isEdited ? "+973 " : prefPhone,
                            obscure: false,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            editable: false,
                          ):TextFieldNonEditable(
                            width: MediaQuery.of(context).size.width / 5.5,
                            focusNode: _focusNode,
                            controller: phonePrefixController,
                            focusBorderColor: isEdited
                                ? AppColors.focusTextBoarder
                                : Theme.of(context).brightness == Brightness.dark
                          ? AppColors.headingTextColor
                          : AppColors.appbarBoarder,
                            fillColor: isEdited
                                ? Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextInput
                          : AppColors.textInputField
                                : Colors.transparent,
                            boarderColor: isEdited
                                ? AppColors.transparent
                                : Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkAppBarboarder
                          : AppColors.appbarBoarder,
                            color: isEdited
                                ? AppColors.textInputField
                                : Colors.transparent,
                            hintColor: isEdited
                                ? AppColors.hintColor
                                :  Theme.of(context).brightness == Brightness.dark
                          ? AppColors.profileDarkText
                          : AppColors.subheadColor,
                            hint: isEdited ? "+973 " : prefPhone,
                            obscure: false,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            editable: false,
                          ),
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
                            hint: isEdited ? "Phone Number " : phoneNum,
                            obscure: false,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            editable: isEdited,
                          ),
                        ),*/
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isEdited
                        ? const SizedBox()
                        : Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 20, bottom: 20),
                              child: Text(
                                gen,
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.profileDarkText
                                      : AppColors.subheadColor,
                                  fontSize: 16,
                                  fontFamily: FontFamily.satoshi,
                                  fontWeight: FontWeight.w400,
                                  height: 24 / 16,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkAppBarboarder
                                      : AppColors.appbarBoarder,
                                )),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    isEdited
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected = true;
                              });
                              setState(() {
                                isSelected = true;
                              });
                              if (isSelected == true) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => changePaasword(),
                                ).whenComplete(() {
                                  setState(() {
                                    isSelected = false;
                                  });
                                });
                              }
                            },
                            child: Container(
                              height: 56,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkTextInput
                                      : AppColors.textInputField,
                                  border: Border.all(
                                      color: isSelected == true
                                          ? AppColors.focusTextBoarder
                                          : borderColor,
                                      width: 1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                   (AppLocalizations.of(context)!.changePass),
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.profileDarkText
                                          : AppColors.subheadColor,
                                      fontSize: 16,
                                      fontFamily: FontFamily.satoshi,
                                      fontWeight: FontWeight.w400,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    icon: languageNotifier.appLocale == Locale("ar")?Transform.flip(
                                      flipX: true,
                                      child: Image.asset(
                                        "assets/images/Right.png",
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.profileDarkText
                                            : AppColors.subheadColor,
                                        //width: 18,
                                        height: 24,
                                      ),
                                    ):Image.asset(
                                      "assets/images/Right.png",
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.profileDarkText
                                          : AppColors.subheadColor,
                                      //width: 18,
                                      height: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ),
            );
          }
        }));
  }

  Widget changePaasword() {
    final languageNotifier = context.watch<LanguageChangeController>();
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.9,
      minChildSize: 0.45,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            // Dismiss the keyboard by unfocusing the current focus.
            FocusScope.of(_).unfocus();
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: PasswordChangeScreen(email: ""))),
        ),
      ),
    );
  }

  Widget _buildChangePassText() {
    return Row(
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
        const Spacer(),
        Text(
          "Change Password ",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.headingTextColor
                : AppColors.allHeadColor,
            fontSize: 20,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w700,
            height: 28 / 20,
          ),
        ),
        const Spacer(flex: 2)
      ],
    );
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
                        color: Colors.transparent,
                        border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Color(0xff2CC36B)
                                    : AppColors.confirmValid),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookCount,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Color(0xff2CC36B)
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
(AppLocalizations.of(context)!.totalNo),
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color(0xff4CBC7B)
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
                              (AppLocalizations.of(context)!.bookings),
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color(0xff4CBC7B)
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
                        color: Colors.transparent,
                        border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Color(0xffEE6E6E)
                                    : AppColors.errorColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cancelBook,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Color(0xffEE6E6E)
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
                            (AppLocalizations.of(context)!.cancelledBooking),
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color(0xffEE7474)
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
                              (AppLocalizations.of(context)!.bookings),
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color(0xffEE7474)
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: FocusScope(
          // Manage keyboard focus
          child: Consumer<SignInProvider>(builder: (context, value, child) {
            void loginButtonPressed() async {
              FocusManager.instance.primaryFocus?.unfocus();
              SharedPreferences pref = await SharedPreferences.getInstance();
              setState(() {
                loginError = false;
              });

              setState(() {
                isLoading = true;
              });
              value
                  .updateProfile(
                      tokens!,
                      nameController.text,
                      phoneController.text,
                      phonePrefixController.text,
                      false,
                      imageFile?.path ?? null)
                  .then((val) {
                if (val != null && val["statusCode"] == 200) {
                  profile();
                  setState(() {
                    isEdited = false;
                    isLoading = false;
                  });
                } else {
                  setState(() {
                    if (val != null) {
                      loginError = true;
                      AnimatedToast.showToastMessage(
                        context,
                        val["errorMessage"][0],
                        const Color.fromRGBO(87, 87, 87, 0.93),
                      );
                    }
                    isLoading = false;
                  });
                }
              });
            }

            return CustomElevatedButton(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              isLoading: isLoading,
              text: "Update Profile",
              onPressed:
                  passwordError & emailError ? () {} : loginButtonPressed,
              buttonColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkEditColor
                  : AppColors.elevatedColor,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.allHeadColor
                  : Colors.white,
            );
          }),
        ),
      ),
    );
  }

  // General Methods:-----------------------------------------------------------

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _focusNode.dispose();

    _passwordFocusNode.dispose();
    super.dispose();
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                        height: 135,
                        color: const Color(0xffF3F3F3),
                        padding: const EdgeInsets.all(16.0),
                        child:
                            Center(child: Icon(Icons.browse_gallery_outlined))),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: 135, // Adjust the height as needed
                  width: 1, // Adjust the width as needed
                  color: Colors.black,
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                        height: 135,
                        color: const Color(0xffF3F3F3),
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Icon(Icons.camera))),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
