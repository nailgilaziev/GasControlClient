import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:village/widgets/center_progress.dart';
import 'package:village/widgets/error_block.dart';
import 'package:village/measurement.dart';
import 'package:village/measurements_block.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  List<Measurement> measurements;
  String err;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void refresh() {
    setState(() {
      err = null;
      measurements = null;
    });
    loadData();
  }

  void loadData() {
    http
        .get(
            "https://api.thingspeak.com/channels/232245/feeds.json?api_key=68HPT3KL3FSQ7LU0&results=6")
        .then((r) {
      try {
        Map<String, dynamic> jm = json.decode(r.body);
        List js = jm['feeds'];
        measurements = js.map((j) => Measurement.fromJson(j)).toList();
        measurements.first.time =
            measurements.first.time.subtract(Duration(minutes: 30));
        for (int i = 0; i < measurements.length - 1; i++) {
          var m = measurements[i];
          var nm = measurements[i + 1];
          m.durationBetweenThisAndNext = nm.time.difference(m.time);
        }
      } catch (e) {
        print(e);
        err = "Произошла ошибка при обработке данных с севера:\n$e";
      }
      setState(() {});
    }).catchError((e) {
      err =
          'Произошла ошибка при получении данных из интернета:\n$e\nПроверьте наличие подключения к интернету';
      setState(() {});
    });
  }

  Widget _buildBody(BuildContext context) {
    if (measurements == null) return CenterProgress();
    return MeasurementsBlock(measurements.reversed, err);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body: _buildBody(context));
  }
}
