import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal(); // create an object of db object instance
  String tblTodo = 'todo';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DbHelper._internal(); // db helper constructor

  factory DbHelper() {
    return _dbHelper;
  } // a constructor that creates a singleton

// this variable hold instance to db;
static Database _db;

Future<Database> get db async {
  if (_db == null) {
    _db == await initializeDb();
  }
  return _db;
}
  // create or open a db
  Future<Database> initializeDb() async {
    Directory dir = await getApplicationSupportDirectory();
    String path = dir.path + 'todo.db';
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
      }
    
      void _createDb(Database db, int version) async {
        await db.execute(
          "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)"
        );
  }
}