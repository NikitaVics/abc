import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/coachshow/Coach_show_model.dart';

class CoachShowProvider extends ChangeNotifier {
  CoachShowModel? _coachShowModel;

  CoachShowModel? get  coachShowModel => _coachShowModel;

  Future<void> fetchfriendshow(DateTime date, String time) async {
    try {
       _coachShowModel = await Api.CoachShow(date, time);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
  _coachShowModel = null;
    notifyListeners();
  }
}
