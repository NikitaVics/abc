import 'package:flutter/cupertino.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/bookResultofUser/bookresult_of_user.dart';

class BookResultShowProvider extends ChangeNotifier {
  BookedResultOfUser? _bookedResultOfUser;

  BookedResultOfUser? get  bookedResult =>  _bookedResultOfUser;

  Future<void> fetchBookResult(String bearerToken,int id) async {
    try {
       _bookedResultOfUser= await Api.bookResultOfUserResponse(bearerToken, id);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
   _bookedResultOfUser = null;
    notifyListeners();
  }
}
