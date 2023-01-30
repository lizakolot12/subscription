import 'package:subscription/model/lesson.dart';

class Subscription {
  int id;
  String detail;
  DateTime startDate;
  DateTime endDate;
  int lessonNumbers;
  List<Lesson> lessons;
  int workshopId;

  Subscription(this.id, this.detail, this.startDate, this.endDate,
      this.lessonNumbers, this.lessons, this.workshopId);

  @override
  String toString() {
    return "Subscription : $id $detail $startDate $endDate $lessonNumbers $lessons $workshopId";
  }
}
