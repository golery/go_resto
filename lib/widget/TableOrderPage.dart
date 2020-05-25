import 'package:flutter/material.dart';
import 'package:goresto/Constants.dart';
import 'package:goresto/service/Factory.dart';
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
  List<OrderItem> items;

  _State(this.order) {
    if (order.items == null) order.items = [];
    items = this
        .order
        .items
        .map((item) => OrderItem.from(item))
        .toList(growable: true);
  }

  void onTapDish(Dish dish) {
    var item = OrderItem(dish.id);
    item.quantity = 1;
    items.add(item);
    factory.analytics
        .logEvent(name: "evTapDish", parameters: {'evDish': dish.name});
    setState(() {});
  }

  void _onReview() async {
    bool confirm = await Navigate.push(context, Screen.TableOrderReviewPage,
        (context) => TableOrderReviewPage(order, items));
    if (confirm != null && confirm) {
      order.items = items;
      Persistent.save();
      Navigator.of(context).pop(order);
    }
  }

  void _onDelete() {
    Repository.get().setCurrentOrder(order.tableId, null);
    Persistent.save();
    Navigator.of(context).pop();
  }

  bool hasItem() {
    return items.isNotEmpty;
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
                child: new Text('REVIEW'),
                onPressed: hasItem() ? _onReview : null)),
            Layout.pad(new RaisedButton(
                child: new Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop()))
          ])
        ]));
  }

  num _getQuantity(String dishId) {
    return items
        .where((item) => item.dishId == dishId)
        .map((e) => e.quantity)
        .reduce((a, b) => a + b);
  }

  void _editItem(String dishId) async {
    List<OrderItem> toEdit =
        items.where((item) => item.dishId == dishId).toList();
    await Navigate.push(context, Screen.EditOrderItemPage,
        (context) => EditOrderItemPage(dishId, toEdit));

    items.removeWhere((item) => item.dishId == dishId);
    items.addAll(toEdit);
    setState(() {});
  }

  ListTile _listTitle(dish) {
    var dishItems = items.where((item) => item.dishId == dish.id).toList();
    num quantity = dishItems.length;
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
    return ListTile(
      title: Text(dish.name),
      leading: leading,
      trailing: trailing,
      onTap: () => onTapDish(dish),
    );
  }
}
