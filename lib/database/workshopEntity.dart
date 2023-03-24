class WorkshopEntity {
  int id = 0;
  String name;

  WorkshopEntity(this.name);

  WorkshopEntity.Full( this.id, this.name);

  WorkshopEntity.fromMap(Map<String, dynamic> item):
        id = item["id"],
        name = item["name"];

  Map<String, Object> toMap() {
    return {'name': name};
  }
}
