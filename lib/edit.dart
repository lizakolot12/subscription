import 'package:flutter/material.dart';
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

  /* DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();*/
  final _nameController = TextEditingController();
  final _labelController = TextEditingController();
  final _numberController = TextEditingController();

  void _setStartDate(DateTime? startDate) {
    setState(() {
      //  _startDate = startDate;
    });
  }

  void _setEndDate(DateTime? endDate) {
    setState(() {
      //_endDate = endDate;
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
              _labelController.text = snapshot.data?.subscriptions[0].detail ?? '';
              _numberController.text = (snapshot.data?.subscriptions[0].lessonNumbers ?? 0 ).toString();
              return Column(
                children: [
                  Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              onChanged: (text) async {
                                print('First text field: $text');
                                await _editViewModel.editName(text);
                                setState(() {

                                });
                              },
                              controller: _nameController,
                              decoration:  InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Назва',
                                  hintText: 'Введіть назву'),
                            ),
                            TextField(
                              controller: _labelController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Мітка',
                                  hintText: 'Детальніше'),
                            ),
                            TextField(
                              controller: _numberController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Заплановано занять',
                                  hintText: '0'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(elevation: 2),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: snapshot
                                            .data?.subscriptions[0].startDate ??
                                        DateTime.now(),
                                    //get today's date
                                    firstDate: DateTime(2000),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));
                                _setStartDate(pickedDate);
                              },
                              child: Text(
                                  'Дата старту ${_formattedDate.format(snapshot.data?.subscriptions[0].startDate ?? DateTime.now())}'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(elevation: 2),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: snapshot
                                            .data?.subscriptions[0].endDate ??
                                        DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));
                                _setEndDate(pickedDate);
                              },
                              child: Text(
                                  'Дата кінця ${_formattedDate.format(snapshot.data?.subscriptions[0].endDate ?? DateTime.now())}'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    var repo = Repo();
                                    var lessonsNumber = 0;
                                    try {
                                      lessonsNumber =
                                          int.parse(_numberController.text);
                                    } catch (e) {}

                                    _openMainPage();
                                  },
                                  child: const Text('Зберегти'),
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                ],
              );
            }));
  }

  void _openMainPage() {
    debugPrint("back!!!!!!!!!!!");
    Navigator.of(context).pop("Update");
  }
}
