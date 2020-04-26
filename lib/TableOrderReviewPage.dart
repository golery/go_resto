import 'package:flutter/material.dart';

import 'Model.dart';
import 'Utils.dart';

class TableOrderReviewPage extends StatefulWidget {
  final Order order;
  final Map<String, OrderItem> items;

  TableOrderReviewPage(this.order, this.items);

  @override
  State<TableOrderReviewPage> createState() {
    return new _State(order, items);
  }
}

class _State extends State<TableOrderReviewPage> {
  final Order order;
  final Map<String, OrderItem> items;

  _State(this.order, this.items);

  Widget _formatQuantity(int oldValue, int newValue) {
    if (oldValue == null) oldValue = 0;
    if (newValue == null) newValue = 0;
    int diff = newValue - oldValue;
    var oldValueText = new Text('$oldValue');
    if (diff == 0) return oldValueText;
    var diffText = diff < 0 ? ' ($diff)' : ' (+$diff)';
    var diffTextStyle = new TextStyle(
        fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.orange);

    return SizedBox(
      width: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        oldValueText,
        new Text(diffText, style: diffTextStyle)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    bool newOrder = order.items.isEmpty;
    Repository.get().dishCategories.forEach((category) {
      category.dishes.forEach((dish) {
        var oldQuantity = order.findItemByDishId(dish.id)?.quantity;
        var newItem = items[dish.id];
        var newQuantity = newItem?.quantity;
        if (newQuantity == null && oldQuantity == null) return;

        Widget trailing;
        if (newOrder) {
          trailing = new Text('$newQuantity',
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.orange));
        } else {
          trailing = _formatQuantity(oldQuantity, newQuantity);
        }
        String notes = newItem?.notes;
        children.add(new ListTile(
            title: new Text(dish.name),
            subtitle: notes == null ? null : Text(notes),
            trailing: trailing));
      });
    });
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Confirm order'),
        ),
        body: new Column(
            children: <Widget>[
              new Expanded(child: new ListView(children: children)),
              new Row(children: <Widget>[
                Layout.pad(new RaisedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('CONFIRM'))),
                Layout.pad(new RaisedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('CANCEL'))),
              ], mainAxisAlignment: MainAxisAlignment.center)
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center));
  }
}
