import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T> navigatorPush<T extends Object>(
    BuildContext context, WidgetBuilder builder) {
  return Navigator.of(context).push(MaterialPageRoute(builder: builder));
}
