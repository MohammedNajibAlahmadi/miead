import '../../../../core/database/database_helper.dart';
import '../../domain/entities/alarm.dart';
import '../../../../core/datetime/time_engine.dart';

class AlarmRepository {
  final DatabaseHelper _dbHelper;

  AlarmRepository(this._dbHelper);

  Future<List<AlarmDefinition>> getAllAlarms() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('alarms');

    return maps.map((map) {
      final timeParts = (map['time'] as String).split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return AlarmDefinition(
        id: map['id'].toString(),
        title: map['title'] as String,
        time: LocalTime(hour, minute, 0),
        isActive: (map['is_active'] as int) == 1,
        activeDays: const [1, 2, 3, 4, 5, 6, 7], 
      );
    }).toList();
  }

  Future<void> updateAlarm(AlarmDefinition alarm) async {
    final db = await _dbHelper.database;
    await db.update(
      'alarms',
      <String, Object?>{
        'title': alarm.title,
        'time': '${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}',
        'is_active': alarm.isActive ? 1 : 0,
        'is_recurring': 1,
      },
      where: 'id = ?',
      whereArgs: [int.parse(alarm.id)],
    );
  }

  Future<void> insertAlarm(AlarmDefinition alarm) async {
    final db = await _dbHelper.database;
    await db.insert('alarms', <String, Object?>{
      'title': alarm.title,
      'time': '${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}',
      'is_active': alarm.isActive ? 1 : 0,
      'is_recurring': 1,
    });
  }
}
