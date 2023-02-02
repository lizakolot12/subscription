import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription/create.dart';
import 'package:subscription/model/subscription.dart';
import 'package:subscription/repo.dart';

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
        primarySwatch: Colors.blue,
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
  Subscription? _active = null;

  void _openCreatePage() {
    /* setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });*/
    Navigator.of(context).push(_createRoute());
  }

  void setActive(Subscription subscription) {
    setState(() {
      _active = subscription;
    });
  }

  void _loadData() {
    setState(() {});
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CreatePage(),
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

  @override
  Widget build(BuildContext context) {
    var format = DateFormat("dd-MM-yyyy"); //.format(YOUR_DATETIME_HERE)
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Workshop>>(
        future: Repo().getAll(),
        initialData: List.empty(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data?.toList()[index];
                    _active ??= (item?.subscriptions.length ?? 0) > 0
                          ? item?.subscriptions[0]
                          : null;
                    var lessonNow = _active?.lessons.length ?? 0;
                    var lessonPlan = _active?.lessonNumbers ?? 0;
                    var numberColor = Colors.black.withOpacity(1.0);
                    if ((lessonPlan - lessonNow) <= 2) {
                      numberColor = Colors.red;
                    }
                    return Card(
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
                                      child: Text(item?.name ?? "",
                                          textAlign: TextAlign.start)),
                                ),
                                Expanded(
                                    flex: 30,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8.0),
                                        child: Text(
                                            (_active?.lessons.length ?? 0)
                                                    .toString() +
                                                " з " +
                                                (_active?.lessonNumbers ?? 0)
                                                    .toString(),
                                            style: TextStyle(
                                                color: numberColor)))),
                                Expanded(flex: 10, child: moreButton(_active))
                              ]),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 2.0),
                              child: Text(
                                _active?.detail ?? "",
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
                                    _active?.startDate ?? DateTime.now())))
                          ]),
                          Row(children: [
                            const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text("по")),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                child: Text(format.format(
                                    _active?.endDate ?? DateTime.now())))
                          ]),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: smallSubscriptions(
                                    item?.subscriptions ?? List.empty(),
                                    _active)),
                          ),
                        ],
                      ),
                    );
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

  Widget moreButton(Subscription? subscription) {
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
          Repo().createLesson(
              subscription?.workshopId ?? -1, DateTime.now().toString());
          _loadData();
        } else if (value == 2) {
          Repo().createSubscription(subscription?.workshopId ?? -1,
              "${subscription?.detail}_copy", subscription?.lessonNumbers ?? 8);
          _loadData();
        } else if (value == 3) {
          Repo().deleteWorkshop(subscription?.workshopId ?? -1);
          _loadData();
        }
      },
    );
  }

  List<Widget> smallSubscriptions(
      List<Subscription> subscriptions, Subscription? active) {
    List<Widget> smallSubscriptions = [];
    for (Subscription subscription in subscriptions) {
      smallSubscriptions
          .add(smallSubscription(subscription, subscription.id == active?.id));
    }
    return smallSubscriptions;
  }

  Widget smallSubscription(Subscription subscription, bool active) {
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
    if (active) {
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
              setActive(subscription);
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
