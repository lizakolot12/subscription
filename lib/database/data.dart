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

  Future<Workshop> getBySubscriptionId(int id) async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> subscription =
        await db.query("subscription", where: "id =" + id.toString());
    final List<Map<String, dynamic>> lesson =
        await db.query("lesson", where: "subscriptionId = " + id.toString());

    var lessonsEnt = List.generate(lesson.length, (i) {
      return LessonEntity.fromMap(lesson[i]);
    });

    var lessons = lessonsEnt.map((e) => Lesson(e.lId, "", e.date)).toList();

    var subscriptions = List.generate(subscription.length, (i) {
      return SubscriptionEntity.fromMap(subscription[i]);
    });

    var subscriptionRes = subscriptions
        .map((subEntity) => Subscription(
            subEntity.id,
            subEntity.detail,
            subEntity.startDate,
            subEntity.endDate,
            subEntity.lessonNumbers,
            lessons,
            subEntity.workshopId))
        .toList();

    final List<Map<String, dynamic>> all = await db.query("workshop",
        where: "id = " + subscriptionRes[0].workshopId.toString());
    var workshops = List.generate(all.length, (i) {
      return Workshop(all[i]["id"], all[i]["name"], subscriptionRes);
    });
    return workshops[0];
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

  Future<int> deleteLesson(int lessonId) async {
    final Database db = await initializeDB();
    final id = await db.delete(
      'lesson',
      where: 'id = ?',
      whereArgs: [lessonId],
    );
    return id;
  }

  Future<int> deleteSubscription(int id) async {
    final Database db = await initializeDB();
    final res = await db.delete(
      'subscription',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res;
  }

  Future<int> createLesson(LessonEntity lessonEntity) async {
    final Database db = await initializeDB();
    final id = await db.insert('lesson', lessonEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> updateWorkshop(int workshopId, String name) async {
    final Database db = await initializeDB();
    final id = await db.update(
        'workshop', WorkshopEntity.Full(workshopId, name).toMap(),
        where: "id = " + workshopId.toString());
    return id;
  }

  Future<int> updateSubscriptionName(int id, String name) async {
    final Database db = await initializeDB();
    final res = await db.rawUpdate(
        'UPDATE subscription SET detail = ?  WHERE id = ?',
        [name, id.toString()]);
    return res;
  }

  Future<int> updateLessonsNumber(int id, int number) async {
    final Database db = await initializeDB();
    final res = await db.rawUpdate(
        'UPDATE subscription SET number = ?  WHERE id = ?',
        [number.toString(), id.toString()]);
    return res;
  }

  Future<int> updateStartDate(int id, DateTime date) async {
    final Database db = await initializeDB();
    final res = await db.rawUpdate(
        'UPDATE subscription SET startDate = ?  WHERE id = ?',
        [date.toIso8601String(), id.toString()]);
    return res;
  }

  Future<int> updateLessonsDate(int id, DateTime date) async {
    final Database db = await initializeDB();
    final res = await db.rawUpdate(
        'UPDATE lesson SET date = ?  WHERE id = ?',
        [date.toIso8601String(), id.toString()]);
    return res;
  }

  Future<int> updateEndDate(int id, DateTime date) async {
    final Database db = await initializeDB();
    final res = await db.rawUpdate(
        'UPDATE subscription SET endDate = ?  WHERE id = ?',
        [date.toIso8601String(), id.toString()]);
    return res;
  }
}
