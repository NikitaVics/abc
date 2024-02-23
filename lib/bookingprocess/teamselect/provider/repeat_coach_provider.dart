import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/repeat/repeat_coach.dart';
import 'package:tennis_court_booking_app/model/repeat/repeat_freind.dart';

class RepeatCoachShowProvider extends ChangeNotifier {
  RepeatCoach? _repeatFriend;

   RepeatCoach? get  repeatFriend => _repeatFriend;

  Future<void> fetchRepeatCoachshow(String token,DateTime date, String time) async {
    try {
       _repeatFriend = await Api.repeatCoach(token,date,time);
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