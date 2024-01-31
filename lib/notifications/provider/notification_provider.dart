import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/notifications/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
 NotificationModel? _notificationModel;

NotificationModel? get  notificationModel =>   _notificationModel;

  Future<void> fetchNotification(String token) async {
    try {
      _notificationModel= await Api.allNotificationResponse(token);
      notifyListeners();
    } catch (error) {
      // Handle errors, maybe log them or show a snackbar
      print("Error: $error");
    }
  }
   void clearStateList() {
 _notificationModel= null;
    notifyListeners();
  }
}
