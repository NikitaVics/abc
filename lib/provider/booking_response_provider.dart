import 'package:flutter/foundation.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/bookingCourt/booking_response.dart';

class BookingResponseProvider extends ChangeNotifier {
  BookingResponse? _bookingResponse;

  BookingResponse? get bookingResponse => _bookingResponse;

  Future<void> fetchBookingResponse(String date) async {
    try {
     _bookingResponse = await Api.showBookingResponse(date);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
}
