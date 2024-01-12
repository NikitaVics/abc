import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/profile/model/search_model.dart';

class SearchProvider extends ChangeNotifier {
  SearchModel? _searchModel;

  SearchModel? get search => _searchModel;

  Future<void> fetchSearch(String token,String search) async {
    try {
      _searchModel = await Api.searchFriend(token, search);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
   _searchModel = null;
    notifyListeners();
  }
}