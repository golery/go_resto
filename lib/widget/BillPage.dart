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
    num subTotal = _subTotalAmount();
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        _bar(),
        SizedBox(height: 5),
        ..._items(),
        SizedBox(height: 15),
        _row("Subtotal", formatter.format(subTotal)),
        _row("VAT 10%", formatter.format(subTotal * 0.1)),
        _row("Gratuity 10%", formatter.format(subTotal * 0.1)),
        SizedBox(height: 15),
        _row("Total", formatter.format(subTotal * 1.2)),
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

  num _subTotalAmount() {
    final order = widget.order;
    final repo = Repository.get();
    return order.items.map((item) {
      var dish = repo.getDish(item.dishId);
      return item.quantity * dish.price;
    }).reduce((a, b) => a + b);
  }

  List<Widget> _items() {
    final order = widget.order;
    final repo = Repository.get();
    return order.items.map((item) {
      var dish = repo.getDish(item.dishId);
      var text = dish.name;
      if (item.quantity > 1) {
        text += " (${item.quantity} x ${formatter.format(dish.price)})";
      }
      return _row(text, formatter.format(dish.price * item.quantity));
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

  _ok() {
    Navigator.pop(context);
  }
}
