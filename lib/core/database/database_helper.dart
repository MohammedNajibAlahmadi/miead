import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "miead.db";
  static const _databaseVersion = 7;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE app_settings (
        id INTEGER PRIMARY KEY,
        theme_mode TEXT NOT NULL,
        is_first_run INTEGER NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE alarms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        time TEXT NOT NULL,
        is_active INTEGER NOT NULL,
        is_recurring INTEGER NOT NULL
      )
    ''');

    await _createAdhkarTable(db);
    await _createTasksTable(db);
    await _createTimerSessionsTable(db);
    await _createPrayerTrackerTable(db);
    await _createKhatmaTable(db);
    await _createNotesTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createAdhkarTable(db);
    }
    if (oldVersion < 3) {
      await _createTasksTable(db);
    }
    if (oldVersion < 4) {
      await _createTimerSessionsTable(db);
    }
    if (oldVersion < 5) {
      await _createPrayerTrackerTable(db);
    }
    if (oldVersion < 6) {
      await _createKhatmaTable(db);
    }
    if (oldVersion < 7) {
      await _createNotesTable(db);
    }
  }

  Future _createNotesTable(Database db) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        color_code INTEGER NOT NULL
      )
    ''');
  }

  Future _createKhatmaTable(Database db) async {
    await db.execute('''
      CREATE TABLE khatma_tracker (
        id INTEGER PRIMARY KEY,
        current_page INTEGER NOT NULL,
        surah_name TEXT NOT NULL
      )
    ''');
    // Seed initial progress at page 1.
    await db.insert('khatma_tracker', {
      'id': 1,
      'current_page': 1,
      'surah_name': 'الفاتحة',
    });
  }

  Future _createPrayerTrackerTable(Database db) async {
    await db.execute('''
      CREATE TABLE prayer_tracker (
        date TEXT PRIMARY KEY,
        fajr INTEGER NOT NULL,
        dhuhr INTEGER NOT NULL,
        asr INTEGER NOT NULL,
        maghrib INTEGER NOT NULL,
        isha INTEGER NOT NULL
      )
    ''');
  }

  Future _createTimerSessionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE timer_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        duration_minutes INTEGER NOT NULL,
        session_type TEXT NOT NULL,
        created_date TEXT NOT NULL
      )
    ''');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    // Seed some mock data
    await db.insert('timer_sessions', {'duration_minutes': 25, 'session_type': 'مذاكرة', 'created_date': today});
  }

  Future _createTasksTable(Database db) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        is_completed INTEGER NOT NULL,
        created_date TEXT NOT NULL
      )
    ''');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await db.insert('tasks', {'title': 'قراءة ورد القرآن', 'is_completed': 0, 'created_date': today});
    await db.insert('tasks', {'title': 'الرياضة وتمرين الصباح', 'is_completed': 1, 'created_date': today});
    await db.insert('tasks', {'title': 'صلاة الضحى', 'is_completed': 0, 'created_date': today});
  }

  Future _createAdhkarTable(Database db) async {
    await db.execute('''
      CREATE TABLE adhkar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        text TEXT NOT NULL,
        target INTEGER NOT NULL
      )
    ''');
    await db.insert('adhkar', {'category': 'تلقائي', 'text': 'أستغفر الله العظيم', 'target': 100});
    await db.insert('adhkar', {'category': 'تلقائي', 'text': 'سبحان الله وبحمده', 'target': 100});
    await db.insert('adhkar', {'category': 'الصباح', 'text': 'اللهم صل وسلم على نبينا محمد', 'target': 10});
  }
}
