import 'package:flutter/material.dart';
import 'package:village/refresh_callback.dart';

class RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new RaisedButton(
        child: new Text('Обновить'),
        onPressed: RefreshCallbackWidget
            .of(context)
            .callback,
      ),
    );
  }
}
