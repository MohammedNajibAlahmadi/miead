import 'package:flutter/material.dart';
import 'package:miead/app/app.dart';
import 'package:miead/app/dependency_injection/di.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/notifications/notification_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    tz.initializeTimeZones();
    await setupDependencies();
    await getIt<NotificationEngine>().initialize();
    runApp(const MieadApp());
  } catch (e, s) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(
              'شاشة الخطأ الافتراضية:\nحدث خطأ أثناء تحميل قواعد البيانات الجدارية (غالباً بسبب تشغيل التطبيق على Web بدلاً من موبايل):\n\n$e\n\n$s',
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }
}


