import 'package:shared_preferences/shared_preferences.dart';
class SharePref
{
static Future<String> fetchAuthToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String authToken = pref.getString('authToken') ?? ''; // Default empty string
  // Now you can use the 'authToken' in your logic
  return authToken;
}
static Future<String> fetchEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String email = pref.getString('email') ?? ''; // Default empty string
  // Now you can use the 'authToken' in your logic
  return email;
}
}
