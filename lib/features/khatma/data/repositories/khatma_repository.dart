import '../../../../core/database/database_helper.dart';
import '../entities/khatma_progress.dart';

class KhatmaRepository {
  final DatabaseHelper _dbHelper;

  KhatmaRepository(this._dbHelper);

  Future<KhatmaProgress> getProgress() async {
    final db = await _dbHelper.database;
    final maps = await db.query('khatma_tracker', where: 'id = ?', whereArgs: [1]);
    
    if (maps.isNotEmpty) {
      return KhatmaProgress(
        currentPage: maps.first['current_page'] as int,
        surahName: maps.first['surah_name'] as String,
      );
    }
    return const KhatmaProgress(currentPage: 1, surahName: 'الفاتحة');
  }

  Future<void> updateProgress(int page, String surah) async {
    final db = await _dbHelper.database;
    await db.update(
      'khatma_tracker',
      {
        'current_page': page,
        'surah_name': surah,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
