class Lesson {
  int lId;
  String description;
  DateTime date;

  Lesson(this.lId, this.description, this.date);
}

void main() {
  var le = Lesson(1, "dsd", DateTime.now());
  le.date;
}
