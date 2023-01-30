import 'package:flutter/foundation.dart';
import 'package:subscription/database/subscriptionEntity.dart';
import 'package:subscription/database/workshopEntity.dart';
import 'package:subscription/model/lesson.dart';
import 'package:subscription/model/subscription.dart';
import 'package:subscription/model/workshop.dart';

import 'database/data.dart';
import 'database/lessonEntity.dart';

class Repo {
  final List<Workshop> _workshops = [];

  List<Workshop> getAll() {
    var list = DatabaseService().getAll().then((value) => print(value));
    var lessons = [
      Lesson(1, "description", DateTime.now()),
      Lesson(2, "description2", DateTime.now())
    ];
    var subscriptions = [
      Subscription(1, "detail", DateTime.now(), DateTime.now(), 3, lessons, 1)
    ];
    _workshops.add(Workshop(1, "ddd", subscriptions));
    return _workshops;
  }

  //String name, String detail, int lessonNumber,
  //       DateTime startDate, DateTime endDate

  void create() {
    DatabaseService().createItem(WorkshopEntity("name")).then((value1) =>
        DatabaseService()
            .createSubscription(SubscriptionEntity("detail", 8, value1))
            .then((value2) => DatabaseService().createLesson(LessonEntity(
                  'dddd',
                  value2,
                ))));
  }
}
