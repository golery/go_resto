import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';

class EditQuantityPage extends StatefulWidget {
  OrderItem _order;

  @override
  _State createState() => _State();
}

class _State extends State<EditQuantityPage> {
  final noteController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    noteController.text = "ada";
    quantityController.text = "12";
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            IconButton(icon: Icon(Icons.remove_circle_outline, size: 50)),
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
                        ),
                        style: TextStyle(fontSize: 50)))),
            IconButton(icon: Icon(Icons.add_circle_outline, size: 50)),
          ]),
          SizedBox(height: 40),
          Text("Notes: "),
          TextFormField(
            controller: noteController,
            maxLines: 3,
            decoration: new InputDecoration(
              hintText: "Notes",
            ),
          ),
        ],
      ),
    );
  }

  _ok() {}
}
