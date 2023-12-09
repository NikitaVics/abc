import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/courtshowprovider.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
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
         ChangeNotifierProvider<ThemeModeNotifier>(
          create: (context) =>ThemeModeNotifier(initialThemeMode: ThemeMode.light),
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

