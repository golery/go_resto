import 'package:flutter/material.dart';
import 'Model.dart';
import 'Utils.dart';
import 'TableOrderReviewPage.dart';
import 'Persistent.dart';

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
  final Map<String, int> newQuantities = {};

  _State(this.order) {
    this
        .order
        .dishes
        .forEach((dishId, quantity) => newQuantities[dishId] = quantity);
  }

  void onTapDish(Dish dish) {
    setState(() {
      var quantity = newQuantities[dish.id];
      if (quantity == null) {
        newQuantities[dish.id] = 1;
      } else {
        newQuantities[dish.id] = quantity + 1;
      }
    });
  }

  void _onReview() async {
    bool confirm = await Navigate.pushPage(
        context, new TableOrderReviewPage(order, newQuantities));
    if (confirm) {
      order.dishes = newQuantities;
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
    var dishListTiles = Repository
        .get()
        .dishCategories
        .map((category) => new ExpansionTile(
            title: new Text(category.name),
            initiallyExpanded: true,
            children: category.dishes.map((dish) {
              var quantity = newQuantities[dish.id] == null
                  ? null
                  : newQuantities[dish.id];
              var trailing = quantity == null
                  ? null
                  : new Text('${quantity}',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.orange));
              return new ListTile(
                title: new Text(dish.name),
                trailing: trailing,
                onTap: () => onTapDish(dish),
              );
            }).toList()))
        .toList();
    var listView = new ListView(children: dishListTiles);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Table Order'),
          actions: [new IconButton(icon: new Icon(Icons.delete), onPressed: _onDelete)],
        ),
        body: new Column(children: <Widget>[
          new Expanded(child: listView),
          new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Layout.pad(new RaisedButton(
                child: new Text('REVIEW'), onPressed: _onReview)),
            Layout.pad(new RaisedButton(
                child: new Text('CANCEL'), onPressed: () => Navigator.of(context).pop()))
          ])
        ]));
  }
}
