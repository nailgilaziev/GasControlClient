import 'package:flutter/material.dart';

class RefreshCallbackWidget extends InheritedWidget {
  final RefreshCallback callback;

  RefreshCallbackWidget({
    Key key,
    @required this.callback,
    @required Widget child,
  }) : super(key: key, child: child);

  static RefreshCallbackWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(RefreshCallbackWidget);
  }

  @override
  bool updateShouldNotify(RefreshCallbackWidget old) {
    return old.callback != callback;
  }
}
