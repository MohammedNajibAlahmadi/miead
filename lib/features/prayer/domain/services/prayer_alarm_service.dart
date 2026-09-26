import 'package:adhan/adhan.dart';
import '../../../../core/notifications/local_notifications_service.dart';

class PrayerAlarmService {
  final LocalNotificationsService notificationsService;

  PrayerAlarmService(this.notificationsService);

  Future<void> schedulePrayerAlarms(PrayerTimes prayerTimes) async {
    int i = 0;
    for (final prayer in [Prayer.fajr, Prayer.sunrise, Prayer.dhuhr, Prayer.asr, Prayer.maghrib, Prayer.isha]) {
      final time = prayerTimes.timeForPrayer(prayer);
      if (time != null && time.isAfter(DateTime.now())) {
        await notificationsService.scheduleNotification(
          100 + i, 
          "الصلاة",
          "حان الآن موعد صلاة ${prayer.name == 'fajr' ? 'الفجر' : prayer.name == 'dhuhr' ? 'الظهر' : prayer.name == 'asr' ? 'العصر' : prayer.name == 'maghrib' ? 'المغرب' : prayer.name == 'isha' ? 'العشاء' : 'الشروق'}",
          time,
        );
      }
      i++;
    }
  }
}
