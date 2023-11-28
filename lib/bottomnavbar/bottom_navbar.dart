import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/home/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: const <Widget>[
            HomeScreen(),
            HomeScreen(),
            HomeScreen(),
            HomeScreen()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: NavBarItem(
                  NavBarIcon: Image.asset(
                    'assets/images/homeNavIcon.png',
                    width: 24, // Set the width of the icon image
                    height: 24,
                    color: _selectedIndex == 0
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                  ),
                  NavBarLavel: "Home",
                  NavIconColor:_selectedIndex == 0
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: NavBarItem(
                  NavBarIcon: Image.asset(
                    'assets/images/bookingsNavIcon.png',
                    width: 25, // Set the width of the icon image
                    height: 25,
                    color: _selectedIndex == 1
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                  ),
                  NavBarLavel: "Bookings",
                    NavIconColor:_selectedIndex == 1
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: NavBarItem(
                  NavBarIcon: Image.asset(
                    'assets/images/clubinfoIcon.png',
                    width: 25, // Set the width of the icon image
                    height: 25,
                    color: _selectedIndex == 2
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                  ),
                  NavBarLavel: "Club Infos",
                    NavIconColor:_selectedIndex == 2
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: NavBarItem(
                  NavBarIcon: Image.asset(
                    'assets/images/profileNavBar.png',
                    width: 25, // Set the width of the icon image
                    height: 25,
                    color: _selectedIndex == 3
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                  ),
                  NavBarLavel: "Accounts",
                    NavIconColor:_selectedIndex == 3
                        ? AppColors.navIconColor
                        : AppColors.disableNavIconColor,
                ),
                label: '',
              ),
             
            ],
            backgroundColor: const Color(0xFFffffff),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            // selectedItemColor: Color(0xff41FFF4),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
            elevation: 1),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables

  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  final NavBarIcon;
  final String NavBarLavel;
  final Color NavIconColor;
  const NavBarItem(
      // ignore: non_constant_identifier_names
      {super.key,
      // ignore: non_constant_identifier_names
      required this.NavBarIcon,
      required this.NavBarLavel, required this.NavIconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NavBarIcon,
        Text(
          NavBarLavel,
          style:  TextStyle(
            color: NavIconColor,
            fontSize: 10,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w500,
            height: 24/9,
          ),
        )
      ],
    );
  }
}
