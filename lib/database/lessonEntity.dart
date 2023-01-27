
class LessonEntity {
    int lId = 0;
/*    String description;*/
    String date;
    int subscriptionId;

    LessonEntity(
        //required this.lId,
        // this.description,
        this.date,  this.subscriptionId);

    LessonEntity.fromMap(Map<String, dynamic> item):
            lId=item["id"],
           // description= item["description"],
            date = item["date"], subscriptionId = item["subscriptionId"];

    Map<String, Object> toMap(){
        return {
            //'id':lId,
           // 'description': description,
            'date':date, 'subscriptionId':subscriptionId};
    }
}