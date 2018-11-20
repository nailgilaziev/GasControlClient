import 'package:flutter/material.dart';
import 'package:village/widgets/refresh_button.dart';

class ErrorBlock extends StatelessWidget {
  final String msg;

  ErrorBlock(this.msg);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Text(msg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepOrange)),
        ),
        RefreshButton()
      ],
    );
  }
}
