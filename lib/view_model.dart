import 'package:flutter/cupertino.dart';
import 'package:subscription/model/subscription.dart';
import 'package:subscription/repo.dart';
import 'package:collection/collection.dart';

import 'main.dart';

class ListViewModel {
  final Repo _repo;
  List<WorkshopView>? _data;

  ListViewModel(this._repo);

  Future<List<WorkshopView>> getAll() async {
    debugPrint("get all");
    var list = await _repo.getAll();
    if (_data == null) {
      _data = [];
      for (var i = 0; i < list.length; i++) {
        _data?.add(WorkshopView(list[i], list[i].subscriptions[0]));
      }
      debugPrint("from data null ");
    } else {
      var temporary = <WorkshopView>[];
      try {
        for (var i = 0; i < list.length; i++) {
          debugPrint("i = " + i.toString());
          WorkshopView? current =
              _data?.firstWhereOrNull((m) => m.workshop.id == list[i].id);
          debugPrint("!!!!!!!!!");
          debugPrint(i.toString()+ " current = " + current.toString());
           Subscription? c = current?.active;
          debugPrint(i.toString()+ " sub = " +c.toString());
          temporary.add(WorkshopView(
              list[i], current?.active ?? list[i].subscriptions[0]));
          debugPrint("added" + temporary.length.toString());
        }
        _data = temporary;
      } catch (e) {
        debugPrint(e.toString());
      }
      debugPrint("from exist ");
      print(_data?.length);
    }
    return _data ?? List.empty();
  }

  void setActive(WorkshopView workshopView, Subscription subscription) {
    _data
        ?.firstWhere(
            (element) => element.workshop.id == workshopView.workshop.id)
        .active = subscription;
  }

  void addLesson(Subscription subscription) {
    _repo.createLesson(subscription.id, DateTime.now().toString());
  }

  void copy(WorkshopView workshopView) {
    _repo.createSubscription(
        workshopView.active.workshopId,
        workshopView.active.detail + "_copy",
        workshopView.active.lessonNumbers);
  }

  void deleteWorkshop(WorkshopView workshopView) {
    _repo.deleteWorkshop(workshopView.workshop.id);
  }
}
