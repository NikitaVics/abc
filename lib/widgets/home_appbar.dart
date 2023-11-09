import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBoarder;
  final bool isProgress;
  final int step;

  const HomeAppBar(
      {Key? key,
      required this.title,
      required this.isBoarder,
      required this.isProgress,
      required this.step})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeModeNotifier>();
    return Padding(
      padding:  const EdgeInsets.only(top: 12,left: 24,right: 24),
      child: Container(
        color: Colors.white,
        height: 90,
      
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child:ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150.0),
                                        child: const SilentErrorImage(
                                          width: 48.0,
                                          height: 48.0,
                                          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f9/Phoenicopterus_ruber_in_S%C3%A3o_Paulo_Zoo.jpg',
        
                                        ),
                                      )
              ),
             Padding(
              padding: const EdgeInsets.only(left: 20,right: 10),
                child: Text(
                      "Hello",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.headingTextColor
                            : AppColors.allHeadColor,
                        fontFamily: FontFamily.satoshi,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24/ 16,
                      ),
                    ),
              ),
              SizedBox(
                height: 34,
                child: OutlinedButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                  String? email = pref.getString('email');
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RegisterForm(email:email! ),
                ),
              );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.errorback,
              foregroundColor: AppColors.errorColor, side: BorderSide(color: AppColors.errorColor),
                      
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              ),
              ),
              child: const Text('Complete profile',
              style:  TextStyle( 
                                  fontFamily: FontFamily.satoshi,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 24/ 14,),),
              ),
              ),
              
              Image.asset("assets/images/notification1.png",
              height: 25,)
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
}
class SilentErrorImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const SilentErrorImage({
    super.key,
    required this.imageUrl,
    this.width =48.0,
    this.height =48.0,
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
