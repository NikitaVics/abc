import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/coach_show_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/complete_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/confirm_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/court_info_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/friend_show_provider.dart';
import 'package:tennis_court_booking_app/mybookings/provider/previous_booking_provider.dart';
import 'package:tennis_court_booking_app/mybookings/provider/upComing_provider.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/courtshowprovider.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/allfriend_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/allfriendrequest_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/myprofile_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/search_provider.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'package:tennis_court_booking_app/splash/splash_screen.dart';

import 'package:tennis_court_booking_app/theme/theme_manager.dart';
//Tenis App
void main() {
   WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
     statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black, // Set the desired color here
     systemNavigationBarIconBrightness:Brightness.dark, 
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
     
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
   return MultiProvider(
      providers: [
        
        ChangeNotifierProvider<SignInProvider>(
          create: (context) => SignInProvider(),
        ),
        ChangeNotifierProvider<CourtShowProvider>(
          create: (context) => CourtShowProvider(),
        ),
         ChangeNotifierProvider<CheckStatusProvider>(
          create: (context) => CheckStatusProvider(),
        ),
         ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<BookingResponseProvider>(
          create: (context) => BookingResponseProvider(),
        ),
        ChangeNotifierProvider<FreindShowProvider>(
          create: (context) =>FreindShowProvider(),
        ),
        ChangeNotifierProvider<CoachShowProvider>(
          create: (context) =>CoachShowProvider(),
        ),
         ChangeNotifierProvider<ThemeModeNotifier>(
          create: (context) =>ThemeModeNotifier(initialThemeMode: ThemeMode.light),
        ),
         ChangeNotifierProvider<CourtInfoProvider>(
          create: (context) =>CourtInfoProvider(),
        ),
                 ChangeNotifierProvider<CompleteBookingProvider>(
          create: (context) =>CompleteBookingProvider(),
        ),
          ChangeNotifierProvider<BookResultShowProvider>(
          create: (context) =>BookResultShowProvider(),
        ),
        ChangeNotifierProvider<MyProfileProvider>(
          create: (context) =>MyProfileProvider(),
        ),
        ChangeNotifierProvider<UpcomingBookProvider>(
          create: (context) =>UpcomingBookProvider(),
        ),
         ChangeNotifierProvider<PreviousBookProvider>(
          create: (context) =>PreviousBookProvider(),
        ),
         ChangeNotifierProvider<MyFriendProvider>(
          create: (context) =>MyFriendProvider(),
        ),
          ChangeNotifierProvider<MyFriendRequestProvider>(
          create: (context) =>MyFriendRequestProvider(),
        ),
         ChangeNotifierProvider<SearchProvider>(
          create: (context) =>SearchProvider(),
        ),
       ],
       child:Builder(
        builder: (context) {
          final themeMode = context.watch<ThemeModeNotifier>().themeMode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: SplashScreen(),
          );
        },
      ),);
  }
}

