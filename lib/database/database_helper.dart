import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:notes/util/constants.dart';
import 'package:notes/models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _INSTANCE = new DatabaseHelper.make();
  factory DatabaseHelper() => _INSTANCE;
  static Database _db;
  DatabaseHelper.make();

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, Constants.DBNAME);
    var myDb = openDatabase(path, version: Constants.DB_VERSION, onCreate: _onCreate); 

    return myDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE ${Constants.TABLE_NAME} (${Constants.COLUMN_ID} INTEGER PRIMARY KEY, ${Constants.COLUMN_TEXT} TEXT, ${Constants.COLUMN_DATE} TEXT);"
    );
  }

  Future<int> insertNote(Note note) async {
    var dbClient = await db;
    int count = await dbClient.insert(Constants.TABLE_NAME, note.toMap());

    return count;
  }

  Future<List> getAllNotes() async {
    var dbClient = await db;
    var sqlQuery = "SELECT * FROM ${Constants.TABLE_NAME} ORDER BY ${Constants.COLUMN_TEXT}";
    var result = await dbClient.rawQuery(sqlQuery);

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    var sqlQuery = "SELECT COUNT(*) FROM ${Constants.TABLE_NAME}";
    int count = Sqflite.firstIntValue(await dbClient.rawQuery(sqlQuery));

    return count;
  }

  Future<Note> getSingleItem(int id) async {
    var dbClient = await db;
    var sqlQuery = "SELECT * FROM ${Constants.TABLE_NAME} WHERE ${Constants.COLUMN_ID} = $id";
    var result = await dbClient.rawQuery(sqlQuery);

    if(result == null) return null;

    return new Note.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    int count = await dbClient.delete(Constants.TABLE_NAME, where: "${Constants.COLUMN_ID} = ?", whereArgs: [id]);

    return count;
  }

  Future<int> updateItem(Note note) async {
    var dbCclient = await db;
    int count = await dbCclient.update(Constants.TABLE_NAME, note.toMap(), where: "${Constants.COLUMN_ID} = ?", whereArgs: [note.id]);

    return count;
  }
}
