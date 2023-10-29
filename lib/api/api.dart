import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Api {
  static const baseUrl = 'https://court-api.azurewebsites.net';

  static Map<String, String>? header;
  static SharedPreferences? preferences;

  static Future login(body) async {
  
    var url = "$baseUrl/api/UsersAuth/login";

    // Convert the model to a JSON string
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };

    // Set the request headers if needed
   

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

   // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }
}
