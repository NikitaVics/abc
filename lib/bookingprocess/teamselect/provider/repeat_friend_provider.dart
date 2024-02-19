import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/repeat/repeat_freind.dart';

class RepeatFreindShowProvider extends ChangeNotifier {
  RepeatFriend? _repeatFriend;

   RepeatFriend? get  repeatFriend => _repeatFriend;

  Future<void> fetchRepeatfriendshow(String token,DateTime date, String time) async {
    try {
       _repeatFriend = await Api.repeatFrined(token,date,time);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
  _repeatFriend = null;
    notifyListeners();
  }
}
