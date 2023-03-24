import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription/create.dart';
import 'package:subscription/model/subscription.dart';
import 'package:subscription/repo.dart';
import 'package:subscription/view_model.dart';

import 'edit.dart';
import 'model/workshop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //   primarySwatch: Colors.blue,
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const MyHomePage(title: 'Абонементи'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ListViewModel _listViewModel = ListViewModel(Repo());

  Future<void> _openEditPage(int id) async {
    await Navigator.of(context)
        .push(_editRoute(id))
        .then((value) => setState(() {}));
  }

  Future<void> _openCreatePage() async {
    await Navigator.of(context)
        .push(_createRoute())
        .then((value) => setState(() {}));
  }

  void setActive(WorkshopView workshopView, Subscription subscription) {
    setState(() {
      _listViewModel.setActive(workshopView, subscription);
    });
  }

  void _loadData() {
    setState(() {});
  }

  Route _route(StatefulWidget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
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

  Route _createRoute() {
    return _route(const CreatePage());
  }

  Route _editRoute(int id) {
    return _route(EditPage(id: id));
  }

  @override
  Widget build(BuildContext context) {
    var format = DateFormat("dd-MM-yyyy");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<WorkshopView>>(
        future: _listViewModel.getAll(),
        initialData: List.empty(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data?.toList()[index];
                    var active = item?.active;
                    var lessonNow = active?.lessons.length ?? 0;
                    var lessonPlan = active?.lessonNumbers ?? 0;
                    var numberColor = Colors.black.withOpacity(1.0);
                    if ((lessonPlan - lessonNow) <= 2) {
                      numberColor = Colors.red;
                    }
                    var length = active?.lessons.length ?? 0;
                    var b = (active?.lessonNumbers ?? 0);
                    debugPrint("--- length = " +
                        length.toString() +
                        "---" +
                        b.toString());
                    return Card(
                        child: GestureDetector(
                      onTap: () {
                        debugPrint("must be open detail for " +
                            (item?.active.id ?? 0).toString());
                        _openEditPage(item?.active.id ?? -1);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(item?.workshop.name ?? "",
                                          textAlign: TextAlign.start)),
                                ),
                                Expanded(
                                    flex: 30,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8.0),
                                        child: Text(
                                            (active?.lessons.length ?? 0)
                                                    .toString() +
                                                " з " +
                                                (active?.lessonNumbers ?? 0)
                                                    .toString(),
                                            style: TextStyle(
                                                color: numberColor)))),
                                Expanded(flex: 10, child: moreButton(item!))
                              ]),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 2.0),
                              child: Text(
                                active?.detail ?? "",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )),
                          Row(children: [
                            const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text("з")),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(format.format(
                                    active?.startDate ?? DateTime.now())))
                          ]),
                          Row(children: [
                            const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text("по")),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                child: Text(format
                                    .format(active?.endDate ?? DateTime.now())))
                          ]),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: smallSubscriptions(item)),
                          ),
                        ],
                      ),
                    ));
                  },
                ).build(context)
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreatePage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget moreButton(WorkshopView workshopView) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        // PopupMenuItem 1
        PopupMenuItem(
          value: 1,
          // row with 2 children
          child: Row(
            children: const [
              Icon(Icons.check),
              SizedBox(
                width: 10,
              ),
              Text("Відвідано заняття")
            ],
          ),
        ),
        // PopupMenuItem 2
        PopupMenuItem(
          value: 2,
          // row with two children
          child: Row(
            children: const [
              Icon(Icons.copy),
              SizedBox(
                width: 10,
              ),
              Text("Копія абонементу")
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          // row with two children
          child: Row(
            children: const [
              Icon(Icons.delete),
              SizedBox(
                width: 10,
              ),
              Text("Видалити")
            ],
          ),
        )
      ],
      offset: const Offset(0, 100),
      color: Colors.grey,
      elevation: 2,
      // on selected we show the dialog box
      onSelected: (value) {
        // if value 1 show dialog
        if (value == 1) {
          _listViewModel.addLesson(workshopView.active);
          _loadData();
        } else if (value == 2) {
          _listViewModel.copy(workshopView);
          _loadData();
        } else if (value == 3) {
          _listViewModel.deleteWorkshop(workshopView);
          _loadData();
        }
      },
    );
  }

  List<Widget> smallSubscriptions(WorkshopView workshopView) {
    List<Widget> smallSubscriptions = [];
    for (Subscription subscription in workshopView.workshop.subscriptions) {
      smallSubscriptions.add(smallSubscription(workshopView, subscription));
    }
    return smallSubscriptions;
  }

  Widget smallSubscription(
      WorkshopView workshopView, Subscription subscription) {
    var numberColor = Colors.black.withOpacity(1.0);
    if ((subscription.lessonNumbers - subscription.lessons.length) <= 2) {
      numberColor = Colors.red;
    }
    var shape = RoundedRectangleBorder(
      side: const BorderSide(
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(15.0),
    );
    var elevation = 2.0;
    if (workshopView.active.id == subscription.id) {
      shape = RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.cyan,
        ),
        borderRadius: BorderRadius.circular(15.0),
      );
      elevation = 8.0;
    }
    return Card(
        child: GestureDetector(
            onTap: () {
              setActive(workshopView, subscription);
            },
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(subscription.detail)),
                Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                        (subscription.lessons.length).toString() +
                            " з " +
                            (subscription.lessonNumbers).toString(),
                        style: TextStyle(color: numberColor)))
              ],
            )),
        elevation: elevation,
        borderOnForeground: true,
        shape: shape);
  }
}

class WorkshopView {
  Workshop workshop;
  Subscription active;

  WorkshopView(this.workshop, this.active);
}
