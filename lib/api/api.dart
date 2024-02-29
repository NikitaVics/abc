import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/announcement/model/announcement_model.dart';
import 'package:tennis_court_booking_app/model/bookResultofUser/bookresult_of_user.dart';
import 'package:tennis_court_booking_app/model/bookingCourt/booking_response.dart';
import 'package:tennis_court_booking_app/model/coachshow/Coach_show_model.dart';
import 'package:tennis_court_booking_app/model/courtInfo/court_info.dart';
import 'package:tennis_court_booking_app/model/finalBookModel/final_book_model.dart';
import 'package:tennis_court_booking_app/model/friendShow/friend_show_model.dart';
import 'package:tennis_court_booking_app/model/repeat/repeat_coach.dart';
import 'package:tennis_court_booking_app/model/repeat/repeat_freind.dart';
import 'package:tennis_court_booking_app/model/upComingBooking/upcoming_booking_model.dart';
import 'package:tennis_court_booking_app/notifications/notification_model.dart';
import 'package:tennis_court_booking_app/presentation/home/model/checkstatus.dart';
import 'package:tennis_court_booking_app/profile/model/allfriend_model.dart';
import 'package:tennis_court_booking_app/profile/model/allfriend_request_model.dart';
import 'package:tennis_court_booking_app/profile/model/my_profile.dart';
import 'package:tennis_court_booking_app/profile/model/profileCreateTime.dart';
import 'package:tennis_court_booking_app/profile/model/profile_model.dart';
import 'package:tennis_court_booking_app/profile/model/search_model.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/tennismodel/teniscourt/court.dart';

class Api {
  static const baseUrl = 'https://behrain-api.onrender.com';
  //'https://court-api.azurewebsites.net';

  static Map<String, String>? header;
  static SharedPreferences? preferences;

  static Future login(body) async {
    var url = "$baseUrl/api/UsersAuth/login";

    // Convert the model to a JSON string
    Map<String, String> headers = {
      "content-Type": "application/json;  charset=UTF-8",
    };

    // Set the request headers if needed
    print(body);

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);
    print('Status code: ${response.statusCode}');

    if (response.body.isNotEmpty) {
      return jsonDecode(response.body);
    } else {
      // Handle empty response
      print('Empty response from the server');
      return null; // or handle as needed
    }
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
    var url = "$baseUrl/api/UsersAuth/Create account";

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

  static Future registerForm(
      String email,
      String name,
      String phoneNumber,
      String dob,
      String address,
      String? document,
      String gender,
      String coutryCode) async {
    var url = "$baseUrl/api/UsersAuth/Form Regisration";

    // Convert the model to a JSON string

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    // Add fields to the request
    request.fields.addAll({
      "CountryCode": coutryCode,
      "Gender": gender,
      "email": email,
      "name": name,
      "phoneNumber": phoneNumber,
      "dob": dob,
      "address": address,
    });

    // Add image file to the request

    if (document != null && document.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'Document',
        document,
      ));
      print("image $document");
    }

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
  static Future<BookingResponse> showBookingResponse(DateTime date,
      [List<String>? selectedCourts]) async {
    var url = "$baseUrl/api/Booking/Get courts with slots/$date";

    if (selectedCourts != null && selectedCourts.isNotEmpty) {
      Uri uri = Uri.parse(url)
          .replace(queryParameters: {'selectedCourts': selectedCourts});
      url = uri.toString();
    }

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

  //Friend show
  static Future<FriendShowModel> friendShow(
      String bearerToken, DateTime date, String time) async {
    var url = "$baseUrl/api/Friend/Available Friends For Booking";
    Uri uri = Uri.parse('$url?selectedDate=$date&selectedSlot=$time');
    url = uri.toString();
    // Convert the model to a JSON string
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print("Friend ${response.body}");

    return FriendShowModel.fromJson(jsonDecode(response.body));
  }

  //Coach Show
  static Future<CoachShowModel> coachShow(DateTime date, String time) async {
    var url =
        "$baseUrl/api/Management/Coach/Show images of all available coaches";

    // Convert the model to a JSON string
    Uri uri = Uri.parse('$url?selectedDate=$date&selectedSlot=$time');
    url = uri.toString();
    Map<String, String> headers = {
      "content-Type": "application/json; charset=UTF-8",
    };
    print(url);
    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    print("coach ${response.body}");

    if (response.statusCode == 200) {
      print(response.body);
      return CoachShowModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}');
    }
  }

