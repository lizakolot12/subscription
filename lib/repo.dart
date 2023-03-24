import 'package:subscription/database/subscriptionEntity.dart';
import 'package:subscription/database/workshopEntity.dart';
import 'package:subscription/model/workshop.dart';

import 'database/data.dart';
import 'database/lessonEntity.dart';

class Repo {
  static final Repo _instance = Repo._internal();

  factory Repo() {
    return _instance;
  }

  Repo._internal() {
    // initialization logic
  }

  final databaseService = DatabaseService();

  Future<List<Workshop>> getAll() async {
    var list = await databaseService.getAll();
    return list;
  }

  void createWorkshop(String name, String detail, int lessonNumber,
      DateTime startDate, DateTime endDate) {
    databaseService.createItem(WorkshopEntity(name)).then((value1) =>
        databaseService.createSubscription(SubscriptionEntity(
            detail, lessonNumber, value1, startDate, endDate)));
  }

  void createSubscription(int workshopId, String detail, int lessonNumber,
      DateTime startDate, DateTime endDate) {
    databaseService.createSubscription(SubscriptionEntity(
        detail, lessonNumber, workshopId, startDate, endDate));
  }

  void deleteWorkshop(int workshopId) {
    databaseService.deleteWorkshop(workshopId);
  }

  void createLesson(int subscriptionId, DateTime date) {
    databaseService.createLesson(LessonEntity(
      date,
      subscriptionId,
    ));
  }
}
