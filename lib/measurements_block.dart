import 'package:flutter/material.dart';
import 'package:village/widgets/refresh_button.dart';
import 'package:village/measurement.dart';
import 'package:village/utils/texts.dart';
import 'package:village/utils/time.dart';
import 'package:village/widgets/gap_info.dart';

class MeasurementsBlock extends StatelessWidget {
  final Iterable<Measurement> measurements;
  final String err;

  MeasurementsBlock(this.measurements, this.err);

  Widget toMeasurement(Measurement m) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildGapItem(m),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("Подача: ${m.outTemp} °C",
                          style: TextStyle(color: Colors.deepOrange)),
                      Text("Цель: ${m.position} °C"),
                      Text("Возвратка: ${m.inTemp} °C",
                          style: TextStyle(color: Colors.blue))
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text("${m.roomTemp} °C",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 32.0)),
                      Text("Влажность ${m.roomHumidity} %",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 10.0,
                              color: Colors.grey[600])),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(relativeTime(m.time),
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var items = List<Widget>();
    items.add(buildHeaders());
    items.addAll(measurements.map(toMeasurement));
    items.add(buildParagraph(heatUpActionMsg(measurements.first.position)));
    items.add(buildParagraph(gapExplanation));

    return SingleChildScrollView(child: Column(children: items));
  }

  Widget buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  Widget buildHeaders() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Text("Котёл",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                flex: 2,
                child: Text("Помещение",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                flex: 1,
                child: Text("", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      );

  Widget buildGapItem(Measurement m) {
    var gap = m.durationBetweenThisAndNext;
    if (gap == null) {
      gap = DateTime.now().difference(m.time);
    }
    return GapInfo();
  }
}
