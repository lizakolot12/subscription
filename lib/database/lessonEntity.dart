
import '../model/lesson.dart';

class LessonEntity {
  int lId = 0;
  DateTime date;
  int subscriptionId;

  LessonEntity(this.date, this.subscriptionId);

  LessonEntity.fromMap(Map<String, dynamic> item)
      : lId = item["id"],
        date = DateTime.parse(item["date"]),
        subscriptionId = item["subscriptionId"];

  Map<String, Object> toMap() {
    return {'date': date.toIso8601String(), 'subscriptionId': subscriptionId};
  }
}
