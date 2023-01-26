class SubscriptionEntity {
  int id;
  String detail;
/*  DateTime startDate;
  DateTime endDate;*/
  int lessonNumbers;
  int workshopId;

  SubscriptionEntity(this.id, this.detail,
      //this.startDate, this.endDate,
      this.lessonNumbers,  this.workshopId);

  SubscriptionEntity.fromMap(Map<String, dynamic> item):
        id=item["id"], detail = item["detail"], lessonNumbers = item["number"], workshopId = item["workshopId"];

  Map<String, Object> toMap(){
    return {'id':id,'detail': detail, 'number':lessonNumbers, 'workshopId':workshopId};
  }
}