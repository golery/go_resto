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
      body: _body(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _ok,
//        child: Icon(Icons.check),
//      ),
    );
  }

  List<Widget> _list() {
    var repo = Repository.get();
    var order = repo.getCurrentOrder(widget.table.id);
    if (order == null) return [];
    var children = order.items.map((item) {
      var dish = repo.getDish(item.dishId);
      return ListTile(title: Text((dish?.name) ?? item.dishId));
    }).toList();
    return [
      ListView(
        children: children,
        shrinkWrap: true,
      )
    ];
  }

  Widget _body() {
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
    Repository.get().setCurrentOrder(table.id, order);
  }

  _bill() {
    var table = widget.table;
    var order = Repository.get().getCurrentOrder(table.id);
    if (order == null) return;
    Navigate.push(context, Screen.BillPage, (context) => BillPage(order));
  }

  _ok() {}
}
