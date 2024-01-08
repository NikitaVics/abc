import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/friendShow/friend_show_model.dart';
import 'package:tennis_court_booking_app/profile/model/allfriend_model.dart';

class MyFriendProvider extends ChangeNotifier {
 AllFrinedModel? _myFriend;

 AllFrinedModel? get myFriend =>  _myFriend;

  Future<void> fetchFrined(String token) async {
    try {
       _myFriend= await Api.allFrinedResponse(token);
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
