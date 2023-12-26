import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/profile/model/my_profile.dart';

class MyProfileProvider extends ChangeNotifier {
  MyProfile? _myProfile;

 MyProfile? get  myProfile =>  _myProfile;

  Future<void> fetchProfile(String token) async {
    try {
       _myProfile = await Api.MyprofileShow(token);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
   _myProfile = null;
    notifyListeners();
  }
}
