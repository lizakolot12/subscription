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
    var list = await _repo.getAll();
    if (_data == null) {
      _data = [];
      for (var i = 0; i < list.length; i++) {
        _data?.add(WorkshopView(list[i], list[i].subscriptions[0]));
      }
    } else {
      var temporary = <WorkshopView>[];
      try {
        for (var i = 0; i < list.length; i++) {
          WorkshopView? current =
              _data?.firstWhereOrNull((m) => m.workshop.id == list[i].id);
          var active = list[i].subscriptions[0];
          if (current?.active != null) {
            active = list[i].subscriptions.firstWhereOrNull(
                    (element) => element.id == current?.active.id) ??
                list[i].subscriptions[0];
          }

          temporary.add(WorkshopView(list[i], active));
        }
        _data = temporary;
      } catch (e) {
        debugPrint(e.toString());
      }
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
    _repo.createLesson(subscription.id, DateTime.now());
  }

  void copy(WorkshopView workshopView) {
    _repo.createSubscription(
        workshopView.active.workshopId,
        workshopView.active.detail + "_copy",
        workshopView.active.lessonNumbers,
        workshopView.active.startDate,
        workshopView.active.endDate);
  }

  void deleteWorkshop(WorkshopView workshopView) {
    _repo.deleteWorkshop(workshopView.workshop.id);
  }
}
