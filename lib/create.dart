import 'package:flutter/material.dart';
import 'package:subscription/repo.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String _startDate = '';
  String _endDate = '';

  void _setStartDate(String startDate) {
    setState(() {
      _startDate = startDate;
    });
  }

  void _setEndDate(String endDate) {
    setState(() {
      _endDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Абонементи"),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Назва',
                      hintText: 'Введіть назву'),
                ),
                const TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Мітка',
                      hintText: ''),
                ),
                const TextField(
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
                        initialDate: DateTime.now(),
                        //get today's date
                        firstDate: DateTime(2000),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));
                    _setStartDate(pickedDate?.toIso8601String() ?? 'd');
                  },
                  child: Text('Дата старту $_startDate'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 2),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    _setEndDate(pickedDate?.toIso8601String() ?? 'd');
                  },
                  child: Text('Дата кінця $_endDate'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(onSurface: Colors.pinkAccent),

                    onPressed: (){
                      var repo = Repo();
                      repo.create();
                    },
                    child: Text('Зберегти'),
                  )
                ],)

              ],
            ),
          );
        },
      ).build(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
