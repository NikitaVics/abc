import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController extends ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  // Constructor to initialize the language preference
  LanguageChangeController() {
    _loadLanguagePreference();
  }

  // Method to load the language preference from SharedPreferences
  void _loadLanguagePreference() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? languageCode = sp.getString('language_code');

    // If language code is not found, default to English
    _appLocale = languageCode == 'ar' ? Locale('ar') : Locale('en');

    // Notify listeners after loading the language preference
    notifyListeners();
  }

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _appLocale = type;
    if (type == const Locale('en')) {
      await sp.setString('language_code', 'en');
    } else {
      await sp.setString('language_code', 'ar');
    }
    notifyListeners();
  }
}
