import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';
import 'package:goresto/service/Factory.dart';

class EditOrderItemPage extends StatefulWidget {
  List<OrderItem> items;
  String dishId;

  EditOrderItemPage(this.dishId, this.items);

  @override
  _State createState() => _State();
}

class _State extends State<EditOrderItemPage> {
  final quantityController = TextEditingController();
  num originalQuantity;

  @override
  void initState() {
    num originalQuantity = _getQuantity(widget.dishId);
    quantityController.text = "$originalQuantity";
    super.initState();
  }

  num _getQuantity(String dishId) {
    return widget.items
        .where((item) => item.dishId == dishId)
        .map((e) => e.quantity)
        .reduce((a, b) => a + b);
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit item"),
        actions: <Widget>[],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: _ok,
        child: Icon(Icons.check),
      ),
    );
  }

  _body() {
    var listItems = widget.items
        .map((item) => ListTile(
            title: Text("Plate"),
            trailing: OutlineButton.icon(
                onPressed: () => _remove(item),
                icon: Icon(Icons.close),
                label: Text("Delete"))))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: listItems,
      ),
    );
  }

  _remove(OrderItem item) {
    factory.analytics.logEvent(name: "evRemoveItem");
    setState(() {
      widget.items.remove(item);
    });
  }

  _ok() {
    Navigator.pop(context, widget.items);
  }
}
