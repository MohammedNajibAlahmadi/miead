import '../../../../core/database/database_helper.dart';

class AdhkarItem {
  final int id;
  final String category;
  final String text;
  final int target;

  const AdhkarItem({required this.id, required this.category, required this.text, required this.target});
}

class AdhkarRepository {
  final DatabaseHelper _dbHelper;

  AdhkarRepository(this._dbHelper);

  Future<List<AdhkarItem>> getAllAdhkar() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('adhkar');
    
    return maps.map((map) => AdhkarItem(
      id: map['id'] as int,
      category: map['category'] as String,
      text: map['text'] as String,
      target: map['target'] as int,
    )).toList();
  }
}
