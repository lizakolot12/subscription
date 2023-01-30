import 'package:subscription/model/subscription.dart';

class Workshop {
  int id;
  String name;
  List<Subscription> subscriptions;

  Workshop(this.id, this.name, this.subscriptions);
  @override
  String toString() {
    return "Workshop " + id.toString() + " " + name + "  " + subscriptions.toString();
  }

}
