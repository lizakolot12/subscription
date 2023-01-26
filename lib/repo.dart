import 'package:subscription/database/workshopEntity.dart';
import 'package:subscription/model/lesson.dart';
import 'package:subscription/model/subscription.dart';
import 'package:subscription/model/workshop.dart';

import 'database/data.dart';

class Repo {
  final List<Workshop> _workshops = [];
  List<Workshop> getAll(){
    var lessons = [Lesson(1, "description", DateTime.now()), Lesson(2, "description2", DateTime.now())];
    var subscriptions = [Subscription(1, "detail", DateTime.now(), DateTime.now(), 3, lessons, 1)];
    _workshops.add(Workshop(1, "ddd", subscriptions));
    return _workshops;
  }

  //String name, String detail, int lessonNumber,
  //       DateTime startDate, DateTime endDate

  void create() {
    DatabaseService().createItem(WorkshopEntity("name"));
  }
}