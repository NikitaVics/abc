import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBoarder;

  const CustomAppBar({Key? key, required this.title, required this.isBoarder})
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
                  ? const BorderSide(
                      color: AppColors.appbarBoarder,
                      width: 2.0,
                    )
                  : BorderSide.none,
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        :AppColors.allHeadColor,
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
      ? Icon(Icons.sunny, color: Colors.white) // Show "sunny" icon in dark mode
      : Icon(Icons.star, color: Colors.black), // Show "star" icon in light mode
  onTap: () {
    final newMode = themeNotifier.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeNotifier.setThemeMode(newMode);
  },
),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
