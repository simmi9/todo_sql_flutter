import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

final todoTABLE = 'Todo';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  late Database _database;
  // static DatabaseProvider _databaseHelper = DatabaseProvider(); //Singleton
  //dbProvider._createInstance();
  /* factory DatabaseProvider() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseProvider._createInstance();
    }
    return _databaseHelper;
  }*/
  Future<Database> get database async {
    // if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'ReactiveTodo2.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute("CREATE TABLE $todoTABLE ("
            "id INTEGER PRIMARY KEY, "
            "description TEXT, "
            /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/
            "is_done INTEGER, "
            "dueDate TEXT"
            ")");
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $todoTABLE ("
        "id INTEGER PRIMARY KEY AUTO_INCREMENT, "
        "description TEXT, "
        /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/
        "is_done INTEGER,"
        "dueDate TEXT "
        ")");
  }
}
