import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management_app/Models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    if (_database != null) return null;
    // Use path_provider to get the database path
    final directory = await getApplicationDocumentsDirectory();
    String path = ('${directory.path}tasks.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        name TEXT,
        accentColor TEXT,
        taskID TEXT PRIMARY KEY,
        parentTaskID TEXT,
        description TEXT,
        startDate TEXT,
        deadline TEXT,
        estimatedDuration INTEGER,
        actualDuration INTEGER,
        subTasksList TEXT,
        statusType INTEGER,
        statusProgress INTEGER,
        tags TEXT,
        priority TEXT
      )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i],this);
    });
  }


  Future<Task?> getTaskById(String taskId) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    where: 'taskID = ?',
    whereArgs: [taskId],
    limit: 1,
  );

  if (maps.isNotEmpty) {
    return Task.fromMap(maps.first,this);
  } else {
    return null;
  }
}


  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'taskID = ?',
      whereArgs: [task.taskID],
    );
  }

  Future<void> deleteTask(Task task) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'taskID = ?',
      whereArgs: [task.taskID],
    );
  }
}
