import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/model/bookingCourt/booking_response.dart';
import 'package:tennis_court_booking_app/presentation/home/model/checkstatus.dart';
import 'package:tennis_court_booking_app/profile/model/profile_model.dart';
import 'package:tennis_court_booking_app/tennismodel/teniscourt/court.dart';

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

    final jsonData = json.decode(response.body);
    // Add this line to print the received data
    return jsonData;
  }

  static Future forgotPassword(body) async {
    var url = "$baseUrl/api/UsersAuth/Send OTP for Reset";
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }

  static Future loginWithEmail(body) async {
    var url = "$baseUrl/api/UsersAuth/Send OTP";
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }

  static Future sendOtp(body) async {
    var url = "$baseUrl/api/UsersAuth/Login With Otp";
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }

  static Future emaiVerificationForgotPassword(body) async {
    var url = "$baseUrl/api/UsersAuth/Confirm Email For Password Reset";
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }

  static Future emaiVerification(body) async {
    var url = "$baseUrl/api/UsersAuth/Verify Email";
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }

  static Future resetPassword(body) async {
    var url = "$baseUrl/api/UsersAuth/Reset Password";
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }

  static Future register(body) async {
    var url = "$baseUrl/api/UsersAuth/register";

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

  

  static Future registerForm(String email, String name, String phoneNumber,
      String dob, String address, String image) async {
    var url = "$baseUrl/api/UsersAuth/Form Regisration";

    // Convert the model to a JSON string

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    // Add fields to the request
    request.fields.addAll({
      "email": email,
      "name": name,
      "phoneNumber": phoneNumber,
      "dob": dob,
      "address": address,
     
    });

    // Add image file to the request
   request.files.add(await http.MultipartFile.fromPath(
      'image',
      image ,
     
    ));
    print("image $image");
    // Add headers to the request
    //request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      print(jsonData);
      return jsonData;
    } catch (error) {
      print("Error: $error");
      // Handle the error or return an appropriate response.
      return null;
    }
  }

//Complete profile
  static Future<CheckStatus> completeProfile(String bearerToken) async {
    var url = "$baseUrl/api/UsersAuth/registration-status";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return CheckStatus.fromJson(jsonDecode(response.body));
  }

  //profile show
  static Future<ProfileModel> profileShow(String bearerToken) async {
    var url = "$baseUrl/api/Profile/View Profile";

    // Convert the model to a JSON string
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return ProfileModel.fromJson(jsonDecode(response.body));
  }

  //Show court api
  static Future<CourtList> showCourt() async {
    var url = "$baseUrl/api/TennisCourt";
    Map<String, String> headers = {
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return CourtList.fromJson(jsonDecode(response.body));
  }


  //Booking Response
  static Future<BookingResponse> showBookingResponse(DateTime date) async {
    var url = "$baseUrl/api/Booking/Get courts with slots/$date";
    Map<String, String> headers = {
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return BookingResponse.fromJson(jsonDecode(response.body));
  }
}
