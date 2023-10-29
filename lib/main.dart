import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/splash/splash_screen.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
     statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black, // Set the desired color here
     systemNavigationBarIconBrightness:Brightness.dark, 
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   
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
       ],
       child: const MaterialApp(
        debugShowCheckedModeBanner: false,
      
      home: SplashScreen(),
   ));
  }
}