//Court Info
  static Future<CourtInfo> courtInfoResponse(int id) async {
    var url = "$baseUrl/api/TennisCourt/ViewCourtInfoAndFacility/$id";

    Map<String, String> headers = {
      "content-Type": "application/json; charset=UTF-8",
    };
    print(url);
    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return CourtInfo.fromJson(jsonDecode(response.body));
  }

  //Booking Confirm
  static Future<FinalBookModel> bookingConfirm(
      String bearerToken,
      DateTime bookingDate,
      int coachId,
      String courtName,
      String slot,
      List<int> friendIds) async {
    var url = "$baseUrl/api/Booking/Make Booking";
    final Map<String, dynamic> body = {
      "bookingDate": bookingDate.toIso8601String(),
      "courtName": courtName,
      "slot": slot,
      "friendIds": friendIds
    };
    if (coachId != 0) {
      body["coachId"] = coachId;
    }
    print(coachId);
    print(friendIds);

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return FinalBookModel.fromJson(jsonDecode(response.body));
  }

  //Book result of user
  static Future<BookedResultOfUser> bookResultOfUserResponse(
      String bearerToken, int id) async {
    var url = "$baseUrl/api/Booking/GetConfirmedBooking/$id";

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json; charset=UTF-8",
    };
    print(url);
    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return BookedResultOfUser.fromJson(jsonDecode(response.body));
  }

  //My profile view
  static Future<MyProfile> MyprofileShow(String bearerToken) async {
    var url = "$baseUrl/api/Profile/My Profile";

    // Convert the model to a JSON string
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return MyProfile.fromJson(jsonDecode(response.body));
  }

  static Future changePassword(body, String bearerToken) async {
    var url = "$baseUrl/api/UsersAuth/Change Password";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
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

  //Update Profile
  static Future updateProfile(
      String bearerToken,
      String username,
      String phoneNumber,
      String countryCode,
      bool deleteImage,
      String? image) async {
    var url = "$baseUrl/api/Profile/Update Profile";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json;  charset=UTF-8",
    };
    // Convert the model to a JSON string

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(url),
    );
    request.headers.addAll(headers);
    // Add fields to the request
    request.fields.addAll({
      'UserName': username, // Add your values
      'CountryCode': countryCode, // Add your values
      'PhoneNumber': phoneNumber, // Add your values
      'DeleteCurrentImage': deleteImage.toString(), // Add your values
    });

    // Add image file to the request
    if (image != null && image.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'Image',
        image,
      ));
      print("image $image");
    }

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

//Upcoming booking model
  static Future<UpcomingBookingModel> upComingResponse(
      String bearerToken) async {
    var url = "$baseUrl/api/Booking/Upcoming Bookings";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return UpcomingBookingModel.fromJson(jsonDecode(response.body));
  }

  static Future<UpcomingBookingModel> previousBookingResponse(
      String bearerToken) async {
    var url = "$baseUrl/api/Booking/Previous Bookings";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return UpcomingBookingModel.fromJson(jsonDecode(response.body));
  }

  static Future removePhoto(String bearerToken) async {
    var url = "$baseUrl/api/Profile/Remove profile image";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json;  charset=UTF-8",
    };
    http.Response response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    // final jsonData = json.decode(response.body);
    return jsonDecode(response.body);
  }

//Change image
  static Future updateImage(String bearerToken, String? image) async {
    var url = "$baseUrl/api/Profile/UpLoad Profile Image";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json;  charset=UTF-8",
    };
    // Convert the model to a JSON string

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    request.headers.addAll(headers);

    // Add image file to the request
    if (image != null && image.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'Image',
        image,
      ));
      print("image $image");
    }

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

  //All friend
  static Future<AllFrinedModel> allFrinedResponse(String bearerToken) async {
    var url = "$baseUrl/api/Friend/All Friends";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return AllFrinedModel.fromJson(jsonDecode(response.body));
  }

  //All friend Request
  static Future<AllFrinedRequestModel> allFrinedRequestResponse(
      String bearerToken) async {
    var url = "$baseUrl/api/Friend/All Friend Requests";
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return AllFrinedRequestModel.fromJson(jsonDecode(response.body));
  }

  //Accept frined request
  static Future<String> acceptFriendRequest(String bearerToken, int id) async {
    var url = "$baseUrl/api/Friend/Accept friend request?senderId=$id";

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json; charset=UTF-8",
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Successful response
        print(response.body);
        return response.body;
      } else {
        // Error response
        print('Error: ${response.statusCode}\n${response.body}');
        return 'Error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      // Exception occurred
      print('Error: $e');
      return 'Error: $e';
    }
  }

