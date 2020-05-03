import 'package:flutter/material.dart';
import 'package:goresto/Constants.dart';
import 'package:goresto/service/Navigator.dart';
import 'package:goresto/widget/EditOrderItemPage.dart';

import '../Model.dart';
import '../Persistent.dart';
import '../TableOrderReviewPage.dart';
import '../Utils.dart';

class TableOrderPage extends StatefulWidget {
  final Order order;

  TableOrderPage(this.order);

  @override
  State<StatefulWidget> createState() {
    return new _State(order);
  }
}

class _State extends State<TableOrderPage> {
  final Order order;
  final Map<String, OrderItem> items = {};

  _State(this.order) {
    if (order.items == null) order.items = [];
    this
        .order
        .items
        .forEach((item) => items[item.dishId] = OrderItem.from(item));
  }

  void onTapDish(Dish dish) {
    setState(() {
      var item = items[dish.id];
      if (item == null) {
        item = OrderItem(dish.id);
        items[dish.id] = item;
      }
      ++item.quantity;
    });
  }

  void _onReview() async {
    bool confirm = await Navigate.push(context, Screen.TableOrderReviewPage,
        (context) => TableOrderReviewPage(order, items));
    if (confirm != null && confirm) {
      order.items = items.values.toList();
      Persistent.save();
      Navigator.of(context).pop(order);
    }
  }

  void _onDelete() {
    Repository.get().setCurrentOrder(order.tableId, null);
    Persistent.save();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var dishListTiles = Repository.get()
        .dishCategories
        .map((category) => new ExpansionTile(
            title: new Text(category.name),
            initiallyExpanded: true,
            children: category.dishes.map(_listTitle).toList()))
        .toList();
    var listView = new ListView(children: dishListTiles);
    var orderIdTxt = widget.order.seqId == null
        ? 'Create Order'
        : "Order # ${widget.order.seqId}";
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(orderIdTxt),
          actions: [
            new IconButton(icon: new Icon(Icons.delete), onPressed: _onDelete)
          ],
        ),
        body: new Column(children: <Widget>[
          new Expanded(child: listView),
          new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Layout.pad(new RaisedButton(
                child: new Text('REVIEW'), onPressed: _onReview)),
            Layout.pad(new RaisedButton(
                child: new Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop()))
          ])
        ]));
  }

  void _editItem(String dishId) {
    OrderItem item = items[dishId];
    Navigate.push(context, Screen.EditOrderItemPage,
        (context) => EditOrderItemPage(item));
  }

  ListTile _listTitle(dish) {
    OrderItem item = items[dish.id];
    String notes = item?.notes;
    num quantity = item?.quantity ?? 0;
    quantity = quantity == 0 ? null : quantity;
    var leading = SizedBox(
      width: 30,
      child: quantity == null
          ? null
          : Center(
              child: Text('${quantity}',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: COLOR_QUANTITY))),
    );
    var trailing = quantity == null
        ? null
        : OutlineButton.icon(
            onPressed: () {
              _editItem(dish.id);
            },
            icon: Icon(Icons.edit),
            label: Text("Edit"));
    return new ListTile(
      title: Text(dish.name),
      subtitle: notes == null ? null : Text(notes),
      leading: leading,
      trailing: trailing,
      onTap: () => onTapDish(dish),
    );
  }
}
