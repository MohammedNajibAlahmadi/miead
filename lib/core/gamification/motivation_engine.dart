import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/notifications/local_notifications_service.dart';
import '../../features/statistics/domain/entities/app_stats.dart';

class MotivationEngine {
  final LocalNotificationsService _notificationService;

  MotivationEngine(this._notificationService);

  // AES/Base64 Mock Payload (Simulating Encrypted Text)
  // This JSON contains highly dynamic contextual rules.
  final String _encryptedPayload = '''
  {
    "friday": [
      "في يوم الجمعة تتنزل الرحمات، أكثر من الصلاة على النبي واستثمر وقتك.",
      "سورة الكهف نور ما بين الجمعتين، لا تنسَ قراءتها اليوم.",
      "ساعة استجابة تنتظرك هذا المساء، لا تفوتها في خضم مشاغلك."
    ],
    "monday_thursday": [
      "الأعمال تعرض على الله اليوم، فما أجمل أن ترفع وأنت في طاعة أو عمل مثمر.",
      "بداية الأسبوع فرصة رائعة لشحذ الهمة وتجديد النوايا."
    ],
    "general": [
      "﴿وَأَن لَيسَ لِلإِنسانِ إِلّا ما سَعىٰ﴾ - سعيك اليوم هو حصاد الغد.",
      "كل دقيقة تقضيها بتركيز هي خطوة أقرب نحو أحلامك.",
      "تذكر، قليل دائم خير من كثير منقطع."
    ],
    "task_triggers": {
      "قرآن": "يا لها من مهمة عظيمة! كلام الله يطهر القلب وينير الدرب.",
      "مذاكرة": "طلب العلم فريضة وعبادة، استمر في جهادك العلمي!",
      "رياضة": "المؤمن القوي خير وأحب إلى الله من المؤمن الضعيف، حافظ على صحتك.",
      "قراءة": "اقرأ.. أول كلمة نزلت في دستورنا، بارك الله في وقتك وجعلك من القراء."
    }
  }
  ''';

  Map<String, dynamic> _decodeMotivations() {
    // In a real crypto scenario, AES decrypt here before JSON parsing.
    return json.decode(_encryptedPayload);
  }

  /// Returns a dynamic inspiration quote based on Time/Day context
  String getDailyInspiration() {
    final now = DateTime.now();
    final data = _decodeMotivations();
    
    if (now.weekday == DateTime.friday) {
      final list = data['friday'] as List;
      return list[now.day % list.length];
    } else if (now.weekday == DateTime.monday || now.weekday == DateTime.thursday) {
      final list = data['monday_thursday'] as List;
      return list[now.day % list.length];
    } else {
      final list = data['general'] as List;
      return list[now.minute % list.length]; // randomish
    }
  }

  /// Returns a specific encouragement if a task title matches our keyword rules
  String? getTaskEncouragement(String taskTitle) {
    final data = _decodeMotivations();
    final triggers = data['task_triggers'] as Map<String, dynamic>;
    
    for (final key in triggers.keys) {
      if (taskTitle.toLowerCase().contains(key)) {
        return triggers[key];
      }
    }
    return null;
  }

  /// Dispatches localized push notifications based on analytics
  Future<void> evaluateAndPushRetentionNotifications(AppStats stats) async {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final todayFocus = stats.weeklyActivity[todayStr] ?? 0;

    if (todayFocus == 0 && DateTime.now().hour > 18) {
       // It's past 6 PM and they haven't focused at all today!
       await _notificationService.showInstantNotification(
         9991, 
         'اشتقنا لإنجازاتك!', 
         'لم تُسجل أي وقت للتركيز أو العبادة هذا اليوم، لا تدع اليوم يمر دون أن تترك أثراً.',
       );
    }
  }

  Future<void> pushEncouragement(String title, String body) async {
     await _notificationService.showInstantNotification(
       DateTime.now().millisecond,
       title,
       body,
     );
  }
}
