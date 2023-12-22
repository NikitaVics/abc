import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/friendShow/friend_show_model.dart';

class FreindShowProvider extends ChangeNotifier {
  FriendShowModel? _friendShowModel;

  FriendShowModel? get  friendShowModel => _friendShowModel;

  Future<void> fetchfriendshow(String token,DateTime date, String time) async {
    try {
       _friendShowModel = await Api.friendShow(token,date,time);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
  _friendShowModel = null;
    notifyListeners();
  }
}
