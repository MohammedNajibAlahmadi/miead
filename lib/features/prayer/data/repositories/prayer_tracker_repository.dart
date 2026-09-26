import '../../../../core/database/database_helper.dart';
import '../entities/daily_prayer_record.dart';

class PrayerTrackerRepository {
  final DatabaseHelper _dbHelper;

  PrayerTrackerRepository(this._dbHelper);

  Future<DailyPrayerRecord> getRecord(String dateIso) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_tracker',
      where: 'date = ?',
      whereArgs: [dateIso],
    );

    if (maps.isEmpty) {
      final newRecord = DailyPrayerRecord(date: dateIso);
      await db.insert('prayer_tracker', {
        'date': newRecord.date,
        'fajr': 0, 'dhuhr': 0, 'asr': 0, 'maghrib': 0, 'isha': 0,
      });
      return newRecord;
    }

    final row = maps.first;
    return DailyPrayerRecord(
      date: dateIso,
      fajr: row['fajr'] == 1,
      dhuhr: row['dhuhr'] == 1,
      asr: row['asr'] == 1,
      maghrib: row['maghrib'] == 1,
      isha: row['isha'] == 1,
    );
  }

  Future<void> updateRecord(DailyPrayerRecord record) async {
    final db = await _dbHelper.database;
    await db.update(
      'prayer_tracker',
      {
        'fajr': record.fajr ? 1 : 0,
        'dhuhr': record.dhuhr ? 1 : 0,
        'asr': record.asr ? 1 : 0,
        'maghrib': record.maghrib ? 1 : 0,
        'isha': record.isha ? 1 : 0,
      },
      where: 'date = ?',
      whereArgs: [record.date],
    );
  }
}
