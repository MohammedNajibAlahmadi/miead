import '../database/database_helper.dart';
import '../network/api_service.dart';

class SyncManager {
  final DatabaseHelper _dbHelper;
  final ApiService _apiService;

  SyncManager(this._dbHelper, this._apiService);

  Future<void> syncTasksToCloud() async {
    try {
      final db = await _dbHelper.database;
      // Fetch all local tasks for MVP syncing
      final tasks = await db.query('tasks');
      
      if (tasks.isNotEmpty) {
        await _apiService.pushTasks(tasks);
        print('Offline-First Sync Completed: Pushed ${tasks.length} tasks.');
      }
    } catch (e) {
      // Backend handling mapping (Exception parsing triggered if C# web server is offline)
      print('SyncManager Error [Backend Unreachable]: $e');
    }
  }
}
