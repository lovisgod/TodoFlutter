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

  DbHelper._internal(); // db helper singleton constructor

  factory DbHelper() {
    return _dbHelper;
  } // a constructor that creates a singleton

// this variable hold instance to db;
static Database _db;

Future<Database> get db async {
  if (_db == null) {
    _db = await initializeDb();
  }
  return _db;
}
  // create or open a db
  Future<Database> initializeDb() async {
    Directory dir = await getApplicationSupportDirectory();
    String path = dir.path + 'todo.db';
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb); // this open or create a new db
    return dbTodos;
    }
    
      void _createDb(Database db, int version) async {
        await db.execute(
          "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)"
        );
  }

  // query methods comes here
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tblTodo, todo.toMap());
    return result; // if the integer returned is zero, something is wrong. It must be the id of the row created
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblTodo order by $colPriority ASC");
    return result;
  }

  Future<int>getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("select count(*) from $tblTodo")
    );
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    var db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(), where:"$colId = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    int result;
    var db = await this.db;
    result =await db.rawDelete("DELETE FROM $tblTodo WHERE $colId = $id");
    return result;
  }
}