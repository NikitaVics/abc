import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/search_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';

class NotificationScreen extends StatefulWidget {
  final String pageName;
  const NotificationScreen({super.key, required this.pageName});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _searchController = TextEditingController();
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

  bool isLoad = false;
  Future<void> profile() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    searchProvider.fetchSearch(token, _searchController.text);

    print(name);
  }

  final List<int> selectedFriend = [];
  final List<String> selectedFriendImage = [];
  final List<String> selectedFriendName = [];

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return _notificationsWidget(index, 10);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget _notificationsWidget(int index, int itemCount) {
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
                      imageUrl: 'assets/images/ProfileImage.png',
                    ),
                  ),
                  SizedBox(
                    width: 19,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "No Recent Bookings  ",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
