import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/announcement/model/announcement_model.dart';
import 'package:tennis_court_booking_app/announcement/provider/announcement_provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:intl/intl.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  AnnouncementScreenState createState() => AnnouncementScreenState();
}

class AnnouncementScreenState extends State<AnnouncementScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------

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

    profile();
  }

  bool isFormDone = false;
  String name = "";
  String? tokens;
  Future<void> profile() async {
    final announcementProvider =
        Provider.of<AnnouncementProvider>(context, listen: false);

    announcementProvider.fetchAnnouncement();
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
                "Announcement",
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
      child: Consumer<AnnouncementProvider>(
        builder: (context, provider, child) {
          if (provider.announcementModel == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final announceData = provider.announcementModel!;
            List<Announcement> announce = announceData.result;
            DateFormat dateFormat = DateFormat("dd MMM, yyyy");

            // Filter announcements based on scheduled date
            List<Announcement> filteredAnnouncements =
                announce.where((announcement) {
              DateTime scheduledDateTime =
                  dateFormat.parse(announcement.scheduledDate);
              return scheduledDateTime.isAfter(DateTime.now());
            }).toList();
            String name = announce[1].scheduledDate;
            print(name);
            //imageUrl = profileData.result.imageUrl;
            //name = profileData.result.name ?? "";
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var announcement in filteredAnnouncements)
                  _buildAnnouncementItem(announcement),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          }
        },
      ),
    ));
  }
  /*Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            if (provider.profileModel == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final profileData = provider.profileModel!;
              imageUrl = profileData.result.imageUrl;
              name = profileData.result.name ?? "";
              return  Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child:  _buildCourtMaintanance()),
                SizedBox(height: 12,),
               _buildEventMaintanance(),
                SizedBox(
                  height: 20,
                ),
              ],
            )
            }
          },
        ),*/

  Widget _buildAnnouncementItem(Announcement announcement) {
    String announcementType = announcement.announcementType;

    if (announcementType == 'CourtMaintenance') {
      return _buildCourtMaintanance(announcement);
    } else {
      return _buildEventMaintanance(announcement);
    }
  }

  Widget _buildCourtMaintanance(Announcement announcement) {
    return Padding(
        padding: const EdgeInsets.only(top: 23),
        child: Center(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.announceDate,
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 3, bottom: 3, left: 9, right: 9),
                      child: Text(
                        announcement.scheduledDate,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.booklight
                              : AppColors.subheadColor,
                          fontSize: 12,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    "12:08 PM",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.booklight
                          : AppColors.subheadColor,
                      fontSize: 9,
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Court Maintenance",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.booklight
                            : AppColors.allHeadColor,
                        fontSize: 18,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w700,
                        height: 24 / 18),
                  ),
                  SizedBox(
                    height: 380,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.58,
                          mainAxisSpacing: 16.34 // Two containers per row
                          ),
                      itemCount: 10, // Total number of containers
                      itemBuilder: (BuildContext context, int index) {
                        String containImage = index % 2 == 0
                            ? "assets/images/Shape33.png"
                            : "assets/images/Shape34.png";
                        return Container(
                          height: 125.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.booklight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(7.01),
                                child: Image.asset(containImage),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 7.01, top: 6.79),
                                  child: Text(
                                    "Court $index",
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.booklight
                                            : AppColors.allHeadColor,
                                        fontSize: 15,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w700,
                                        height: 19 / 15),
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 39.34),
                  Divider(
                    color: AppColors.appbarBoarder,
                    thickness: 1,
                  )
                ]),
          ),
        ));
  }

  Widget _buildEventMaintanance(Announcement announcement) {
    DateFormat dateFormat = DateFormat("dd MMM, yyyy");
    DateTime scheduledDateTime = dateFormat.parse(announcement.scheduledDate);
    String formattedDate = DateFormat("MMM dd, EEE -yyyy").format(scheduledDateTime);

  print(formattedDate);
    return Padding(
        padding: const EdgeInsets.only(top: 23),
        child: Center(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.announceDate,
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 3, bottom: 3, left: 9, right: 9),
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.booklight
                              : AppColors.subheadColor,
                          fontSize: 12,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    announcement.scheduledTime,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.booklight
                          : AppColors.subheadColor,
                      fontSize: 9,
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Event Announcement",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.booklight
                            : AppColors.allHeadColor,
                        fontSize: 18,
                        fontFamily: FontFamily.satoshi,
                        fontWeight: FontWeight.w700,
                        height: 24 / 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 325,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24, left: 23.37, right: 23.37),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name".toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.booklight
                                            : AppColors.dotColor,
                                        fontSize: 10,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w500,
                                        height: 16 / 10),
                                  ),
                                  SizedBox(
                                    height: 2.81,
                                  ),
                                  Text(
                                  announcement.announcementType,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.booklight
                                            : AppColors.subheadColor,
                                        fontSize: 13,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w500,
                                        height: 19 / 13),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date".toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.booklight
                                            : AppColors.dotColor,
                                        fontSize: 10,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w500,
                                        height: 16 / 10),
                                  ),
                                  SizedBox(
                                    height: 2.81,
                                  ),
                                  Text(
                                    announcement.scheduledDate,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.booklight
                                            : AppColors.subheadColor,
                                        fontSize: 13,
                                        fontFamily: FontFamily.satoshi,
                                        fontWeight: FontWeight.w500,
                                        height: 19 / 13),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 23.37, right: 23.37),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Time".toUpperCase(),
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.booklight
                                        : AppColors.dotColor,
                                    fontSize: 10,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w500,
                                    height: 16 / 10),
                              ),
                              SizedBox(
                                height: 2.81,
                              ),
                              Text(
                               announcement.scheduledTime,
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.booklight
                                        : AppColors.subheadColor,
                                    fontSize: 13,
                                    fontFamily: FontFamily.satoshi,
                                    fontWeight: FontWeight.w500,
                                    height: 19 / 13),
                              )
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 23, right: 23),
                            child: Container(
                              height: 49,
                              child: SingleChildScrollView(
                                child: Text(
                                 announcement.message,
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.booklight
                                          : AppColors.subheadColor,
                                      fontSize: 13,
                                      fontFamily: FontFamily.satoshi,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      height: 19 / 13),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 19, left: 23, bottom: 24, right: 22),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                    height: 85,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                            "assets/images/Shape33.png"))),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: SizedBox(
                                    height: 85,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                            "assets/images/Shape34.png"))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 39.34),
                  Divider(
                    color: AppColors.appbarBoarder,
                    thickness: 1,
                  )
                ]),
          ),
        ));
  }

  Widget _buildProfilePerfomence() {
    final themeNotifier = context.watch<ThemeModeNotifier>();
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
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Column(
                children: [],
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
