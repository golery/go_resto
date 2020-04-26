import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goresto/Constants.dart';
import 'package:goresto/Model.dart';

class EditOrderItemPage extends StatefulWidget {
  OrderItem item;

  EditOrderItemPage(this.item);

  @override
  _State createState() => _State();
}

class _State extends State<EditOrderItemPage> {
  final noteController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void initState() {
    OrderItem item = widget.item;
    noteController.text = "${item.notes ?? ""}";
    quantityController.text = "${item.quantity}";
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              _quantityWidget(),
              SizedBox(height: 40),
              Text(
                "Notes: ",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                controller: noteController,
                maxLines: 3,
                style: TextStyle(fontSize: 20),
                decoration: new InputDecoration(
                  hintText: "Notes",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _updateQuantity(num delta) {
    num curr = num.tryParse(quantityController.text);
    if (curr == null) curr = 0;
    curr += delta;
    if (curr < 0) {
      curr = 0;
    }
    quantityController.text = "${curr}";
  }

  _remove() {
    _updateQuantity(-1);
  }

  _add() {
    _updateQuantity(1);
  }

  Row _quantityWidget() {
    var iconColor = Color.fromRGBO(80, 80, 80, 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          iconSize: 80,
          icon: Icon(
            Icons.remove_circle_outline,
            color: iconColor,
          ),
          onPressed: _remove,
        ),
        SizedBox(
            width: 100,
            child: Center(
                child: TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "",
                counterText: "",
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(),
                ),
              ),
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: COLOR_QUANTITY),
            ))),
        IconButton(
          iconSize: 80,
          icon: Icon(Icons.add_circle_outline, color: iconColor),
          onPressed: _add,
        ),
      ],
    );
  }

  _ok() {
    int qty = int.tryParse(quantityController.text);
    if (qty == null) return;

    widget.item.quantity = qty;
    widget.item.notes = noteController.text;

    Navigator.pop(context);
  }
}
