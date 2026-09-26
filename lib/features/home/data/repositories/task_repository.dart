import '../../../../core/database/database_helper.dart';

class TaskItem {
  final int id;
  final String title;
  final bool isCompleted;
  final String createdDate;

  TaskItem({required this.id, required this.title, required this.isCompleted, required this.createdDate});
  
  TaskItem copyWith({bool? isCompleted}) {
    return TaskItem(
      id: id,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdDate: createdDate,
    );
  }
}

class TaskRepository {
  final DatabaseHelper _dbHelper;

  TaskRepository(this._dbHelper);

  Future<List<TaskItem>> getTasks(String date) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'created_date = ?',
      whereArgs: [date],
    );
    
    return maps.map((map) => TaskItem(
      id: map['id'] as int,
      title: map['title'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
      createdDate: map['created_date'] as String,
    )).toList();
  }

  Future<void> toggleTask(int id, bool isCompleted) async {
    final db = await _dbHelper.database;
    await db.update('tasks', {'is_completed': isCompleted ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }
  
  Future<void> insertTask(String title, String date) async {
    final db = await _dbHelper.database;
    await db.insert('tasks', {'title': title, 'is_completed': 0, 'created_date': date});
  }
}
