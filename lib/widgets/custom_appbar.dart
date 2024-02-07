import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:tennis_court_booking_app/widgets/step_progress_indicator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBoarder;
  final bool isProgress;
  final int step;
  final bool isIcon;

  const CustomAppBar(
      {Key? key,
      required this.title,
      required this.isBoarder,
      required this.isProgress,
      required this.step, required this.isIcon})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeModeNotifier>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
              bottom: isBoarder
                  ? BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkAppBarboarder
                          : AppColors.appbarBoarder,
                      width: 1.0,
                    )
                  : BorderSide.none,
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isIcon
?                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: Image.asset(
                    "assets/images/leftIcon.png",
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.headingTextColor
                        : AppColors.profileHead,
                    //width: 18,
                    height: 26,
                  ),
                ):SizedBox(),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.headingTextColor
                            : AppColors.allHeadColor,
                        fontFamily: FontFamily.satoshi,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 32 / 20,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: themeNotifier.themeMode == ThemeMode.dark
                      ? Image.asset(
                          "assets/images/sun.png",
                          height: 23,
                        ) // Show "sunny" icon in dark mode
                      : Image.asset(
                          "assets/images/moon.png",
                          height: 23,
                        ), // Show "star" icon in light mode
                  onTap: () {
                    final newMode = themeNotifier.themeMode == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
                    themeNotifier.setThemeMode(newMode);
                  },
                ),
              ],
            ),
          ),
        ),
        isProgress ? ExampleStepProgressIndicator(step: step) : SizedBox(),
      ],
    );
  }
}
