import 'package:flutter/material.dart';
import 'package:village/utils/time.dart';

class GapInfo extends StatelessWidget {
  final Duration gap;

  const GapInfo({Key key, this.gap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var msg = gapMessage(gap);
    if (msg != null)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.orange, fontSize: 20.0),
        ),
      );
    else
      return Container();
  }
}
