class SubscriptionEntity {
  int id = 0;
  String detail;
/*  DateTime startDate;
  DateTime endDate;*/
  int lessonNumbers;
  int workshopId;

  SubscriptionEntity(this.detail,
      //this.startDate, this.endDate,
      this.lessonNumbers,  this.workshopId);

  SubscriptionEntity.fromMap(Map<String, dynamic> item):
        id=item["id"],
        detail = item["detail"], lessonNumbers = item["number"], workshopId = item["workshopId"];

  Map<String, Object> toMap(){
    return {
      //'id':id,
      'detail': detail, 'number':lessonNumbers, 'workshopId':workshopId};
  }
}