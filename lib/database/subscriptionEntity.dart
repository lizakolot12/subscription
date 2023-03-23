import 'package:flutter/cupertino.dart';

class SubscriptionEntity {
  int id = 0;
  String detail;
  DateTime startDate;
  DateTime endDate;
  int lessonNumbers;
  int workshopId;

  SubscriptionEntity(this.detail, this.lessonNumbers, this.workshopId,
      this.startDate, this.endDate);

  SubscriptionEntity.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        detail = item["detail"],
        lessonNumbers = item["number"],
        workshopId = item["workshopId"],
        startDate = DateTime.parse(item["startDate"]),
        endDate = DateTime.parse(item["endDate"]);

  Map<String, Object> toMap() {
    debugPrint("toMap" + startDate.toIso8601String());
    return {
      //'id':id,
      'detail': detail,
      'number': lessonNumbers,
      'workshopId': workshopId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String()
    };
  }
}
