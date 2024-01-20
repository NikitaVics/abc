// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/api/api.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/constants/shimmer.dart';
import 'package:tennis_court_booking_app/model/friendShow/friend_show_model.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';

import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/profile/model/allfriend_model.dart';
import 'package:tennis_court_booking_app/profile/model/allfriend_request_model.dart';
import 'package:tennis_court_booking_app/profile/passwardChange/password_change.dart';
import 'package:tennis_court_booking_app/profile/profileThings/addfriend_screen.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/allfriend_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/allfriendrequest_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/myprofile_provider.dart';

import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_noneditable.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class MyTeamsScreen extends StatefulWidget {
  final String pageName;
  const MyTeamsScreen({super.key, required this.pageName});

  @override
  MyTeamsScreenState createState() => MyTeamsScreenState();
}

class MyTeamsScreenState extends State<MyTeamsScreen> {
  //text controllers:-----------------------------------------------------------

  bool isLoading = false;
  //predefine bool value for error:---------------------------------------------
  
  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  bool isFirstButtonSelected = false;
  bool isSecondButtonSelected = false;
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

    isFirstButtonSelected = true;
    profile();
    frined();
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
  bool isLoad = false;
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

  Future<void> frined() async {
    final myFriendProvider =
        Provider.of<MyFriendProvider>(context, listen: false);
    final myFriendRequestProvider =
        Provider.of<MyFriendRequestProvider>(context, listen: false);

    setState(() {
      isLoad = true;
    });
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    myFriendProvider.fetchFrined(token);
    myFriendRequestProvider.fetchFrined(token);

    print(name);
    setState(() {
      isLoad = false;
    });
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
                        const Spacer(),
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
                        const Spacer(flex: 2)
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
                    //isEdited ? _buildSignInButton() : SizedBox()
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: _buildRightSide()),
                    _buildSignInButton()
                    //isEdited ? _buildSignInButton() : SizedBox()
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildRightSide() {
    return Padding(
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
                  _buildBookingButton(),
                  isFirstButtonSelected
                      ? Consumer<MyFriendProvider>(
                          builder: (context, provider, child) {
                            final myFriendData = provider.myFriend;
                            if (provider.myFriend == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              List<MyFriend> allfriend = myFriendData!.result;

                              return Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: allfriend.length,
                                  itemBuilder: (context, index) {
                                    return _friendsWidget(index,
                                        allfriend.length, allfriend[index]);
                                  },
                                ),
                              );
                            }
                          },
                        )
                      : Consumer<MyFriendRequestProvider>(
                          builder: (context, provider, child) {
                            final myFriendData = provider.myFriend;
                            if (provider.myFriend == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              List<MyFriendRequest> allfriend =
                                  myFriendData!.result;

                              return Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: allfriend.length,
                                  itemBuilder: (context, index) {
                                    return _friendRequestWidget(index,
                                        allfriend.length, allfriend[index]);
                                  },
                                ),
                              );
                            }
                          },
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            }
          },
        ));
  }

  Widget _buildLoginText() {
    return Padding(
        padding: const EdgeInsets.only(top: 28),
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
                  Text(
                    "Member from",
                    style: TextStyle(
                      color: AppColors.dotColor,
                      fontSize: 14,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w400,
                      height: 24 / 14,
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

  Widget _buildBookingButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                // width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFirstButtonSelected = true;
                      isSecondButtonSelected = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFirstButtonSelected
                        ? AppColors.elevatedColor
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: isFirstButtonSelected
                                ? Colors.transparent
                                : AppColors.bookingInvalid)),
                  ),
                  child: Text(
                    'My Friends',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isFirstButtonSelected
                          ? Colors.white
                          : AppColors.bookingInvalid,
                      fontSize: 12,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w700,
                      height: 24 / 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 40,
                // width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFirstButtonSelected = false;
                      isSecondButtonSelected = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSecondButtonSelected
                        ? AppColors.elevatedColor
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: isSecondButtonSelected
                                ? Colors.transparent
                                : AppColors.bookingInvalid)),
                  ),
                  child: Text('Requests',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSecondButtonSelected
                            ? Colors.white
                            : AppColors.bookingInvalid,
                        fontSize: 12,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w700,
                        height: 24 / 12,
                      )),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _friendsWidget(int index, int itemCount, MyFriend? myfriend) {
    Color borderColor = AppColors.appbarBoarder;
    final themeNotifier = context.watch<ThemeModeNotifier>();
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 48,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(110.0),
                    child: SilentErrorImage(
                      width: 48.0,
                      height: 48.0,
                      imageUrl: myfriend?.friendImageUrl ??
                          'assets/images/ProfileImage.png',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      myfriend?.friendName ?? " ",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.headingTextColor
                            : AppColors.allHeadColor,
                        fontSize: 16,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      int response =
                          await Api.deleteFriend(tokens!, myfriend!.friendId);
                          await frined();
                        response==200?  
                      MotionToast(
                        primaryColor: AppColors.dotColor,
                        description: Text(
                         "Account Removed Successfully!",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.allHeadColor,
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        icon: Icons.warning,
                        animationCurve: Curves.bounceInOut,
                      ).show(context): MotionToast(
                        primaryColor: AppColors.errorColor,
                        description: Text(
                         "Something went wrong!",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.allHeadColor,
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        icon: Icons.warning,
                        animationCurve: Curves.bounceInOut,
                      ).show(context);
                    },
                    child: Image.asset(
                      "assets/images/Delete.png",
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _friendRequestWidget(
      int index, int itemCount, MyFriendRequest? myfriend) {
    Color borderColor = AppColors.appbarBoarder;
    final themeNotifier = context.watch<ThemeModeNotifier>();
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 48,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(110.0),
                    child: SilentErrorImage(
                      width: 48.0,
                      height: 48.0,
                      imageUrl: myfriend?.friendImageUrl ??
                          'assets/images/ProfileImage.png',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      myfriend?.friendName ?? " ",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.headingTextColor
                            : AppColors.allHeadColor,
                        fontSize: 16,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      print(myfriend!.friendId);
                      String response = await Api.rejectFriendRequest(
                          tokens!, myfriend.friendId);
                          await frined();
                      MotionToast(
                        primaryColor: AppColors.dotColor,
                        description: Text(
                          response,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.allHeadColor,
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        icon: Icons.warning,
                        animationCurve: Curves.bounceInOut,
                      ).show(context);
                    },
                    child: Container(
                      height: 36,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: AppColors.errorColor, width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Reject',
                              style: TextStyle(
                                color: AppColors.errorColor,
                                fontSize: 12,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String response = await Api.acceptFriendRequest(
                          tokens!, myfriend!.friendId);
                      await frined();
                      MotionToast(
                        primaryColor: AppColors.dotColor,
                        description: Text(
                          response,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.headingTextColor
                                    : AppColors.allHeadColor,
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        icon: Icons.warning,
                        animationCurve: Curves.bounceInOut,
                      ).show(context);
                    },
                    child: Container(
                      height: 36,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: AppColors.confirmValid, width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Accept',
                              style: TextStyle(
                                color: AppColors.confirmValid,
                                fontSize: 12,
                                fontFamily: FontFamily.satoshi,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget changePaasword() {
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
                color: Colors.pink,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: PasswordChangeScreen(email: ""))),
        ),
      ),
    );
  }

   Widget _buildSignInButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: FocusScope(
          // Manage keyboard focus
          child: CustomElevatedButton(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              isLoading: isLoading,
              text: "Add Friends",
              onPressed: ()
              {
 Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddFriendScreen(
                                    pageName: "Add Friends",
                                  )));
              },
              buttonColor: AppColors.elevatedColor,
              textColor: Colors.white,
            )
        ),
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
