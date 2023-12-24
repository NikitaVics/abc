import 'package:flutter/cupertino.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/finalBookModel/final_book_model.dart';

class CompleteBookingProvider with ChangeNotifier {
  FinalBookModel? _finalBookModel;
  FinalBookModel? get finalBookModel => _finalBookModel;

  Future<void> completeBookingApi(
    String bearerToken,
    DateTime bookingDate,
    int coachId,
    String courtName,
    String slot,
    List<int> friendIds,
  ) async {
    try {
      _finalBookModel = await Api.bookingConfirm(
          bearerToken, bookingDate, coachId, courtName, slot, friendIds);
      // Perform any additional processing with the response if needed
      notifyListeners();
    } catch (error) {
      // Handle errors
      print("API Error: $error");
    } 
  }

  void clearBooking() {
    _finalBookModel = null;
    notifyListeners();
  }
}
