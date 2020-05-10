import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';
import 'package:intl/intl.dart';

class BillPage extends StatefulWidget {
  Order order;

  BillPage(this.order);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BillPage> {
  final TextStyle style = TextStyle(fontSize: 20);
  final formatter = NumberFormat("###.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill"),
        actions: <Widget>[],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: _ok,
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _body() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        _bar(),
        SizedBox(height: 5),
        ..._items(),
        _row("Subtotal", formatter.format(10)),
        _row("VAT 10%", formatter.format(10)),
        _row("Tip 10%", formatter.format(10)),
        SizedBox(height: 15),
        ..._sum(),
        SizedBox(height: 5),
        _bar(),
      ],
    );
  }

  Container _bar() {
    return Container(
      height: 10,
      decoration: new BoxDecoration(color: Colors.black),
    );
  }

  List<Widget> _items() {
    final order = widget.order;
    final repo = Repository.get();
    return order.items.map((item) {
      var dish = repo.getDish(item.dishId);
      return _row(dish.name, formatter.format(dish.price));
    }).toList();
  }

  Widget _row(String text1, String text2) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(text1, style: style)),
          Text(text2, style: style),
        ],
      ),
    );
  }

  List<Widget> _sum() {
    return [
      _row("Total 10%", formatter.format(10)),
    ];
  }

  _ok() {
    Navigator.pop(context);
  }
}