//Reject request
  static Future<String> rejectFriendRequest(String bearerToken, int id) async {
    var url = "$baseUrl/api/Friend/Reject friend request?senderId=$id";

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Successful response
      print(response.body);
      return response.body;
    } else {
      // Error response
      print('Error: ${response.statusCode}\n${response.body}');
      return 'Error: ${response.statusCode}\n${response.body}';
    }
  }

  //Delete friend
  static Future<int> deleteFriend(String bearerToken, int id) async {
    var url = "$baseUrl/api/Friend/Remove friend?friendId=$id";

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Successful response
      print(response.body);
      return response.statusCode;
    } else {
      // Error response
      print('Error: ${response.statusCode}\n${response.body}');
      return response.statusCode;
    }
  }

  static Future<SearchModel> searchFriend(
      String bearerToken, String search) async {
    var url =
        "$baseUrl/api/Friend/Seach users to add friends?searchTerm=$search";

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Successful response
      print(response.body);
      return SearchModel.fromJson(jsonDecode(response.body));
    } else {
      // Error response
      print('Error: ${response.statusCode}\n${response.body}');
      return SearchModel.fromJson(jsonDecode(response.body));
    }
  }

  //Send friend Request
  static Future<int> sendFriendRequest(String bearerToken, int id) async {
    var url = "$baseUrl/api/Friend/Send request?receiverId=$id";

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json; charset=UTF-8",
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Successful response
        print(response.body);
        return response.statusCode;
      } else {
        // Error response
        print('Error: ${response.statusCode}\n${response.body}');
        return response.statusCode;
      }
    } catch (e) {
      // Exception occurred
      print('Error: $e');
      return 0;
    }
  }

  static Future<AnnouncementModel> allAnnouncementResponse() async {
    var url = "$baseUrl/api/MobileAnnouncement/Announcements";
    Map<String, String> headers = {
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return AnnouncementModel.fromJson(jsonDecode(response.body));
  }

  //Delete Booking
  static Future<int> deleteBooking(String bearerToken, int id) async {
    var url = "$baseUrl/api/Booking?bookingId=$id";

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Successful response
      print(response.body);
      return response.statusCode;
    } else {
      // Error response
      print('Error: ${response.statusCode}\n${response.body}');
      return response.statusCode;
    }
  }

//Notification
  static Future<NotificationModel> allNotificationResponse(String token) async {
    var url = "$baseUrl/api/Profile/All Notifications";
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return NotificationModel.fromJson(jsonDecode(response.body));
  }

  static Future<ProfileCreateTimeModel> createTime(String token) async {
    var url = "$baseUrl/api/Profile/MemberSince";
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      "content-Type": "application/json; charset=UTF-8",
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return ProfileCreateTimeModel.fromJson(jsonDecode(response.body));
  }

//Repeat Team
  static Future<RepeatFriend> repeatFrined(
      String bearerToken, DateTime date, String time) async {
    var url = "$baseUrl/api/Booking/Repeat Team";
    Uri uri = Uri.parse('$url?bookingDate=$date&Slot=$time');
    url = uri.toString();
    // Convert the model to a JSON string
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return RepeatFriend.fromJson(jsonDecode(response.body));
  }

  //Repeat coach
  static Future<RepeatCoach> repeatCoach(
      String bearerToken, DateTime date, String time) async {
    var url = "$baseUrl/api/Booking/Repeat Coach";
    Uri uri = Uri.parse('$url?bookingDate=$date&Slot=$time');
    url = uri.toString();
    // Convert the model to a JSON string
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return RepeatCoach.fromJson(jsonDecode(response.body));
  }
}
