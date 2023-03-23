import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription/repo.dart';

import 'main.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final DateFormat _formattedDate = DateFormat('dd.MM.yyyy');
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  final _nameController = TextEditingController();
  final _labelController = TextEditingController();
  final _numberController = TextEditingController();

  void _setStartDate(DateTime? startDate) {
    setState(() {
      _startDate = startDate;
    });
  }

  void _setEndDate(DateTime? endDate) {
    setState(() {
      _endDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Новий"),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Назва',
                        hintText: 'Введіть назву'),
                  ),
                  TextField(
                    controller: _labelController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Мітка',
                        hintText: ''),
                  ),
                  TextField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Заплановано занять',
                        hintText: '0'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 2),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          //get today's date
                          firstDate: DateTime(2000),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));
                      _setStartDate(pickedDate);
                    },
                    child: Text('Дата старту ${_formattedDate.format(_startDate ?? DateTime.now())}'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 2),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      _setEndDate(pickedDate);
                    },
                    child: Text('Дата кінця ${_formattedDate.format(_endDate ?? DateTime.now())}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          var repo = Repo();
                          var lessonsNumber = 0;
                          try {
                            lessonsNumber = int.parse(_numberController.text);
                          } catch (e) {}
                          debugPrint("start:" + _startDate.toString());
                          debugPrint("end:" + _endDate.toString());
                          repo.createWorkshop(_nameController.text,
                              _labelController.text, lessonsNumber, _startDate ?? DateTime.now(), _endDate ?? DateTime.now());
                          _openMainPage();
                        },
                        child: const Text('Зберегти'),
                      )
                    ],
                  )
                ],
              ),
            )
            )],
        ));
  }

  void _openMainPage() {
    Navigator.of(context).pop("Update");
  }

  Route _mainRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MyHomePage(title: 'Абонементи'),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
