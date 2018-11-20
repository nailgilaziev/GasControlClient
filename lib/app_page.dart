import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:village/measurement.dart';
import 'package:village/refresh_callback.dart';
import 'package:village/utils/texts.dart';
import 'package:village/utils/time.dart';
import 'package:village/widgets/center_progress.dart';
import 'package:village/widgets/error_block.dart';
import 'package:village/widgets/gap_info.dart';

class AppPage extends StatelessWidget {
  final List<Measurement> measurements;
  final String err;

  const AppPage({Key key, this.measurements, this.err}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (measurements == null) return CenterProgress();
    return RefreshIndicator(
        child: ListView(
          children: buildContent(context),
        ),
        onRefresh: RefreshCallbackWidget.of(context).callback);
  }

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

  List<Widget> buildContent(BuildContext context) {
    var items = List<Widget>();
    if (err != null) {
      items.add(ErrorBlock(err));
    } else {
      items.add(buildHeaders());
      items.addAll(measurements.map(toMeasurement));
    }
    items.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        onPressed: () {
          _launchURL(
              'https://thingspeak.com/apps/matlab_visualizations/192553');
        },
        child: Text('График мониторинга без пароля'),
      ),
    ));
    items.add(buildParagraph(
        'Для просмотра всех графиков нужно будет авторизоваться на сайте. Можно использовать учетку nail.gilaziev@gmail.com / pr00CESSmw'));
    items.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        onPressed: () {
          _launchURL('https://thingspeak.com/channels/232245/private_show');
        },
        child: Text('Посмотреть все графики с паролем'),
      ),
    ));
    items.add(buildParagraph(heatUpActionMsg(measurements.first.position)));
    items.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        onPressed: () {
          var bodyPrefixSymbol = '&';
          var heatUpVal = heatUpActionValue(measurements.first.position);
          if (Theme.of(context).platform == TargetPlatform.android) {
            bodyPrefixSymbol = '?';
            heatUpVal = heatUpVal.substring(1);
          }
          var url = 'sms:$PHONE_NUMBER${bodyPrefixSymbol}body=$heatUpVal';
          print(url);
          _launchURL(url);
        },
        child: Text('Открыть окно для отправки SMS'),
      ),
    ));
    items.add(buildParagraph(gapExplanation));

    return items;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
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
    return GapInfo(gap: gap);
  }
}
