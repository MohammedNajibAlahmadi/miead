import '../../../../core/database/database_helper.dart';
import '../../domain/entities/timer_session.dart';

class TimerRepository {
  final DatabaseHelper _dbHelper;

  TimerRepository(this._dbHelper);

  Future<void> saveSession(TimerSession session) async {
    final db = await _dbHelper.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    
    final String typeString = session.type == SessionType.custom && session.customLabel != null 
        ? session.customLabel! 
        : _mapTypeToString(session.type);

    await db.insert('timer_sessions', {
      'duration_minutes': session.duration.inMinutes,
      'session_type': typeString,
      'created_date': today,
    });
  }

  Future<List<String>> getDistinctTags() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT DISTINCT session_type FROM timer_sessions');
    
    final standardTypes = ['مذاكرة', 'قرآن', 'قراءة', 'عمل'];
    final tags = <String>[];
    
    for (final row in result) {
      final tag = row['session_type'] as String;
      if (!standardTypes.contains(tag)) {
        tags.add(tag);
      }
    }
    return tags;
  }

  String _mapTypeToString(SessionType type) {
    switch (type) {
      case SessionType.study: return 'مذاكرة';
      case SessionType.quran: return 'قرآن';
      case SessionType.reading: return 'قراءة';
      case SessionType.work: return 'عمل';
      default: return 'مخصص';
    }
  }
}
