import 'package:flutter/foundation.dart';

class LocalNotificationsService {
  Future<void> init() async {
    if (kDebugMode) {
      print("LocalNotificationsService: (Mock) init called. Notifications disabled for Web preview.");
    }
  }

  Future<void> requestPermissions() async {}

  Future<void> showInstantNotification(int id, String title, String body) async {
    if (kDebugMode) {
      print("Notification: \$title - \$body");
    }
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledDate) async {
    if (kDebugMode) {
      print("Scheduled Notification at \$scheduledDate: \$title - \$body");
    }
  }
}
