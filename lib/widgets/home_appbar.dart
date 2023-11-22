import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/notifications/notification_screen.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/funky_overlay.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBoarder;
  final bool isProgress;
  final int step;
  final bool isFormDone;

  const HomeAppBar(
      {Key? key,
      required this.title,
      required this.isBoarder,
      required this.isProgress,
      required this.step, required this.isFormDone})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeModeNotifier>();
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
      child: Container(
        color: Colors.white,
        height: 90,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150.0),
                    child: const SilentErrorImage(
                      width: 48.0,
                      height: 48.0,
                      imageUrl:
                          'https://upload.wikimedia.org/wikipedia/commons/f/f9/Phoenicopterus_ruber_in_S%C3%A3o_Paulo_Zoo.jpg',
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Text(
                  "Hello",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.headingTextColor
                        : AppColors.allHeadColor,
                    fontFamily: FontFamily.satoshi,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 24 / 16,
                  ),
                ),
              ),
             isFormDone? SizedBox(
                            height: 34,
                            child: OutlinedButton(
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                String? email = await SharePref.fetchEmail();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterForm(email: email!),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.errorback,
                                foregroundColor: AppColors.errorColor,
                                side: BorderSide(color: AppColors.errorColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
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
                          ):SizedBox(),
              GestureDetector(
                onTap: () {
                  showAlertDialog(context);
                  /*Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  NotificationScreen()));*/
                },
                child: Image.asset(
                  "assets/images/notification1.png",
                  height: 25,
                ),
              )
              /*GestureDetector(
                child: themeNotifier.themeMode == ThemeMode.dark
                    ? Icon(Icons.sunny,
                        color: Colors.white) // Show "sunny" icon in dark mode
                    : Icon(Icons.star,
                        color:
                            Colors.black), // Show "star" icon in light mode
                onTap: () {
                  final newMode = themeNotifier.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                  themeNotifier.setThemeMode(newMode);
                },
              ),*/
            ],
          ),
        ),
      ),
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
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Return an empty container (or any other widget) to silently handle errors
        return SizedBox(width: width, height: height);
      },
    );
  }
}
