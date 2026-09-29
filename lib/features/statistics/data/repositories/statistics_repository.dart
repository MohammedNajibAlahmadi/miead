import '../../../../core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/app_stats.dart';

class StatisticsRepository {
  final DatabaseHelper _dbHelper;

  StatisticsRepository(this._dbHelper);

  Future<AppStats> fetchStats() async {
    final db = await _dbHelper.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Get Total Completed Tasks
    final tasksResult = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE is_completed = 1');
    final completedTasksTotal = Sqflite.firstIntValue(tasksResult) ?? 0;

    // Get Total Focus Minutes
    final focusResultAll = await db.rawQuery('SELECT SUM(duration_minutes) as sum FROM timer_sessions');
    final totalFocusMinutes = (focusResultAll.first['sum'] as int?) ?? 0;

    // Get Today Focus Minutes
    final focusResultToday = await db.rawQuery('SELECT SUM(duration_minutes) as sum FROM timer_sessions WHERE created_date = ?', [today]);
    final todayFocusMinutes = (focusResultToday.first['sum'] as int?) ?? 0;

    // Get Adhkar Completed (Dummy metric, normally we'd track adhkar sessions)
    final adhkarResult = await db.rawQuery('SELECT COUNT(*) as count FROM adhkar');
    final adhkarCompleted = (Sqflite.firstIntValue(adhkarResult) ?? 0) * 100;

    // Get distribution map
    final distResult = await db.rawQuery('SELECT session_type, SUM(duration_minutes) as sum FROM timer_sessions GROUP BY session_type');
    final Map<String, int> distribution = {};
    for (final row in distResult) {
      distribution[row['session_type'] as String] = (row['sum'] as int?) ?? 0;
    }

    // Get weekly timeline
    final String lastWeek = DateTime.now().subtract(const Duration(days: 7)).toIso8601String().substring(0, 10);
    final weeklyResult = await db.rawQuery('SELECT created_date, SUM(duration_minutes) as sum FROM timer_sessions WHERE created_date >= ? GROUP BY created_date', [lastWeek]);
    final Map<String, int> weeklyActivity = {};
    for (final row in weeklyResult) {
       weeklyActivity[row['created_date'] as String] = (row['sum'] as int?) ?? 0;
    }

    return AppStats(
      completedTasksTotal: completedTasksTotal,
      todayFocusMinutes: todayFocusMinutes,
      totalFocusMinutes: totalFocusMinutes,
      adhkarCompleted: adhkarCompleted,
      focusDistribution: distribution,
      weeklyActivity: weeklyActivity,
    );
  }
}
