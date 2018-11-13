import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: new RaisedButton(child: new Text('Обновить'), onPressed: () {}),
    );
  }
}
