
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subscription/database/workshopEntity.dart';
import 'package:subscription/model/workshop.dart';


class DatabaseService {
  final String databaseName = "subscription.db";

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, databaseName),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE workshop(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE subscription(id INTEGER PRIMARY KEY AUTOINCREMENT, detail TEXT NOT NULL, number INTEGER, workshopId INTEGER)",
        );
        await database.execute(
          "CREATE TABLE lesson(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, subscriptionId INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<int> createItem(WorkshopEntity workshopEntity) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
        'workshop', workshopEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }
}