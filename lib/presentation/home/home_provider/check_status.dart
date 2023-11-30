import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/presentation/home/model/checkstatus.dart';
import 'package:tennis_court_booking_app/tennismodel/teniscourt/court.dart';

class CheckStatusProvider extends ChangeNotifier {
  CheckStatus? _checkStatus;
  

  CheckStatus? get checkStatus => _checkStatus;
 

  Future<void> checkRegistrationStatus(String token) async {
    try {
      _checkStatus = await Api.completeProfile(token);
    } catch (error) {
      print("Error checking registration status: $error");
      // Handle the error if needed
      notifyListeners();
    }
  }
   void clearStateList() {
    _checkStatus = null;
    notifyListeners();
  }
}

