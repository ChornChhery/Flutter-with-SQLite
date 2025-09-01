import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  /// Initialize the database (create/open)
  static Future<Database> initDb() async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'mydb.db');
    // Open database and create if it doesn't exist
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE users(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT
)''');
      },
    );
    return _db!;
  }

  /// Insert a new user into the database
  static Future<int> insertUser(String name) async {
    final db = await initDb();
    return await db.insert('users', {'name': name});
  }

  /// Retrieve all users from the database
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await initDb();
    return await db.query('users');
  }

  /// Delete a user by ID
  static Future<int> deleteUser(int id) async {
    final db = await initDb();
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  /// Update a user's name by ID
  static Future<int> updateUser(int id, String newName) async {
    final db = await initDb();
    return await db.update(
      'users',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
