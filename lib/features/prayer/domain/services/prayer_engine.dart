import 'package:adhan/adhan.dart';
import '../entities/prayer_location.dart';

class PrayerEngine {
  PrayerTimes calculatePrayerTimes({
    required PrayerLocation location,
    required DateTime date,
    CalculationMethod method = CalculationMethod.umm_al_qura,
    Madhab madhab = Madhab.shafi,
  }) {
    final coordinates = Coordinates(location.latitude, location.longitude);
    final params = method.getParameters();
    params.madhab = madhab;

    final dateComponents = DateComponents(date.year, date.month, date.day);
    
    return PrayerTimes(coordinates, dateComponents, params);
  }

  Prayer? getNextPrayer(PrayerTimes times) {
    return times.nextPrayer();
  }

  DateTime? timeForPrayer(PrayerTimes times, Prayer prayer) {
    return times.timeForPrayer(prayer);
  }
}
