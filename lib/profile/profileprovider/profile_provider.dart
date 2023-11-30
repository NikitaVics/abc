import 'package:flutter/foundation.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/profile/model/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profileModel;

  ProfileModel? get profileModel => _profileModel;

  Future<void> fetchProfile(String token) async {
    try {
      _profileModel = await Api.profileShow(token);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
   _profileModel = null;
    notifyListeners();
  }
}
