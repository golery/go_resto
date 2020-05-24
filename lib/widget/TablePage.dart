import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';
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
//      floatingActionButton: FloatingActionButton(
//        onPressed: _ok,
//        child: Icon(Icons.check),
//      ),
    );
  }

  String _statusText(ItemStatus status) {
    if (status == ItemStatus.COOK) {
      return "Cooking";
    }
    if (status == ItemStatus.READY) {
      return "Ready";
    }
    if (status == ItemStatus.SERVED) {
      return "Served";
    }
    return "Ordering";
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
              child: Text(_statusText(item.status)),
              onPressed: () => _changeStatus(item),
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

  _changeStatus(OrderItem item) {
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
  }

  bool _empty = true;

  Widget _emptyTable() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 20),
        Image.asset(
          'assets/fishes.jpg',
          height: 200.0,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Table ${widget.table.name} is empty",
                style: TextStyle(fontSize: 20)),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                "New Order",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightGreen,
              highlightColor: Colors.lightGreenAccent,
              onPressed: _edit,
            ),
          ],
        )
      ],
    );
  }

  Widget _body(Order order) {
    if (order == null) {
      return _emptyTable();
    }
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('EDIT'),
              onPressed: _edit,
            ),
            RaisedButton(
              child: Text('BILL'),
              onPressed: _bill,
            ),
            RaisedButton(
              child: Text('CLOSE'),
              onPressed: _close,
            ),
          ],
        ),
        ..._list(),
      ],
    );
  }

  _edit() async {
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
    var table = widget.table;
    var order = Repository.get().getCurrentOrder(table.id);
    if (order == null) return;
    Navigate.push(context, Screen.BillPage, (context) => BillPage(order));
  }

  _ok() {}

  void _close() {
    var table = widget.table;
    Repository.get().closeTable(table.id);
    setState(() {});
  }
}
