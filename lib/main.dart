import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/announcement/provider/announcement_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/coach_show_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/complete_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/confirm_booking_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/court_info_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/friend_show_provider.dart';
import 'package:tennis_court_booking_app/bookingprocess/teamselect/provider/repeat_friend_provider.dart';
import 'package:tennis_court_booking_app/language/provider/language_change_controller.dart';
import 'package:tennis_court_booking_app/mybookings/provider/previous_booking_provider.dart';
import 'package:tennis_court_booking_app/mybookings/provider/upComing_provider.dart';
import 'package:tennis_court_booking_app/notifications/provider/notification_provider.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/check_status.dart';
import 'package:tennis_court_booking_app/presentation/home/home_provider/courtshowprovider.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/allfriend_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/allfriendrequest_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/myprofile_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profileCreate_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/profile_provider.dart';
import 'package:tennis_court_booking_app/profile/profileprovider/search_provider.dart';
import 'package:tennis_court_booking_app/provider/booking_response_provider.dart';
import 'package:tennis_court_booking_app/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Tenis App
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black, // Set the desired color here
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String languageCode = sp.getString('language_code') ?? '';
  print(languageCode);
  runApp(MyApp(
    locale: languageCode,
  ));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class MyApp extends StatefulWidget {
  final String locale;
  const MyApp({super.key, required this.locale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageChangeController()),
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
          create: (context) => FreindShowProvider(),
        ),
        ChangeNotifierProvider<CoachShowProvider>(
          create: (context) => CoachShowProvider(),
        ),
        ChangeNotifierProvider<ThemeModeNotifier>(
          create: (context) =>
              ThemeModeNotifier(initialThemeMode: ThemeMode.light),
        ),
        ChangeNotifierProvider<CourtInfoProvider>(
          create: (context) => CourtInfoProvider(),
        ),
        ChangeNotifierProvider<CompleteBookingProvider>(
          create: (context) => CompleteBookingProvider(),
        ),
        ChangeNotifierProvider<BookResultShowProvider>(
          create: (context) => BookResultShowProvider(),
        ),
        ChangeNotifierProvider<MyProfileProvider>(
          create: (context) => MyProfileProvider(),
        ),
        ChangeNotifierProvider<UpcomingBookProvider>(
          create: (context) => UpcomingBookProvider(),
        ),
        ChangeNotifierProvider<PreviousBookProvider>(
          create: (context) => PreviousBookProvider(),
        ),
        ChangeNotifierProvider<MyFriendProvider>(
          create: (context) => MyFriendProvider(),
        ),
        ChangeNotifierProvider<MyFriendRequestProvider>(
          create: (context) => MyFriendRequestProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider<AnnouncementProvider>(
          create: (context) => AnnouncementProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider<ProfileCreateProvider>(
          create: (context) => ProfileCreateProvider(),
        ),
        ChangeNotifierProvider<RepeatFreindShowProvider>(
          create: (context) => RepeatFreindShowProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.watch<ThemeModeNotifier>().themeMode;
          return Consumer<LanguageChangeController>(
              builder: (context, provider, child) {
            if (widget.locale.isEmpty) {
              provider.changeLanguage(const Locale('en'));
            }
            return MaterialApp(
              locale: widget.locale == ''
                  ? const Locale('en')
                  : provider.appLocale == null
                      ? Locale('en')
                      : provider.appLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('ar')],
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              home: SplashScreen(),
            );
          });
        },
      ),
    );
  }
}
