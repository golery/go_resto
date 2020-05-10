import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';

class BillPage extends StatefulWidget {
  Order order;

  BillPage(this.order);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BillPage> {
  final TextStyle style = TextStyle(fontSize: 20);

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
        Container(
          height: 10,
          decoration: new BoxDecoration(color: Colors.black),
        ),
        SizedBox(height: 5),
        ..._items(),
        ..._sum(),
        SizedBox(height: 5),
        Container(
          height: 10,
          decoration: new BoxDecoration(color: Colors.black),
        ),
      ],
    );
  }

  List<Widget> _items() {
    final order = widget.order;
    final repo = Repository.get();
    return order.items.map((item) {
      var dish = repo.getDish(item.dishId);
      return _row(dish.name, "\$ ${dish.price}");
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
      _row("VAT 10%", "\$ 15"),
      _row("Tip 10%", "\$ 15"),
      _row("Total 10%", "\$ 15"),
    ];
  }

  _ok() {
    Navigator.pop(context);
  }
}
