import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/profile/model/allfriend_request_model.dart';

class MyFriendRequestProvider extends ChangeNotifier {
 AllFrinedRequestModel? _myFriend;

 AllFrinedRequestModel? get myFriend =>  _myFriend;

  Future<void> fetchFrined(String token) async {
    try {
       _myFriend= await Api.allFrinedRequestResponse(token);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
  _myFriend = null;
    notifyListeners();
  }
}
