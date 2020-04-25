import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart' as CoreUuid;

class Layout {
  static Widget pad(Widget widget, {EdgeInsetsGeometry padding, double top, double bottom, double left, double right}) {
    if (padding == null) padding = EdgeInsets.all(16.0);
    return new Padding(padding: padding, child: widget);
  }
}

class Navigate {
  static dynamic pushPage(BuildContext context, Widget widget) async {
    return await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}

class Uuid {
  static CoreUuid.Uuid _uuid = new CoreUuid.Uuid();
  static String v4() {
    return _uuid.v4();
  }
}
