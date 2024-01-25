import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/announcement/model/announcement_model.dart';
import 'package:tennis_court_booking_app/api/api.dart';

class AnnouncementProvider extends ChangeNotifier {
 AnnouncementModel? _announcementModel;

AnnouncementModel? get  announcementModel =>   _announcementModel;

  Future<void> fetchAnnouncement() async {
    try {
      _announcementModel= await Api.allAnnouncementResponse();
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
 _announcementModel= null;
    notifyListeners();
  }
}
