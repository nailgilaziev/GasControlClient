import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:village/app_page.dart';
import 'package:village/measurement.dart';
import 'package:village/refresh_callback.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Деревенский датчик',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Показания деревенского датчика'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Measurement> measurements;
  String err;

  Timer refreshTimer;

  @override
  void initState() {
    super.initState();
    turnOnAutoSync();
    WidgetsBinding.instance.addObserver(this);
  }

  void turnOnAutoSync() {
    if (refreshTimer != null) {
      print("no need to turn on auto sync - is on currently");
      return;
    } else {
      refresh();
    }
    print("---turnOnAutoSync");
    refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      refresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("paused");
      turnOffAutoSync();
    }
    if (state == AppLifecycleState.inactive) {
      print("inactive");
      turnOffAutoSync();
    }
    if (state == AppLifecycleState.resumed) {
      turnOnAutoSync();
    }
  }

  void turnOffAutoSync() {
    print("---turnOffAutoSync");
    if (refreshTimer != null) {
      refreshTimer.cancel();
      refreshTimer = null;
    }
  }

  Future<void> refresh() {
    setState(() {
      err = null;
    });
    var act = measurements?.first?.time;
    if (act == null || DateTime
        .now()
        .difference(act)
        .inMinutes > 3)
      return loadData();
    else
      return Future.delayed(Duration(seconds: 1));
  }

  Future<void> loadData() {
    var url =
        "https://api.thingspeak.com/channels/232245/feeds.json?api_key=68HPT3KL3FSQ7LU0&results=6";
    print("HTTP CALL STARTED");
    print(url);
    return http.get(url).then((r) {
      try {
        var body = r.body;
        print(body);
        Map<String, dynamic> jm = json.decode(body);
        List js = jm['feeds'];
        measurements = js.map((j) => Measurement.fromJson(j)).toList();
        for (int i = 0; i < measurements.length - 1; i++) {
          var m = measurements[i];
          var nm = measurements[i + 1];
          m.durationBetweenThisAndNext = nm.time.difference(m.time);
        }
        measurements = measurements.reversed.toList();
      } catch (e) {
        print(e);
        err =
        "Получение данных с севера в данный момент времени невозможно. Попробуйте обновить (или просто вернуться в приложение) чуть позже.\nПричина:\n$e";
      }
      setState(() {});
    }).catchError((e) {
      err =
      'Произошла ошибка при получении данных из интернета:\n$e\nПроверьте наличие подключения к интернету';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body: RefreshCallbackWidget(
          callback: refresh,
          child: AppPage(
            measurements: measurements,
            err: err,
          ),
        ));
  }
}
