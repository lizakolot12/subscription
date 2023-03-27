import 'package:flutter/cupertino.dart';
import 'package:subscription/model/subscription.dart';
import 'package:subscription/model/workshop.dart';
import 'package:subscription/repo.dart';
import 'package:collection/collection.dart';

import 'main.dart';

class EditViewModel {
  final Repo _repo;
  int id = -1;
  Workshop? _current ;

  EditViewModel(this._repo);

  Future<Workshop> getById(int id) async {
    return await _repo.getBySubscriptionId(id).then((value) => _current = value);
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

  Future<int> editName(String text) {
    return  _repo.updateWorkshop(_current?.id ?? -1, text);
  }

  Future<int> editLabel(String text) {
    return  _repo.updateSubscriptionName(_current?.subscriptions[0].id ?? -1,  text);
  }

  Future<int> editLessonsNumber(String text) {
    var lessonsNumber = int.parse(text);
    return  _repo.updateLessonsNumber(_current?.subscriptions[0].id ?? -1,  lessonsNumber);
  }

  Future<int> editStartDate(DateTime date) {
    return  _repo.updateStartDate(_current?.subscriptions[0].id ?? -1,  date);
  }

  Future<int> editEndDate(DateTime date) {
    return  _repo.updateEndDate(_current?.subscriptions[0].id ?? -1,  date);
  }
}
