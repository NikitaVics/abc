import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/bookingprocess/editTeam/model/editTeam_model.dart';
import 'package:tennis_court_booking_app/model/finalBookModel/final_book_model.dart';

class EditTeamProvider with ChangeNotifier {
  EditTeamModel? _editTeamModel;
  EditTeamModel? get editTeamModel => _editTeamModel;

  Future<void> editTeamApi(
    String bearerToken,
      int bookingId,
      int teamId,
      int coachId,
      List<int> friendIds
  ) async {
    try {
     _editTeamModel = await Api.editTeam(
          bearerToken, bookingId, teamId, coachId, friendIds);
      // Perform any additional processing with the response if needed
      notifyListeners();
    } catch (error) {
      // Handle errors
      print("API Error: $error");
    } 
  }

  void clearBooking() {
   _editTeamModel = null;
    notifyListeners();
  }
}
