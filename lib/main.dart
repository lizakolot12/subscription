import 'package:flutter/material.dart';
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
  // List<Workshop> workshop = List.empty();

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

/* void _loadData() {

      Repo().getAll().then((value) => {
        workshop = value;
        setState();}
      );


  }*/

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
                    var activeSubscription =
                        (item?.subscriptions.length ?? 0) > 0
                            ? item?.subscriptions[0]
                            : null;
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(item?.name ?? "",
                                        textAlign: TextAlign.start)),
                                moreButton(activeSubscription)
                              ]),
                          Text(activeSubscription?.detail ?? ""),
                          Row(children: [
                            const Text("з"),
                            Text(activeSubscription?.startDate
                                    .toIso8601String() ??
                                "")
                          ]),
                          Row(children: [
                            const Text("по"),
                            Text(activeSubscription?.endDate
                                    .toLocal()
                                    .toIso8601String() ??
                                "")
                          ]),
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
        } else if (value == 2) {
          Repo().createSubscription(subscription?.workshopId ?? -1,
              "${subscription?.detail}_copy", subscription?.lessonNumbers ?? 8);
        } else if (value == 3) {
          Repo().deleteWorkshop(subscription?.workshopId ?? -1);
        }
      },
    );
  }
}
