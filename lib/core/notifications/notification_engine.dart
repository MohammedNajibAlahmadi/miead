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
    
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    await _plugin
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
    await _plugin.show(
      id: id,
      title: title,
      body: body,
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

    await _plugin.zonedSchedule(
      id: alarm.id.hashCode,
      title: alarm.title,
      body: 'حان وقت: ${alarm.title}',
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAlarm(String id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id: id.hashCode);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
