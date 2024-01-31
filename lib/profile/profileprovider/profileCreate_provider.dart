import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/profile/model/profileCreateTime.dart';

class ProfileCreateProvider extends ChangeNotifier {
 ProfileCreateTimeModel? _timeModel;

ProfileCreateTimeModel? get  timeModel=>   _timeModel;

  Future<void> fetchtime(String token) async {
    try {
      _timeModel= await Api.createTime(token);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
 _timeModel= null;
    notifyListeners();
  }
}
