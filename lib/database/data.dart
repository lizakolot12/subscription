import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subscription/database/subscriptionEntity.dart';
import 'package:subscription/database/workshopEntity.dart';
import 'package:subscription/model/subscription.dart';
import 'package:subscription/model/workshop.dart';

import '../model/lesson.dart';
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
          "CREATE TABLE subscription(id INTEGER PRIMARY KEY AUTOINCREMENT, detail TEXT NOT NULL, number INTEGER, workshopId INTEGER, startDate TEXT, endDate TEXT, "
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
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> all = await db.query("workshop");
    final List<Map<String, dynamic>> subscription =
        await db.query("subscription");
    final List<Map<String, dynamic>> lesson = await db.query("lesson");

    var lessons = List.generate(lesson.length, (i) {
      return LessonEntity.fromMap(lesson[i]);
    });

    var lessonMap = HashMap<int, List<Lesson>>();
    for (var e in lessons) {
      var cur = lessonMap[e.subscriptionId];
      cur ??= <Lesson>[];
      cur.add(Lesson(e.lId, "", e.date));
      lessonMap[e.subscriptionId] = cur;
    }

    var subscriptions = List.generate(subscription.length, (i) {
      return SubscriptionEntity.fromMap(subscription[i]);
    });

    var subscriptionMap = HashMap<int, List<Subscription>>();
    for (var e in subscriptions) {
      var cur = subscriptionMap[e.workshopId];
      cur ??= <Subscription>[];
      cur.add(Subscription(e.id, e.detail, e.startDate, e.endDate,
          e.lessonNumbers, lessonMap[e.id] ?? List.empty(), e.workshopId));
      subscriptionMap[e.workshopId] = cur;
    }

    var workshops = List.generate(all.length, (i) {
      return Workshop(all[i]["id"], all[i]["name"],
          subscriptionMap[all[i]["id"]] ?? List.empty());
    });
    return workshops;
  }

  Future<int> createItem(WorkshopEntity workshopEntity) async {
    final Database db = await initializeDB();
    final id = await db.insert('workshop', workshopEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> createSubscription(SubscriptionEntity subscriptionEntity) async {
    final Database db = await initializeDB();
    final id = await db.insert('subscription', subscriptionEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> deleteWorkshop(int workshopId) async {
    final Database db = await initializeDB();
    final id = await db.delete(
      'workshop',
      where: 'id = ?',
      whereArgs: [workshopId],
    );
    return id;
  }

  Future<int> createLesson(LessonEntity lessonEntity) async {
    final Database db = await initializeDB();
    final id = await db.insert('lesson', lessonEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }
}
