import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/upComingBooking/upcoming_booking_model.dart';

class PreviousBookProvider extends ChangeNotifier {
  UpcomingBookingModel? _upComingModel;

  UpcomingBookingModel? get  upComingBookModel => _upComingModel;

  Future<void> fetchupComingData(String bearerToken) async {
    try {
      _upComingModel = await Api.previousBookingResponse(bearerToken);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
  _upComingModel = null;
    notifyListeners();
  }
}
