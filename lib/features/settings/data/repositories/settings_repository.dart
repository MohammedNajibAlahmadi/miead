import '../../../../core/database/database_helper.dart';

class AppSettings {
  final String themeMode;
  final bool isFirstRun;

  const AppSettings({
    this.themeMode = 'system',
    this.isFirstRun = false,
  });
}

class SettingsRepository {
  final DatabaseHelper _dbHelper;

  SettingsRepository(this._dbHelper);

  Future<AppSettings> getSettings() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('app_settings');
    
    if (maps.isEmpty) {
      // Setup default
      await db.insert('app_settings', {
        'id': 1,
        'theme_mode': 'system',
        'is_first_run': 1,
      });
      return const AppSettings();
    }
    
    return AppSettings(
      themeMode: maps.first['theme_mode'] as String,
      isFirstRun: (maps.first['is_first_run'] as int) == 1,
    );
  }

  Future<void> updateThemeMode(String mode) async {
    final db = await _dbHelper.database;
    await db.update(
      'app_settings',
      {'theme_mode': mode},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> setFirstRunCompleted() async {
    final db = await _dbHelper.database;
    await db.update(
      'app_settings',
      {'is_first_run': 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
