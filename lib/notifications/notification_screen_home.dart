import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/language/provider/language_change_controller.dart';
import 'package:tennis_court_booking_app/notifications/notification_model.dart';
import 'package:tennis_court_booking_app/notifications/provider/notification_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/search_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreenForHome extends StatefulWidget {
  final String pageName;
  const NotificationScreenForHome({super.key, required this.pageName});

  @override
  NotificationScreenForHomeState createState() => NotificationScreenForHomeState();
}

class NotificationScreenForHomeState extends State<NotificationScreenForHome> {
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
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
    notificationProvider.fetchNotification(token);

    print(name);
  }

  final List<int> selectedFriend = [];
  final List<String> selectedFriendImage = [];
  final List<String> selectedFriendName = [];

  bool isEdited = false;
  @override
  Widget build(BuildContext context) {
    final languageNotifier = context.watch<LanguageChangeController>();
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
                          icon: languageNotifier.appLocale == Locale("ar")
                              ? Transform.flip(
                                  flipX: true,
                                  child: Image.asset(
                                    "assets/images/leftIcon.png",
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.headingTextColor
                                        : AppColors.profileHead,
                                    //width: 18,
                                    height: 26,
                                  ),
                                )
                              : Image.asset(
                                  "assets/images/leftIcon.png",
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.headingTextColor
                                      : AppColors.profileHead,
                                  //width: 18,
                                  height: 26,
                                ),
                        ),
                        const Spacer(),
                        Text(
                         (AppLocalizations.of(context)!.notification),
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
    child: Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        if (provider.notificationModel == null) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkEditColor
                  : AppColors.dotColor,
            ),
          );
        } else {
          final noticeData = provider.notificationModel!;
          List<Notifications> notice = noticeData.result;

          // Filter notifications within the last 7 days
          List<Notifications> last7DaysNotifications = notice.where((notification) {
            DateTime notificationDate = DateTime.parse(notification.creationDate);
            Duration difference = DateTime.now().difference(notificationDate);
            return difference.inDays <= 7;
          }).toList();

          // Filter notifications within the last 30 days
          List<Notifications> last30DaysNotifications = notice.where((notification) {
            DateTime notificationDate = DateTime.parse(notification.creationDate);
            Duration difference = DateTime.now().difference(notificationDate);
            return difference.inDays <= 30;
          }).toList();

          return ListView(
            children: [
              _buildNotificationColumn( (AppLocalizations.of(context)!.last7Days), last7DaysNotifications),
              _buildNotificationColumn((AppLocalizations.of(context)!.last30Days), last30DaysNotifications),
              SizedBox(height: 20),
            ],
          );
        }
      },
    ),
  );
}

Widget _buildNotificationColumn(String title, List<Notifications> notifications) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          title,
         style: TextStyle(
                            color:  Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSubHead
          : AppColors.allHeadColor,
                            fontSize: 18,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w700,
                            height: 24 / 18,
                          ),
        ),
      ),
      Column(
        children: notifications.map((notification) {
          return _notificationsWidget(notification );
        }).toList(),
      ),
    ],
  );
}

  Widget _notificationsWidget(Notifications notification) {
    final languageNotifier = context.watch<LanguageChangeController>();
 
  String? imageUrl = notification.imageUrl;
  Color _getNotificationTitleColor(String title) {
  if (title.contains("Successfull") || title.contains("Confirmed")) {
    return AppColors.successColor;
  } else if (title.contains("alert")) {
    return AppColors.warningToast;
  } else if (title.contains("Cancellation")) {
    return AppColors.errorColor;
  } else {
    return AppColors.requestedfriend; // Default color if none of the conditions are met
  }
}

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                languageNotifier.appLocale == Locale("en")?
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "${notification.title} - "??"",
                          style: TextStyle(
                            color:_getNotificationTitleColor(notification.title),
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w500,
                            height: 24 / 16,
                          ),
                        ),
                        TextSpan(
                          text:
                              notification.notificationBody, // The first half of the sentence
                          style: TextStyle(
                            color:  Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSubHead
          : AppColors.subheadColor,
                            fontSize: 16,
                            fontFamily: FontFamily.satoshi,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ):
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "${notification.title} - "??"",
                    
                            style: TextStyle(
                              
                              color:_getNotificationTitleColor(notification.title),
                              fontSize: 16,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                    
                            ),
                          ),
                          TextSpan(
                            text:
                                notification.notificationBody, // The first half of the sentence
                            style: TextStyle(
                              color:  Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSubHead
                              : AppColors.subheadColor,
                              fontSize: 16,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w400,
                              height: 24 / 16,
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
          (BuildContext context, Object error, StackTrace? stackTrace) {
        // Handle the error, e.g., display a placeholder image
        return Theme.of(context).brightness == Brightness.dark
            ? Image.asset(
                "assets/images/darkavat.png",
                width: width,
                height: height,
              )
            : Image.asset(
                "assets/images/userTeam.png",
                width: width,
                height: height,
              );
      },
    );
  }
}
