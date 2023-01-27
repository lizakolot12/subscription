
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subscription/database/subscriptionEntity.dart';
import 'package:subscription/database/workshopEntity.dart';
import 'package:subscription/model/workshop.dart';

import 'lessonEntity.dart';


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
          "CREATE TABLE subscription(id INTEGER PRIMARY KEY AUTOINCREMENT, detail TEXT NOT NULL, number INTEGER, workshopId INTEGER, "
              "  FOREIGN KEY (workshopId) REFERENCES workshop (id) )",
        );
        await database.execute(
          "CREATE TABLE lesson(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, subscriptionId INTEGER, "
              " FOREIGN KEY (subscriptionId) REFERENCES subscription (id) )",
        );
      },
      version: 1,
    );
  }

  Future<List<Workshop>> getAll() async {
    int result = 0;
    final Database db = await initializeDB();
    final all = await db.getVersion()

    return id;
  }

  Future<int> createItem(WorkshopEntity workshopEntity) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
        'workshop', workshopEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> createSubscription(SubscriptionEntity subscriptionEntity) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
        'subscription', subscriptionEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> createLesson(LessonEntity lessonEntity) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
        'lesson', lessonEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }
}