import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static Future<String> fetchAuthToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String authToken =
        pref.getString('authToken') ?? ''; // Default empty string
    // Now you can use the 'authToken' in your logic
    return authToken;
  }
  static Future<String> fetchDeviceToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceToken =
        pref.getString('deviceToken') ?? ''; // Default empty string
    // Now you can use the 'authToken' in your logic
    return deviceToken;
  }
  static Future<String> fetchEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? ''; // Default empty string
    // Now you can use the 'authToken' in your logic
    return email;
  }

  static Future<int> storeResultInSharedPreferences(r) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int bookingId = pref.getInt('result') ?? 0;
    return bookingId;
  }
}
