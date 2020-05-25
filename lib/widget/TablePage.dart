import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';
import 'package:goresto/Persistent.dart';
import 'package:goresto/service/Factory.dart';
import 'package:goresto/service/Navigator.dart';
import 'package:goresto/widget/BillPage.dart';
import 'package:goresto/widget/TableOrderPage.dart';

class TablePage extends StatefulWidget {
  RestoTable table;

  TablePage(this.table);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TablePage> {
  int status = 0;

  @override
  Widget build(BuildContext context) {
    var table = widget.table;
    var order = Repository.get().getCurrentOrder(table.id);
//    if (order == null) {
//      order = new Order(table.id);
//      Navigate.push(
//          context, Screen.ManageTablePage, (context) => TableOrderPage(order));
//    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Table ${table.name}"),
        actions: <Widget>[],
      ),
      body: _body(order),
      bottomNavigationBar: _footer(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _ok,
//        child: Icon(Icons.check),
//      ),
    );
  }

  String _statusText(ItemStatus status) {
    if (status == ItemStatus.COOK) {
      return "Cook";
    }
    if (status == ItemStatus.READY) {
      return "Ready";
    }
    if (status == ItemStatus.SERVED) {
      return "Served";
    }
    return "Order";
  }

  Color _statusColor(ItemStatus status) {
    if (status == ItemStatus.COOK) {
      return Colors.orange;
    }
    if (status == ItemStatus.READY) {
      return Colors.green;
    }
    if (status == ItemStatus.SERVED) {
      return Colors.grey;
    }
    return Colors.amberAccent;
  }

  IconData _statusIcon(ItemStatus status) {
    if (status == ItemStatus.COOK) {
      return Icons.delete_sweep;
    }
    if (status == ItemStatus.READY) {
      return Icons.notifications;
    }
    if (status == ItemStatus.SERVED) {
      return Icons.restaurant;
    }
    return Icons.event_note;
  }

  List<Widget> _list() {
    var repo = Repository.get();
    var order = repo.getCurrentOrder(widget.table.id);
    if (order == null) return [];
    var children = order.items.map((item) {
      var dish = repo.getDish(item.dishId);

      return ListTile(
        title: Text((dish?.name) ?? item.dishId),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              color: _statusColor(item.status),
              child: SizedBox(
                  width: 75,
                  child: Row(
                    children: <Widget>[
                      Icon(_statusIcon(item.status)),
                      SizedBox(width: 5),
                      Text(
                        _statusText(item.status),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
              onPressed: () => _changeStatus(dish, item),
            )
          ],
        ),
      );
    }).toList();
    return [
      ListView(
        children: children,
        shrinkWrap: true,
      )
    ];
  }

  _changeStatus(Dish dish, OrderItem item) {
    var next = item.status;
    if (next == ItemStatus.ORDER) {
      next = ItemStatus.COOK;
    } else if (next == ItemStatus.COOK) {
      next = ItemStatus.READY;
    } else if (next == ItemStatus.READY) {
      next = ItemStatus.SERVED;
    } else if (next == ItemStatus.SERVED) {
      next = ItemStatus.ORDER;
    }
    setState(() {
      item.status = next;
    });
    factory.analytics.logEvent(
        name: "evItemStatus",
        parameters: {'evDish': '${dish.name}', 'evStatus': '${next}'});
    Persistent.save();
  }

  Widget _emptyTable() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 20),
        Image.asset(
          'assets/fishes.jpg',
          height: 150.0,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Table ${widget.table.name} is free",
                style: TextStyle(fontSize: 20)),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                "Open Table",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _openTable,
            ),
          ],
        )
      ],
    );
  }

  Widget _startOrder() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 20),
        Image.asset(
          'assets/fishes.jpg',
          height: 150.0,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Currently, there is no order",
                style: TextStyle(fontSize: 20)),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                "Create New Order",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _edit,
            ),
          ],
        )
      ],
    );
  }

  Widget _body(Order order) {
    if (order == null) {
      // Just welcome customer, no order yet
      return _emptyTable();
    }
    if (order.items.isEmpty) {
      return _startOrder();
    }
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        ..._list(),
      ],
    );
  }

  _openTable() async {
    factory.analytics.logEvent(name: "eventOpenTable");
    var table = widget.table;
    var order = Repository.get().getCurrentOrder(table.id);
    if (order != null && order.items.isNotEmpty) {
      return;
    }
    order = new Order(table.id);
    Repository.get().setCurrentOrder(table.id, order);
    setState(() {});
  }

  _edit() async {
    factory.analytics.logEvent(name: "eventEdit");
    var table = widget.table;
    var order = Repository.get().getCurrentOrder(table.id);
    if (order == null) {
      order = new Order(table.id);
    }
    order = await Navigate.push(
        context, Screen.EditOrderItemPage, (context) => TableOrderPage(order));
    if (order != null) {
      Repository.get().setCurrentOrder(table.id, order);
      setState(() {});
    }
  }

  _bill() {
    factory.analytics.logEvent(name: "evBill");
    var table = widget.table;
    var order = Repository.get().getCurrentOrder(table.id);
    if (order == null) return;
    Navigate.push(context, Screen.BillPage, (context) => BillPage(order));
  }

  void _clear() {
    factory.analytics.logEvent(name: "evClear");
    var table = widget.table;
    Repository.get().closeTable(table.id);
    Persistent.save();
    setState(() {});
  }

  _footerButton(String text, IconData icon, VoidCallback callback) {
    return Expanded(
      child: FlatButton(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Icon(icon),
            SizedBox(height: 5),
            Text(text),
            SizedBox(height: 5),
          ],
        ),
        onPressed: callback,
      ),
    );
  }

  _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _footerButton("Edit", Icons.edit, _edit),
        _footerButton("Bill", Icons.attach_money, _bill),
        _footerButton("Clear", Icons.close, _clear),
      ],
    );
  }
}
