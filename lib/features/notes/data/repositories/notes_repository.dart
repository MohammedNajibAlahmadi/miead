import '../../../../core/database/database_helper.dart';
import '../../domain/entities/note_entity.dart';

class NotesRepository {
  final DatabaseHelper _dbHelper;

  NotesRepository(this._dbHelper);

  Future<List<Note>> getAllNotes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'id DESC');

    return maps.map((row) => Note(
      id: row['id'] as int,
      title: row['title'] as String,
      content: row['content'] as String,
      createdAt: row['created_at'] as String,
      colorCode: row['color_code'] as int,
      moodEmoji: row['mood_emoji'] as String?,
    )).toList();
  }

  Future<void> addNote(Note note) async {
    final db = await _dbHelper.database;
    await db.insert('notes', {
      'title': note.title,
      'content': note.content,
      'created_at': note.createdAt,
      'color_code': note.colorCode,
      'mood_emoji': note.moodEmoji,
    });
  }

  Future<void> updateNote(Note note) async {
    if (note.id == null) return;
    final db = await _dbHelper.database;
    await db.update('notes', {
      'title': note.title,
      'content': note.content,
      'created_at': note.createdAt,
      'color_code': note.colorCode,
      'mood_emoji': note.moodEmoji,
    }, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await _dbHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
