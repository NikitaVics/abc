import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/tennismodel/teniscourt/court.dart';

class CourtShowProvider extends ChangeNotifier {
  CourtList? _courtList;

  CourtList? get courtList => _courtList;

  Future<void> fetchCourts() async {
    try {
      _courtList = await Api.showCourt();
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
}
