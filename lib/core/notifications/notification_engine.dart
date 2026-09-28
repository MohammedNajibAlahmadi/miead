import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/alarms/domain/entities/alarm.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationEngine {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) return;

    const AndroidInitializationSettings initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: initSettingsAndroid);
    
    await (_plugin as dynamic).initialize(
      initializationSettings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    await (_plugin as dynamic)
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _isInitialized = true;
  }

  Future<void> showInstantNotification({required int id, required String title, required String body}) async {
    if (kIsWeb) return;
    const androidDetails = AndroidNotificationDetails(
      'miead_focus_channel',
      'جلسات التركيز',
      channelDescription: 'إشعارات اكتمال جلسات التركيز والمذاكرة',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await (_plugin as dynamic).show(
      id,
      title,
      body,
      notificationDetails: details,
    );
  }

  Future<void> scheduleAlarmNotification(AlarmDefinition alarm) async {
    if (!alarm.isActive || kIsWeb) return;

    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year, now.month, now.day, alarm.time.hour, alarm.time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'miead_alarms_channel',
      'منبهات الصلوات والأذكار',
      channelDescription: 'قناة المنبهات المتكررة للأوقات المهمة',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    final details = const NotificationDetails(android: androidDetails);

    await (_plugin as dynamic).zonedSchedule(
      alarm.id.hashCode,
      alarm.title,
      'حان وقت: ${alarm.title}',
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAlarm(String id) async {
    if (kIsWeb) return;
    await (_plugin as dynamic).cancel(id.hashCode);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
