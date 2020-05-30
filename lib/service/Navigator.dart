import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Screen {
  TablePage,
  TableOrderReviewPage,
  EditOrderItemPage,
  ManageMenuPage,
  ManageTablePage,
  AboutPage,
  EditDishPage,
  EditMenuCategoryPage,
  EditTablePage,
  BillPage,
  BillSettings,
}

class Navigate {
  static Future<T> push<T extends Object>(
      BuildContext context, Screen name, WidgetBuilder builder) async {
    return await Navigator.of(context).push(new MaterialPageRoute(
      builder: builder,
      // For firebase analytics to track screen name
      settings: RouteSettings(name: name.toString()),
    ));
  }

  static void pop(BuildContext context, Object result) {
    Navigator.pop(context, result);
  }
}
