import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:subscription/model/workshop.dart';
import 'package:subscription/repo.dart';

import 'edit_view_model.dart';
import 'main.dart';

class EditPage extends StatefulWidget {
  EditPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<EditPage> createState() => _EditPageState(id: id);
}

class _EditPageState extends State<EditPage> {
  final int id;

  _EditPageState({required this.id});

  final EditViewModel _editViewModel = EditViewModel(Repo());

  final DateFormat _formattedDate = DateFormat('dd.MM.yyyy');

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final _nameController = TextEditingController();
  final _labelController = TextEditingController();
  final _numberController = TextEditingController();

  void _setStartDate(DateTime? startDate) {
    setState(() {
      _startDate = startDate ?? DateTime.now();
      _editViewModel.editStartDate(_startDate);
    });
  }

  void _setEndDate(DateTime? endDate) {
    setState(() {
      _endDate = endDate ?? DateTime.now();
      _editViewModel.editEndDate(_endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Новий"),
          leading: BackButton(
            onPressed: () => _openMainPage(),
          ),
        ),
        body: FutureBuilder<Workshop>(
            future: _editViewModel.getById(id),
            builder: (context, snapshot) {
              _nameController.text = snapshot.data?.name ?? '';
              _labelController.text =
                  snapshot.data?.subscriptions[0].detail ?? '';
              _numberController.text =
                  (snapshot.data?.subscriptions[0].lessonNumbers ?? 0)
                      .toString();
              _startDate =
                  snapshot.data?.subscriptions[0].startDate ?? DateTime.now();
              _endDate =
                  snapshot.data?.subscriptions[0].endDate ?? DateTime.now();
              return ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    onChanged: (text) async {
                      debugPrint("change " + text);
                      await _editViewModel.editName(text);
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Назва',
                        hintText: 'Введіть назву'),
                  ),
                  TextFormField(
                    controller: _labelController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Мітка',
                        hintText: 'Детальніше'),
                    onChanged: (text) async {
                      await _editViewModel.editLabel(text);
                    },
                  ),
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Заплановано занять',
                        hintText: '0'),
                    onChanged: (text) async {
                      await _editViewModel.editLessonsNumber(text);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 2),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      _setStartDate(pickedDate);
                    },
                    child: Text(
                        'Дата старту ${_formattedDate.format(_startDate)}'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 2),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      _setEndDate(pickedDate);
                    },
                    child:
                        Text('Дата кінця ${_formattedDate.format(_endDate)}'),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 16.0, top: 32),
                            child: Text(
                              'Відвідані заняття',
                              style: TextStyle(
                                color: Colors.lightGreen.shade900,
                                fontSize: 18,
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 16.0, top: 32),
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'Відвідано заняття',
                              onPressed: () {
                                var sub = snapshot.data?.subscriptions[0];
                                if (sub != null) {
                                  _editViewModel.addLesson(sub);
                                  setState(() {});
                                }
                              },
                            ))
                      ]),
                  _lessons(snapshot.data)
                ],
              );
            }));
  }

  Widget _lessons(Workshop? workshop) {
    if (workshop?.subscriptions[0].lessons.isEmpty ?? true) {
      return const Text("");
    }
    var lessons = workshop?.subscriptions[0].lessons ?? List.empty();
    var format = DateFormat("dd.MM");
    var shape = RoundedRectangleBorder(
      side: const BorderSide(
        color: Colors.black12,
      ),
      borderRadius: BorderRadius.circular(4.0),
    );
    return ListView.builder(
      shrinkWrap: true,
      itemCount: lessons.length,
      // The length Of the array

      itemBuilder: (context, index) => Card(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        child: Text(format.format(lessons[index].date)),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: lessons[index].date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          setState(() {
                            _editViewModel.updateLessonDate(
                                lessons[index], pickedDate);
                          });
                        }),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Видалити',
                      onPressed: () {
                        setState(() {
                          _editViewModel.deleteLesson(lessons[index]);
                        });
                      },
                    )
                  ])),
          elevation: 2,
          borderOnForeground: true,
          shape: shape),
    );
  }

  void _openMainPage() {
    Navigator.of(context).pop("Update");
  }
}
