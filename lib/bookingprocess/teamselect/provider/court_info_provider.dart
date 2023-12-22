import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/courtInfo/court_info.dart';

class CourtInfoProvider extends ChangeNotifier {
  CourtInfo? _courtInfo;

 CourtInfo? get  courtinfo => _courtInfo;

  Future<void> fetchCourtInfo(int id) async {
    try {
       _courtInfo = await Api.courtInfoResponse(id);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
   _courtInfo = null;
    notifyListeners();
  }
}
